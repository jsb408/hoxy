import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chat.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/profile_screen.dart';
import 'package:hoxy/screen/read_post_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/view/alert_platform_dialog.dart';
import 'package:hoxy/view/grade_button.dart';
import 'package:hoxy/view/item_member_list.dart';
import 'package:hoxy/viewmodel/chat_view_model.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

import '../constants.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({required this.chattingId});

  final String chattingId;

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  ChatViewModel _viewModel = ChatViewModel();

  @override
  Widget build(BuildContext context) {
    TextEditingController _chatController = TextEditingController();

    return StreamBuilder<DocumentSnapshot>(
      stream: kFirestore.collection('chatting').doc(widget.chattingId).snapshots(),
      builder: (context, snapshot) {
        Chatting chatting = Chatting();
        if (snapshot.hasData) chatting = Chatting.from(snapshot.data!);
        return StreamBuilder<QuerySnapshot>(
          stream: chatting.chat?.orderBy('date', descending: true).snapshots(),
          builder: (context, snapshot) {
            List<Chat> chats = [];
            if (snapshot.hasData) chats = snapshot.data!.docs.map((e) => Chat.from(e)).toList();
            return StreamBuilder<DocumentSnapshot>(
              stream: chatting.post?.snapshots(),
              builder: (context, snapshot) {
                Post post = Post();
                if (snapshot.hasData) post = Post.from(snapshot.data!);

                AppBar appBar = AppBar(
                  title: Text(post.title),
                  leading: IconButton(
                    icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                );

                return StreamBuilder<QuerySnapshot>(
                  stream: kFirestore.collection('member').snapshots(),
                  builder: (context, snapshot) {
                    List<Member> members = [];
                    if (snapshot.hasData) members = snapshot.data!.docs.map((e) => Member.from(e)).toList();

                    return Scaffold(
                      appBar: appBar,
                      endDrawer: ChatRoomDrawer(
                        chatting: chatting,
                        post: post,
                        members: members,
                        topPadding: appBar.preferredSize.height,
                      ),
                      body: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.zero,
                              reverse: true,
                              children: [
                                for (Chat chat in chats)
                                  MessageBubble(
                                    text: chat.content,
                                    sender: members.singleWhere((element) => chat.sender!.id == element.uid),
                                    chatting: chatting,
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                              top: 8,
                              bottom: Platform.isIOS ? 28 : 8,
                            ),
                            color: kPrimaryColor,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 14),
                                    child: TextField(
                                      controller: _chatController,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(left: 14),
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: '메세지 입력',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(Radius.circular(10)),
                                        ),
                                      ),
                                      onChanged: (value) {
                                        _viewModel.chat.content = value;
                                      },
                                    ),
                                  ),
                                ),
                                TextButton(
                                  child: Icon(Icons.send),
                                  onPressed: () async {
                                    _viewModel.sendChat(widget.chattingId);
                                    _chatController.clear();
                                  },
                                )
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
      },
    );
  }
}

class ChatRoomDrawer extends StatelessWidget {
  const ChatRoomDrawer({required this.chatting, required this.post, required this.members, this.topPadding = 0});

  final Chatting chatting;
  final Post post;
  final List<Member> members;
  final double topPadding;

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
                                  fontSize: 11,
                                  color: kTimeColor,
                                ),
                              ),
                              GradeButton(
                                  birth: members.singleWhere((element) => element.uid == post.writer!.id).birth),
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
                        isMe: post.writer!.id == kAuth.currentUser.uid,
                      ),
                      if (post.writer!.id != kAuth.currentUser.uid)
                        ItemMemberList(
                            member: members.singleWhere((element) => element.uid == kAuth.currentUser.uid),
                            chatting: chatting,
                            isMe: true),
                      for (Member member in members.where((element) =>
                          chatting.member.contains(element.uid) &&
                          element.uid != post.writer!.id &&
                          element.uid != kAuth.currentUser.uid))
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
              post.writer!.id == kAuth.currentUser.uid
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
                                  List<String> member = chatting.member;
                                  member.remove(kAuth.currentUser.uid);
                                  await kFirestore
                                      .collection('chatting')
                                      .doc(chatting.id)
                                      .update({'member': member});
                                  Loading.dismiss();
                                  Navigator.pop(context);
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

class ChattingDrawerButton extends StatelessWidget {
  const ChattingDrawerButton({required this.icon, required this.text, required this.onTap});

  final IconData icon;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Color(0xFF707070),
                ),
                SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text, required this.sender, required this.chatting});

  final String text;
  final Member sender;
  final Chatting chatting;

  bool get isMe => sender.uid == kAuth.currentUser.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: Text(sender.emoji, style: TextStyle(fontSize: 30)),
              ),
              onTap: () {
                ProfileScreen.present(context, sender, chatting);
              },
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isMe)
                Text(
                  chatting.nickname[sender.uid],
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
              Material(
                borderRadius: isMe
                    ? BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                        bottomLeft: Radius.circular(5.0),
                      )
                    : BorderRadius.only(
                        topLeft: Radius.circular(5.0),
                        topRight: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ),
                color: isMe ? kPrimaryColor : Colors.white,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
