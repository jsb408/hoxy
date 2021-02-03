import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/write_post_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/view/background_button.dart';
import 'package:hoxy/view/grade_button.dart';
import 'package:hoxy/view/item_relate_list.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class ReadPostScreen extends StatelessWidget {
  ReadPostScreen({required this.post, required this.writer, required this.chatting});

  final Post post;
  final Member writer;
  final Chatting chatting;

  Divider divider() {
    return Divider(
      height: 0,
      thickness: 1,
    );
  }

  void updatePost(BuildContext context, String nickname) {
    //TODO: 수정해도 바로 반영 안되는 버그 수정 필요
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => WritePostScreen(user: writer, originalPost: post, nickname: nickname)));
  }

  void deletePost(BuildContext context) {
    Loading.show();
    post.chat!
        .delete()
        .whenComplete(() => kFirestore.collection('post').doc(post.id).delete().whenComplete(() {
              Navigator.pop(context);
              Loading.showSuccess('삭제 성공');
            }).catchError((error) {
              print(error);
              Loading.showError('삭제 실패');
            }))
        .catchError((error) {
      print(error);
      Loading.showError('삭제 실패');
    });
  }

  @override
  Widget build(BuildContext context) {
    final String writerName = chatting.member.keys.toList()[chatting.member.values.toList().indexOf(writer.uid)];

    kFirestore.collection('post').doc(post.id).update({'view': post.view + 1});

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(post.title),
        actions: [
          if (writer.uid == kAuth.currentUser.uid)
            Platform.isIOS
                ? IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      updatePost(context, writerName);
                                    },
                                    child: Text('수정'),
                                  ),
                                  CupertinoActionSheetAction(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        deletePost(context);
                                      },
                                      child: Text('삭제')),
                                ],
                                cancelButton: CupertinoActionSheetAction(
                                  child: Text('취소'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ));
                    },
                  )
                : PopupMenuButton(
                    onSelected: (value) {
                      if (value == '수정')
                        updatePost(context, writerName);
                      else if (value == '삭제') deletePost(context);
                    },
                    itemBuilder: (context) {
                      return [
                        for (String item in ['수정', '삭제'])
                          PopupMenuItem(
                            value: item,
                            child: Text(item),
                          ),
                      ];
                    },
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
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(post.emoji, style: TextStyle(fontSize: 40)),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('예정시간', style: TextStyle(color: Color.fromRGBO(55, 68, 78, 1.0))),
                                    Text(
                                      '${DateFormat('MM.dd HH시 mm분').format(post.start)}~${DateFormat('HH시 mm분').format(post.start.add(Duration(minutes: post.duration)))} (${NumberFormat('0.#').format(post.duration / 60)}시간)',
                                      style: TextStyle(fontSize: 14, color: kTimeColor),
                                    ),
                                    SizedBox(height: 6),
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
                                        Text(
                                          (post.view).toString(),
                                          style: TextStyle(fontSize: 12, color: kSubContentColor),
                                        ),
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
                                  Text('${chatting.member.length}/${post.headcount}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        divider(),
                        Container(
                          padding: EdgeInsets.only(top: 20, right: 25, left: 25, bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ConstrainedBox(
                                constraints: BoxConstraints(minHeight: 300),
                                child: Text(post.content, style: TextStyle(fontSize: 20)),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(CupertinoIcons.tag),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      '#${post.tag.join(' #')}',
                                      style: TextStyle(fontSize: 15, color: kTagColor),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        divider(),
                        Container(
                          padding: EdgeInsets.only(top: 10, right: 15, left: 25, bottom: 10),
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
                                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                        ),
                                        Text(post.town, style: TextStyle(fontSize: 12, color: kDisabledColor)),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Text('인연지수', style: TextStyle(color: kDisabledColor)),
                                        Icon(Icons.help_outline, size: 14),
                                        Container(
                                          width: 53,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(10),
                                            child: LinearProgressIndicator(
                                              minHeight: 8,
                                              backgroundColor: kExpBackgroundColor,
                                              valueColor: AlwaysStoppedAnimation<Color>(kExpValueColor),
                                              value: writer.exp / 100,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '총 모임참여 ${writer.participation}회',
                                style: TextStyle(fontSize: 12, color: kDisabledColor),
                              ),
                            ],
                          ),
                        ),
                        divider(),
                        Padding(
                          padding: EdgeInsets.only(left: 25, top: 8, right: 15),
                          child: Text('연관모임'),
                        ),
                        //TODO: 연관 글 중복글 안 뜨게 해야함
                        //TODO: 연관 글에 자기 자신은 안 뜨게 해야함
                        for (int i = 0; i < 3; i++) ItemRelateList(tag: post.tag[Random().nextInt(post.tag.length)]),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                //height: 110,
                child: Column(
                  children: [
                    Divider(
                      height: 1,
                      thickness: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, right: 16, bottom: Platform.isIOS ? 48 : 16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${DateFormat('M월 dd일 HH시').format(post.start)} 예정',
                                  style: TextStyle(
                                    color: Color.fromRGBO(26, 59, 196, 1.0),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      post.town,
                                      style: TextStyle(fontSize: 14, color: kDisabledColor),
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '$writerName님의 모임',
                                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: SizedBox(
                                width: 142, height: 44, child: BackgroundButton(title: '신청하기', onPressed: () {})),
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
