import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/nickname.dart';
import 'package:hoxy/view/alert_platform_dialog.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/view/background_button.dart';
import 'package:hoxy/view/grade_button.dart';
import 'package:hoxy/view/item_relate_list.dart';
import 'package:hoxy/viewmodel/chatting_view_model.dart';
import 'package:hoxy/viewmodel/post_view_model.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class ReadPostScreen extends StatelessWidget {
  ReadPostScreen({required this.postId});

  final String postId;

  Divider divider() {
    return Divider(
      height: 0,
      thickness: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    PostViewModel _postViewModel = PostViewModel();
    ChattingViewModel _chattingViewModel = ChattingViewModel();

    return StreamBuilder<DocumentSnapshot>(
      stream: kFirestore.collection('post').doc(postId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) _postViewModel.post = Post.from(snapshot.data!);
        return StreamBuilder<DocumentSnapshot>(
          stream: _postViewModel.post.writer?.snapshots(),
          builder: (context, snapshot) {
            Member writer = Member();
            if (snapshot.hasData) writer = Member.from(snapshot.data!);
            return StreamBuilder<DocumentSnapshot>(
              stream: _postViewModel.post.chat?.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) _chattingViewModel.chatting = Chatting.from(snapshot.data!);
                _postViewModel.nickname = _chattingViewModel.chatting.nickname[writer.uid] ?? '';
                return Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    title: Text(_postViewModel.post.title),
                    actions: [
                      writer.uid == kAuth.currentUser.uid
                          ? Platform.isIOS
                              ? IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => CupertinoActionSheet(
                                        actions: [
                                          CupertinoActionSheetAction(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              _postViewModel.showUpdatePost(context, writer);
                                            },
                                            child: Text('수정'),
                                          ),
                                          CupertinoActionSheetAction(
                                              isDestructiveAction: true,
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _postViewModel.showDeleteDialog(context);
                                              },
                                              child: Text('삭제')),
                                        ],
                                        cancelButton: CupertinoActionSheetAction(
                                          child: Text('취소'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : PopupMenuButton(
                                  onSelected: (value) {
                                    if (value == '수정')
                                      _postViewModel.showUpdatePost(context, writer);
                                    else if (value == '삭제') _postViewModel.showDeleteDialog(context);
                                  },
                                  itemBuilder: (context) => [
                                    for (String item in ['수정', '삭제'])
                                      PopupMenuItem(
                                        value: item,
                                        child: Text(item),
                                      ),
                                  ],
                                )
                          : Platform.isIOS
                              ? IconButton(
                                  icon: Icon(Icons.more_vert),
                                  onPressed: () {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (context) => CupertinoActionSheet(
                                        actions: [
                                          CupertinoActionSheetAction(
                                            child: Text('모임 신고하기'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                              showCupertinoDialog(
                                                context: context,
                                                builder: (context) {
                                                  String reportContent = '';
                                                  return CupertinoAlertDialog(
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
                                                          onChanged: (value) {
                                                            reportContent = value;
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    actions: [
                                                      CupertinoDialogAction(
                                                        child: Text('취소'),
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                      CupertinoDialogAction(
                                                        child: Text('신고하기'),
                                                        onPressed: () async {
                                                          Navigator.pop(context);
                                                          Loading.show();
                                                          if(await _postViewModel.reportPost(reportContent)) {
                                                            Loading.showSuccess('신고가 접수되었습니다');
                                                          } else {
                                                            Loading.showError('신고 오류');
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  );
                                                }
                                              );
                                            },
                                          ),
                                          CupertinoActionSheetAction(
                                            child: Text('이 주최자와 만나지 않기'),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                        cancelButton: CupertinoActionSheetAction(
                                          child: Text('취소'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : PopupMenuButton(
                                  onSelected: (value) {
                                    if (value == '모임 신고하기') {}
                                    else if (value == '이 주최자와 만나지 않기') {}
                                  },
                                  itemBuilder: (context) => [
                                    for (String item in ['모임 신고하기', '이 주최자와 만나지 않기'])
                                      PopupMenuItem(
                                        value: item,
                                        child: Text(item),
                                      ),
                                  ],
                                )
                    ],
                  ),
                  body: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Text(_postViewModel.post.emoji, style: TextStyle(fontSize: 40)),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('예정시간', style: TextStyle(color: Color.fromRGBO(55, 68, 78, 1.0))),
                                            Text(_postViewModel.formattedTime,
                                              style: TextStyle(fontSize: 14, color: kTimeColor),
                                            ),
                                            SizedBox(height: 6),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "${_postViewModel.post.town} ${timeText(_postViewModel.post.date)}",
                                                  style: TextStyle(fontSize: 12, color: kSubContentColor),
                                                ),
                                                SizedBox(width: 9),
                                                Icon(
                                                  Icons.remove_red_eye_outlined,
                                                  size: 12,
                                                  color: kSubContentColor,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  (_postViewModel.post.view).toString(),
                                                  style: TextStyle(fontSize: 12, color: kSubContentColor),
                                                ),
                                                SizedBox(width: 12),
                                                GradeButton(birth: writer.birth),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          CircularProgressIndicator(
                                            backgroundColor: kProgressBackgroundColor,
                                            value: _chattingViewModel.chatting.member.length / _postViewModel.post.headcount,
                                          ),
                                          Text('${_chattingViewModel.chatting.member.length}/${_postViewModel.post.headcount}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                divider(),
                                Container(
                                  padding: EdgeInsets.only(top: 20, right: 25, left: 25, bottom: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ConstrainedBox(
                                        constraints: BoxConstraints(minHeight: 300),
                                        child: Text(_postViewModel.post.content, style: TextStyle(fontSize: 20)),
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Transform(
                                              alignment: Alignment.center,
                                              transform: Matrix4.rotationY(pi),
                                              child: Icon(CupertinoIcons.tag)),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              '#${_postViewModel.post.tag.join(' #')}',
                                              style: TextStyle(fontSize: 15, color: kTagColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                divider(),
                                Container(
                                  padding: EdgeInsets.only(top: 10, right: 15, left: 25, bottom: 10),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  _postViewModel.nickname,
                                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                                ),
                                                SizedBox(width: 3),
                                                Text(_postViewModel.post.town, style: TextStyle(fontSize: 12, color: kDisabledColor)),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text('인연지수', style: TextStyle(color: kDisabledColor)),
                                                Icon(Icons.help_outline, size: 8),
                                                SizedBox(width: 2),
                                                Container(
                                                  width: 53,
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10),
                                                    child: LinearProgressIndicator(
                                                      minHeight: 8,
                                                      backgroundColor: kExpBackgroundColor,
                                                      valueColor: AlwaysStoppedAnimation<Color>(kExpValueColor),
                                                      value: writer.exp / 100,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        '총 모임참여 ${writer.participation}회',
                                        style: TextStyle(fontSize: 12, color: kDisabledColor),
                                      ),
                                    ],
                                  ),
                                ),
                                divider(),
                                Padding(
                                  padding: EdgeInsets.only(left: 25, top: 8, right: 15),
                                  child: Text('연관모임'),
                                ),
                                //TODO: 연관글이 없으면 안 뜨게 해야
                                for (String tag in _postViewModel.relatedTag()) ItemRelateList(postId: _postViewModel.post.id, tag: tag)
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        //height: 110,
                        child: Column(
                          children: [
                            Divider(
                              height: 1,
                              thickness: 2,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16, right: 16, bottom: Platform.isIOS ? 48 : 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${DateFormat('MM월 dd일 HH시').format(_postViewModel.post.start ?? DateTime.now())} 예정',
                                          style: TextStyle(
                                            color: Color.fromRGBO(26, 59, 196, 1.0),
                                          ),
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              _postViewModel.post.town,
                                              style: TextStyle(fontSize: 14, color: kDisabledColor),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              '${_postViewModel.nickname}님의 모임',
                                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: SizedBox(
                                      width: 142,
                                      height: 44,
                                      child: BackgroundButton(
                                        title: '신청하기',
                                        onPressed: () {
                                          String nickname = randomNickname;

                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertPlatformDialog(
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
                                                    await _chattingViewModel.enterChatRoom(nickname);
                                                    Loading.showSuccess('신청이 완료되었습니다');
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        disabled: _chattingViewModel.chatting.member.contains(kAuth.currentUser.uid),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
