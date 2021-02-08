import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chat.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';

import '../constants.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({required this.chattingId});

  final String chattingId;

  @override
  Widget build(BuildContext context) {
    TextEditingController _chatController = TextEditingController();

    return StreamBuilder<DocumentSnapshot>(
      stream: kFirestore.collection('chatting').doc(chattingId).snapshots(),
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
                  endDrawer: Drawer(
                    child: Container(),
                  ),
                  body: StreamBuilder<QuerySnapshot>(
                    stream: kFirestore.collection('member').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      List<Member> members = snapshot.data!.docs.map((e) => Member.from(e)).toList();

                      return Column(
                        children: [
                          Expanded(
                            child: ListView(
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
                                    await kFirestore.collection('chatting').doc(chattingId).collection('chat').add({
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
