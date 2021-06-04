import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/chat_room_screen.dart';
import 'package:hoxy/view/skeleton.dart';
import 'package:intl/intl.dart';

class ItemChattingList extends StatelessWidget {
  ItemChattingList({required this.chatting});

  final Chatting chatting;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: chatting.post!.snapshots(),
      builder: (context, snapshot) {
        Post post = Post();
        if (snapshot.hasData) post = Post.from(snapshot.data!);

        return StreamBuilder<QuerySnapshot>(
          stream: chatting.chat?.orderBy('date', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (post.id.isEmpty || !snapshot.hasData) {
              return ItemChattingSkeleton();
            }

            QueryDocumentSnapshot? recentChat = snapshot.data!.docs.isNotEmpty ? snapshot.data!.docs.first : null;

            return GestureDetector(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    color: Colors.white,
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${post.title} ',
                                      style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                                    ),
                                    TextSpan(
                                      text: post.town,
                                      style: TextStyle(fontSize: 12, color: kDisabledColor),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                recentChat?.get('content') ?? '최근 대화가 없습니다.',
                                style: TextStyle(color: Color.fromRGBO(168, 168, 168, 1.0), fontSize: 12),
                              ),
                              SizedBox(height: 9),
                              Text(
                                '#${post.tag.join(' #')}',
                                style: TextStyle(color: kTagColor, fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          DateFormat('M/dd HH시 예정').format(post.start!),
                          style: TextStyle(color: kTimeColor),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 0, thickness: 2),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatRoomScreen(chattingId: this.chatting.id)));
              },
            );
          },
        );
      },
    );
  }
}
