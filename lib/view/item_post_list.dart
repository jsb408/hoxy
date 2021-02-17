import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/read_post_screen.dart';
import 'package:hoxy/view/skeleton.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import 'grade_button.dart';

class ItemPostList extends StatelessWidget {
  ItemPostList({required this.post});

  final QueryDocumentSnapshot post;

  @override
  Widget build(BuildContext context) {
    Post post = Post.from(this.post);

    return FutureBuilder<DocumentSnapshot>(
      future: post.writer!.get(),
      builder: (context, writerSnapshot) {
        Member writer = Member();
        if (writerSnapshot.hasData) writer = Member.from(writerSnapshot.data!);
        return FutureBuilder<DocumentSnapshot>(
          future: post.chat?.get(),
          builder: (context, chatSnapshot) {
            Chatting chatting = Chatting();
            if (chatSnapshot.hasData) chatting = Chatting.from(chatSnapshot.data!);

            if (writer.uid.isEmpty || chatting.id.isEmpty) return ItemPostSkeleton();

            return GestureDetector(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    color: Colors.white,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            post.emoji,
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(post.title, style: TextStyle(fontSize: 18, color: Colors.black)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${DateFormat('MM.dd HH시 mm분').format(post.start ?? DateTime.now())}~${DateFormat('HH시 mm분').format(post.start?.add(Duration(minutes: post.duration)) ?? DateTime.now())} (${NumberFormat('0.#').format(post.duration / 60)}시간)',
                                      style: TextStyle(fontSize: 11, color: kTimeColor)),
                                  SizedBox(width: 12),
                                  GradeButton(birth: writer.birth),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "${post.town} ${timeText(post.date)}",
                                    style: TextStyle(fontSize: 12, color: kSubContentColor),
                                  ),
                                  SizedBox(width: 9),
                                  Icon(
                                    Icons.remove_red_eye_outlined,
                                    size: 12,
                                    color: kSubContentColor,
                                  ),
                                  SizedBox(width: 4),
                                  Text(post.view.toString(), style: TextStyle(fontSize: 12, color: kSubContentColor)),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                '#${post.tag.join(' #')}',
                                style: TextStyle(fontSize: 11, color: kTagColor),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                backgroundColor: kProgressBackgroundColor,
                                value: chatting.member.length / post.headcount,
                              ),
                              Text('${chatting.member.length}/${post.headcount}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    height: 0,
                    thickness: 1,
                  ),
                ],
              ),
              onTap: () {
                kFirestore.collection('post').doc(post.id).update({ 'view' : post.view + 1});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReadPostScreen(postId: post.id)));
              },
            );
          },
        );
      },
    );
  }
}