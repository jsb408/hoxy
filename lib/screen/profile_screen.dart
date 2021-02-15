import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/view/grade_button.dart';
import 'dart:io' show Platform;

class ProfileScreen extends StatelessWidget {
  ProfileScreen({required this.member, required this.chatting});

  final Member member;
  final Chatting chatting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x0BDDDDDD),
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            icon: Icon(CupertinoIcons.xmark),
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          if(member.uid != kAuth.currentUser.uid)
          Platform.isIOS
              ? IconButton(
                  icon: Icon(Icons.more_vert),
                  onPressed: () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (context) => CupertinoActionSheet(
                        actions: [
                          CupertinoActionSheetAction(
                            child: Text('차단하기'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoActionSheetAction(
                            child: Text('신고하기'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                        cancelButton: CupertinoActionSheetAction(
                          child: Text('취소'),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                )
              : PopupMenuButton(
                  onSelected: (value) {
                    if (value == '차단하기') {
                    } else if (value == '신고하기') {}
                  },
                  itemBuilder: (context) => [
                    for (String item in ['차단하기', '신고하기'])
                      PopupMenuItem(
                        value: item,
                        child: Text(item),
                      ),
                  ],
                ),
        ],
      ),
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          children: [
            Stack(
              children: [
                Column(
                  children: [
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.15),
                      painter: DrawTriangleShape(),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                    RotationTransition(
                      turns: AlwaysStoppedAnimation(0.5),
                      child: CustomPaint(
                        size: Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height * 0.15),
                        painter: DrawTriangleShape(),
                      ),
                    ),
                  ],
                ),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.15 * 0.18,
                    left: 32,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(member.town, style: TextStyle(fontWeight: FontWeight.w600)),
                        Row(
                          children: [
                            Text(chatting.member[member.uid],
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
                            SizedBox(width: 5),
                            GradeButton(birth: member.birth),
                          ],
                        ),
                        Row(
                          children: [
                            Text('인연지수', style: TextStyle(fontWeight: FontWeight.w600)),
                            SizedBox(width: 5),
                            Container(
                              width: 53,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  minHeight: 8,
                                  backgroundColor: kExpBackgroundColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(kExpValueColor),
                                  value: member.exp / 100,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                Positioned(
                  bottom: 0,
                  right: 28,
                  child: Text(
                    '총 모임참여 ${member.participation}회',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  right: 35,
                  child: Text(
                    member.emoji,
                    style: TextStyle(fontSize: 180),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.37,
              color: kPrimaryColor,
              child: Text('Hello'),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawTriangleShape extends CustomPainter {
  Paint painter = Paint();

  DrawTriangleShape() {
    painter = Paint()
      ..color = kPrimaryColor
      ..style = PaintingStyle.fill;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.65);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, painter);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
