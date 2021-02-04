import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/post.dart';

class ItemChattingList extends StatelessWidget {
  ItemChattingList({required this.chatting});

  final QueryDocumentSnapshot chatting;

  @override
  Widget build(BuildContext context) {
    Chatting chatting = Chatting.from(this.chatting);

    return StreamBuilder<DocumentSnapshot>(
      stream: chatting.post!.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        
        Post post = Post.from(snapshot.data!);
        
        return StreamBuilder<QuerySnapshot>(
          stream: chatting.chat?.orderBy('date', descending: true).snapshots(),
          builder: (context, snapshot) {
            return Row(
              children: [
                Column(
                  children: [
                    Text('${chatting.member[post.writer!.id]}님의 모임')
                  ],
                )
              ],
            );
          },
        );
      },
    );
  }
}
