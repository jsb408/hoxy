import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/view/alert_platform_dialog.dart';
import 'package:hoxy/view/grade_button.dart';
import 'dart:io' show Platform;

class ProfileScreen extends StatelessWidget {
  static present(BuildContext context, Member member, Chatting chatting) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        fullscreenDialog: true,
        pageBuilder: (context, _, __) => ProfileScreen(member: member, chatting: chatting),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(begin: Offset(0.0, 1.0), end: Offset.zero).chain(CurveTween(curve: Curves.ease));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  ProfileScreen({required this.member, required this.chatting});

  final Member member;
  final Chatting chatting;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x0BDDDDDD),
      appBar: AppBar(
        elevation: 0,
        actions: [
          if (member.uid != kAuth.currentUser.uid)
            IconButton(
              icon: Icon(CupertinoIcons.person_crop_circle_badge_xmark),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertPlatformDialog(
                    title: Text('만나지 않기'),
                    content: Text('이 유저의 모임글을 숨기시겠습니까?'),
                    children: [
                      AlertPlatformDialogButton(
                        child: Text('아니오'),
                        onPressed: () {},
                      ),
                      AlertPlatformDialogButton(
                        child: Text('네'),
                        onPressed: () async {
                          Loading.show();

                          DocumentReference banned = await kFirestore.collection('member').doc(member.uid).collection('ban').add({
                            'user' : kFirestore.collection('member').doc(kAuth.currentUser.uid),
                            'date' : DateTime.now(),
                            'chatting' : kFirestore.collection('chatting').doc(chatting.id),
                            'active' : false,
                          });

                          await kFirestore.collection('member').doc(kAuth.currentUser.uid).collection('ban').add({
                            'user' : kFirestore.collection('member').doc(member.uid),
                            'date' : DateTime.now(),
                            'chatting' : kFirestore.collection('chatting').doc(chatting.id),
                            'active' : true,
                            'pair' : banned
                          });

                          Loading.dismiss();
                        },
                      ),
                    ],
                  ),
                );
              },
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
                            Text(chatting.nickname[member.uid],
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
                  top: Platform.isIOS ? MediaQuery.of(context).size.height * 0.1 : MediaQuery.of(context).size.height * 0.15 ,
                  right: 35,
                  child: Text(
                    member.emoji,
                    style: TextStyle(fontSize: Platform.isIOS ? 180 : 120),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                color: kPrimaryColor,
                child: Text('Hello'),
              ),
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
