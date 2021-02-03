import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/read_post_screen.dart';
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
        if (!writerSnapshot.hasData) {
          return Container(height: 120, child: Center(child: CircularProgressIndicator()));
        }

        Member writer = Member.from(writerSnapshot.data!);
        return FutureBuilder<DocumentSnapshot>(
          future: post.chat!.get(),
          builder: (context, chatSnapshot) {
            if (!chatSnapshot.hasData) {
              return Container(height: 120, child: Center(child: CircularProgressIndicator()));
            }

            Chatting chatting = Chatting.from(chatSnapshot.data!);
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
                                      '${DateFormat('MM.dd HH시 mm분').format(post.start)}~${DateFormat('HH시 mm분').format(post.start.add(Duration(minutes: post.duration)))} (${NumberFormat('0.#').format(post.duration / 60)}시간)',
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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ReadPostScreen(post: post, writer: writer, chatting: chatting)));
              },
            );
          },
        );
      },
    );
  }
}

class PostSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
    );
  }
}
