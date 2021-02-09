import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chat.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/view/grade_button.dart';

import '../constants.dart';

class ChatRoomScreen extends StatefulWidget {
  const ChatRoomScreen({required this.chattingId});

  final String chattingId;

  @override
  _ChatRoomScreenState createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _chatController = TextEditingController();
    ScrollController _chatListScrollController = ScrollController();

    return StreamBuilder<DocumentSnapshot>(
      stream: kFirestore.collection('chatting').doc(widget.chattingId).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

        Chatting chatting = Chatting.from(snapshot.data!);

        return StreamBuilder<QuerySnapshot>(
          stream: chatting.chat?.orderBy('date').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

            List<Chat> chats = snapshot.data!.docs.map((e) => Chat.from(e)).toList();

            return StreamBuilder<DocumentSnapshot>(
              stream: chatting.post!.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                Post post = Post.from(snapshot.data!);

                return Scaffold(
                  appBar: AppBar(
                    title: Text('${chatting.member[post.writer!.id]}님의 모임'),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  endDrawer: ChatRoomDrawer(chatting: chatting, post: post),
                  body: StreamBuilder<QuerySnapshot>(
                    stream: kFirestore.collection('member').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      List<Member> members = snapshot.data!.docs.map((e) => Member.from(e)).toList();
                      SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
                        _chatListScrollController.jumpTo(_chatListScrollController.position.maxScrollExtent);
                      });

                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
                              controller: _chatListScrollController,
                              children: [
                                for (Chat chat in chats)
                                  MessageBubble(
                                    text: chat.content,
                                    sender: members.singleWhere((element) => chat.sender!.id == element.uid),
                                    nickname: chatting.member[chat.sender!.id],
                                  ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 8),
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
                                    ),
                                  ),
                                ),
                                TextButton(
                                  child: Icon(Icons.send),
                                  onPressed: () async {
                                    await kFirestore.collection('chatting').doc(widget.chattingId).collection('chat').add({
                                      'content': _chatController.text,
                                      'sender': kFirestore.collection('member').doc(kAuth.currentUser.uid),
                                      'date': DateTime.now()
                                    });
                                    _chatController.clear();
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      );
                    },
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

class ChatRoomDrawer extends StatelessWidget {
  const ChatRoomDrawer({required this.chatting, required this.post});

  final Chatting chatting;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Text(post.emoji, style: TextStyle(fontSize: 40)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('수지구청 30대초 술번개'),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('01.19 18~21시 (3시간)'),
                            GradeButton(birth: 1990),
                          ],
                        ),
                        Text('#재밌게 놀아요'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.text, required this.sender, required this.nickname});

  final String text;
  final Member sender;
  final String nickname;

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
          if (!isMe) Text(sender.emoji, style: TextStyle(fontSize: 30)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isMe)
                Text(
                  nickname,
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
