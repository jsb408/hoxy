import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chat.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';

class ChatRoomScreen extends StatelessWidget {
  const ChatRoomScreen({required this.chattingSnapshot, required this.chatSnapshot, required this.postSnapshot});

  final QueryDocumentSnapshot chattingSnapshot;
  final QuerySnapshot chatSnapshot;
  final DocumentSnapshot postSnapshot;

  Post get post => Post.from(postSnapshot);
  Chatting get chatting => Chatting.from(chattingSnapshot);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${chatting.member[post.writer!.id]}님의 모임'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: kFirestore.collection('member').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<Member> members = snapshot.data!.docs.map((e) => Member.from(e)).toList();
          List<Chat> chats = chatSnapshot.docs.map((e) => Chat.from(e)).toList();

          return Column(
            children: [
              Expanded(child: ListView(
                children: [
                  for(Chat chat in chats)
                    Text(members.singleWhere((element) => chat.sender!.id == element.uid).emoji),
                ],
              ),)
            ],
          );
        },
      ),
    );
  }
}