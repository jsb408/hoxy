import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/write_post_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/view/alert_platform_dialog.dart';
import 'package:hoxy/view/platform_action_sheet.dart';
import 'package:intl/intl.dart';

import '../nickname.dart';

class ReadPostViewModel extends GetxController {
  ReadPostViewModel({required String postId}) {
    loadPost(postId);
  }

  String nickname = randomNickname;

  get formattedTime => '$formattedStartTime~${DateFormat('HH시 mm분').format((post.start ?? DateTime.now()).add(Duration(minutes: post.duration)))} (${NumberFormat('0.#').format(post.duration / 60)}시간)';
  get formattedStartTime => DateFormat('MM월 dd일 HH:mm').format(post.start ?? DateTime.now());

  Rx<Post> _post = Post().obs;
  Post get post => _post.value;

  Member _writer = Member();
  Member get writer => _writer;

  Chatting _chatting = Chatting();
  Chatting get chatting => _chatting;

  void loadPost(String postId) {
    Loading.show();
    kFirestore.collection('post').doc(postId).snapshots().listen((event) {
      _post.value = Post.from(event);
      update();
    });
  }

  @override
  void onInit() {
    super.onInit();

    once(_post, (Post value) => value.writer!.get().then((event) {
      _writer = Member.from(event);
      value.chat!.get().then((event) {
        _chatting = Chatting.from(event);
        nickname = _chatting.nickname[_writer.uid];

        update();
        Loading.dismiss();
      });
    }));
  }

  void goToUpdatePost() => Get.to(() => WritePostScreen(post: _post.value.id));

  void showDeleteDialog() {
    Get.dialog(AlertPlatformDialog(
        title: Text('삭제하기'),
        content: Text('삭제하시겠습니까?'),
        children: [
          AlertPlatformDialogButton(
            child: Text('아니오'),
            onPressed: () {},
          ),
          AlertPlatformDialogButton(
            child: Text('예'),
            onPressed: () {
              Get.back();
              deletePost();
            },
          ),
        ],
    ),
    );
  }

  Future<bool> reportPost(String content) async {
    try {
      await kFirestore.collection('report').add({
        'writer': kFirestore.collection('member').doc(kAuth.currentUser?.uid),
        'post': kFirestore.collection('post').doc(post.id),
        'date': DateTime.now(),
        'content': content
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> enterChatRoom(String nickname) async {
    chatting.member.add(kAuth.currentUser!.uid);

    DocumentSnapshot myInfoSnapshot = await kFirestore.collection('member').doc(kAuth.currentUser!.uid).get();
    Member myInfo = Member.from(myInfoSnapshot);

    await kFirestore
        .collection('chatting')
        .doc(chatting.id)
        .update({
      'member': chatting.member,
      'nickname.${kAuth.currentUser?.uid}': nickname,
    }).catchError((error) {
      print(error);
      Loading.showError('신청 오류');
    });
    await kFirestore
        .collection('chatting')
        .doc(chatting.id)
        .update({
      'date': DateTime.now()
    });
    kFirestore.collection('member').doc(kAuth.currentUser!.uid).update({
      'participation': myInfo.participation + 1
    });
    kFirestore.collection('alert').add({
      'type': 'apply',
      'date': DateTime.now(),
      'uid': post.writer!.id,
      'title': nickname + '님이 모임에 참가했습니다',
      'content': '\'${post.title}\' 모임에 새로운 참가 신청이 왔어요\n환영 인사를 해주세요~',
      'emoji': myInfo.emoji,
      'target': chatting.id,
    });
  }

  void deletePost() {
    try {
      post.chat!.delete().whenComplete(() => kFirestore.collection('post').doc(post.id).delete());
    } catch (e) {
      print(e);
    }
  }

  PlatformActionSheet writerActionSheet() => PlatformActionSheet(
      actions: [
        PlatformActionSheetAction(
          value: 0,
          child: Text('수정'),
          onPressed: () => goToUpdatePost(),
        ),
        PlatformActionSheetAction(
          value: 1,
          isDestructiveAction: true,
          child: Text('삭제'),
          onPressed: () => showDeleteDialog(),
        ),
      ],
      cancelButton: PlatformActionSheetAction(
        value: 2,
        child: Text('취소'),
        onPressed: () {},
      ),
    );

  PlatformActionSheet viewerActionSheet() => PlatformActionSheet(
    actions: [
      PlatformActionSheetAction(
        value: 0,
        child: Text('모임 신고하기'),
        onPressed: () {
          String reportContent = '';
          Get.dialog(
              AlertPlatformDialog(
                title: Text('신고하기'),
                content: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Container(
                    color: Colors.white,
                    height: 100,
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '신고할 내용을 입력해주세요',
                        contentPadding: EdgeInsets.only(left: 8),
                        hintStyle: TextStyle(
                          height: 0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onChanged: (value) => reportContent = value
                    ),
                  ),
                ),
                children: [
                  AlertPlatformDialogButton(
                    child: Text('취소'),
                    onPressed: () {},
                  ),
                  AlertPlatformDialogButton(
                    child: Text('신고하기'),
                    onPressed: () async {
                      Loading.show();
                      if (await reportPost(reportContent))
                        Loading.showSuccess('신고가 접수되었습니다');
                      else
                        Loading.showError('신고 오류');
                    },
                  ),
                ],
              ),);
        },
      ),
      PlatformActionSheetAction(
        value: 1,
        child: Text('이 주최자와 만나지 않기'),
        onPressed: () {
          Get.dialog(
            AlertPlatformDialog(
              title: Text('만나지 않기'),
              content: Text('이 유저의 모임글을 숨기시겠습니까?'),
              children: [
                AlertPlatformDialogButton(
                  child: Text('아니오'),
                  onPressed: () {},
                ),
                AlertPlatformDialogButton(
                  child: Text('네'),
                  onPressed: () async {
                    Loading.show();
                    Get.back();

                    DocumentReference banned = await kFirestore
                        .collection('member')
                        .doc(writer.uid)
                        .collection('ban')
                        .add({
                      'user': kFirestore.collection('member').doc(kAuth.currentUser?.uid),
                      'date': DateTime.now(),
                      'chatting': kFirestore.collection('chatting').doc(chatting.id),
                      'active': false,
                    });

                    await kFirestore
                        .collection('member')
                        .doc(kAuth.currentUser?.uid)
                        .collection('ban')
                        .add({
                      'user': kFirestore.collection('member').doc(writer.uid),
                      'date': DateTime.now(),
                      'chatting': kFirestore.collection('chatting').doc(chatting.id),
                      'active': true,
                      'pair': banned,
                    });

                    Loading.dismiss();
                  },
                ),
              ],
            ),
          );
        },
      ),
    ],
    cancelButton: PlatformActionSheetAction(
      value: 2,
      child: Text('취소'),
      onPressed: () {},
    ),
  );

  void showApplyDialog() {
    String nickname = randomNickname;

    Get.dialog(AlertPlatformDialog(
        title: Text('신청하기'),
        content: Text('$nickname(으)로 참가합니다.\n'
            '참가를 신청하시겠습니까?'),
        children: [
          AlertPlatformDialogButton(
            child: Text('아니오'),
            onPressed: () {},
          ),
          AlertPlatformDialogButton(
            child: Text('예'),
            onPressed: () async {
              Loading.show();
              await enterChatRoom(nickname);
              Loading.showSuccess('신청이 완료되었습니다');
              update();
            },
          ),
        ],
      ),
    );
  }
}