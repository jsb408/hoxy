import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/read_post_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import 'alert_platform_dialog.dart';
import 'chatting_drawer_button.dart';
import 'grade_button.dart';
import 'item_member_list.dart';

import 'dart:io' show Platform;

class ChatRoomDrawer extends StatelessWidget {
  const ChatRoomDrawer(
      {required this.chatting,
      required this.post,
      required this.members,
      this.topPadding = 0});

  final Chatting chatting;
  final Post post;
  final List<Member> members;
  final double topPadding;

  Future<void> escapeChatRoom() async {
    chatting.member.remove(kAuth.currentUser?.uid);
    await kFirestore
        .collection('chatting')
        .doc(chatting.id)
        .update({'member': chatting.member});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + topPadding),
      child: ClipRRect(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(10)),
        child: Drawer(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 32, bottom: 24, left: 8, right: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(post.emoji, style: TextStyle(fontSize: 40)),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.title, style: TextStyle(fontSize: 18)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${DateFormat('MM.dd HH시 mm분').format(post.start ?? DateTime.now())}~${DateFormat('HH시 mm분').format(post.start?.add(Duration(minutes: post.duration)) ?? DateTime.now())} (${NumberFormat('0.#').format(post.duration / 60)}시간)',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: kTimeColor,
                                ),
                              ),
                              GradeButton(
                                  birth: members
                                      .singleWhere((element) => element.uid == post.writer!.id)
                                      .birth),
                            ],
                          ),
                          Text(
                            '#${post.tag.join(' #')}',
                            style: TextStyle(
                              fontSize: 11,
                              color: kTagColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 22, top: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '참여 멤버 ',
                            style: TextStyle(
                              fontSize: 18,
                              color: Color(0xFF707070),
                            ),
                          ),
                          Text(
                            '${chatting.member.length}/${post.headcount}',
                            style: TextStyle(fontSize: 12, color: kTimeColor),
                          ),
                        ],
                      ),
                      ItemMemberList(
                        member: members.singleWhere((element) => element.uid == post.writer!.id),
                        chatting: chatting,
                        isLeader: true,
                        isMe: post.writer!.id == kAuth.currentUser?.uid,
                      ),
                      if (post.writer!.id != kAuth.currentUser?.uid)
                        ItemMemberList(
                            member: members
                                .singleWhere((element) => element.uid == kAuth.currentUser?.uid),
                            chatting: chatting,
                            isMe: true),
                      for (Member member in members.where((element) =>
                          chatting.member.contains(element.uid) &&
                          element.uid != post.writer!.id &&
                          element.uid != kAuth.currentUser?.uid))
                        ItemMemberList(member: member, chatting: chatting),
                    ],
                  ),
                ),
              ),
              ChattingDrawerButton(
                icon: CupertinoIcons.doc_text,
                text: '모임글 보기',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReadPostScreen(postId: post.id)),
                  );
                },
              ),
              post.writer!.id == kAuth.currentUser?.uid
                  ? ChattingDrawerButton(
                      icon: CupertinoIcons.xmark_circle,
                      text: '모임 종료하기',
                      onTap: () {},
                    )
                  : ChattingDrawerButton(
                      icon: CupertinoIcons.escape,
                      text: '나가기',
                      onTap: () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertPlatformDialog(
                            title: Text('나가기'),
                            content: Text('모임에서 퇴장하시겠습니까?'),
                            children: [
                              AlertPlatformDialogButton(child: Text('아니오'), onPressed: () {}),
                              AlertPlatformDialogButton(
                                child: Text('예'),
                                onPressed: () async {
                                  Loading.show();
                                  escapeChatRoom();
                                  Navigator.pop(context);
                                  Loading.dismiss();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
              SizedBox(height: Platform.isIOS ? 30 : 10),
            ],
          ),
        ),
      ),
    );
  }
}
