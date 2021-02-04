import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/view/item_chatting_list.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채팅'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: kFirestore.collection('chatting').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> myChattingList = snapshot.data!.docs
              .where((element) =>
                  (element.get('member') as Map<String, dynamic>)
                      .containsKey(kAuth.currentUser.uid)).toList();

          if (myChattingList.isEmpty) {
            return Center(child: Text('채팅이 없습니다'));
          }

          return ListView(
            children: [
              for (QueryDocumentSnapshot chatting in myChattingList)
                ItemChattingList(chatting: chatting)
            ],
          );
        },
      ),
    );
  }
}
