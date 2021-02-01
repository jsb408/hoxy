import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/view/background_button.dart';
import 'package:hoxy/view/grade_button.dart';
import 'package:hoxy/view/item_relate_list.dart';
import 'package:intl/intl.dart';

class ReadPostScreen extends StatelessWidget {
  ReadPostScreen(
      {@required this.post, @required this.writer, @required this.chatting});

  final Post post;
  final Member writer;
  final Chatting chatting;

  Divider divider() {
    return Divider(
      height: 0,
      thickness: 1,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String writerName = chatting.member.keys
        .toList()[chatting.member.values.toList().indexOf(writer.uid)];

    kFirestore.collection('post').doc(post.id).update({'view': post.view + 1});

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(post.title),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(post.emoji,
                                style: TextStyle(fontSize: 40)),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('예정시간',
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(55, 68, 78, 1.0))),
                                Text(
                                  '${DateFormat('MM.dd HH시 mm분').format(post.start)}~${DateFormat('HH시 mm분').format(post.start.add(Duration(minutes: post.duration)))} (${NumberFormat('0.#').format(post.duration / 60)}시간)',
                                  style: TextStyle(
                                      fontSize: 16, color: kTimeColor),
                                ),
                                SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${post.town} ${timeText(post.date)}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: kSubContentColor),
                                    ),
                                    SizedBox(width: 9),
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 12,
                                      color: kSubContentColor,
                                    ),
                                    SizedBox(width: 4),
                                    Text((post.view + 1).toString(),
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: kSubContentColor)),
                                    SizedBox(width: 12),
                                    GradeButton(birth: writer.birth),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                backgroundColor: kProgressBackgroundColor,
                                value: chatting.member.length / post.headcount,
                              ),
                              Text(
                                  '${chatting.member.length}/${post.headcount}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    divider(),
                    Container(
                      padding: EdgeInsets.only(
                          top: 20, right: 25, left: 25, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 300),
                            child: Text(post.content,
                                style: TextStyle(fontSize: 20)),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(CupertinoIcons.tag),
                              SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  '#${post.tag.join(' #')}',
                                  style:
                                      TextStyle(fontSize: 15, color: kTagColor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    divider(),
                    Container(
                      padding: EdgeInsets.only(
                          top: 10, right: 15, left: 25, bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      writerName,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(post.town,
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: kDisabledColor)),
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('인연지수',
                                        style:
                                            TextStyle(color: kDisabledColor)),
                                    Icon(Icons.help_outline, size: 14),
                                    Container(
                                      width: 53,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: LinearProgressIndicator(
                                          minHeight: 8,
                                          backgroundColor:
                                              kProgressBackgroundColor,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  kProgressValueColor),
                                          value: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '총 모임참여 55회',
                            style:
                                TextStyle(fontSize: 12, color: kDisabledColor),
                          ),
                        ],
                      ),
                    ),
                    divider(),
                    Padding(
                      padding: EdgeInsets.only(left: 25, top: 8, right: 15),
                      child: Text('연관모임'),
                    ),
                    for (int i = 0; i < 3; i++)
                      ItemRelateList(
                          tag: post.tag[Random().nextInt(post.tag.length)]),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 110,
            child: Column(
              children: [
                Divider(
                  height: 1,
                  thickness: 2,
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16, right: 16, bottom: 48),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '1월 19일 18시 예정',
                              style: TextStyle(
                                color: Color.fromRGBO(26, 59, 196, 1.0),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  post.town,
                                  style: TextStyle(
                                      fontSize: 16, color: kDisabledColor),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  '$writerName님의 모임',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: SizedBox(
                            width: 142,
                            height: 44,
                            child: BackgroundButton(
                                title: '신청하기', onPressed: () {})),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
