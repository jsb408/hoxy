import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/service/emoji_service.dart';
import 'package:hoxy/service/location_service.dart';
import 'package:hoxy/view/alert_platform_dialog.dart';
import 'package:hoxy/view/background_button.dart';
import 'package:hoxy/view/grade_button.dart';
import 'package:hoxy/view/my_page_element.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/view/skeleton.dart';

import '../constants.dart';

class MyPageScreen extends StatefulWidget {
  @override
  _MyPageScreenState createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String _currentTownName = LocationService.townName;
  late String _myTownName;

  showEmojiDialog(String emoji) {
    showDialog(
      context: context,
      builder: (context) => AlertPlatformDialog(
        title: Text('이모지 변경'),
        content: Text(emoji, style: TextStyle(fontSize: 40)),
        children: [
          AlertPlatformDialogButton(
            child: Text('적용'),
            onPressed: () async {
              Loading.show();
              await kFirestore.collection('member').doc(kAuth.currentUser.uid).update({'emoji': emoji});
              Loading.dismiss();
            },
          ),
          AlertPlatformDialogButton(
            child: Text('재시도'),
            onPressed: () {
              showEmojiDialog(EmojiService.randomEmoji());
            },
          ),
          AlertPlatformDialogButton(
            child: Text('취소'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: kFirestore.collection('member').doc(kAuth.currentUser.uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          Member user = Member.from(snapshot.data!);
          _myTownName = user.town;

          return Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 12, right: 12, left: 12),
                color: Colors.white,
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              user.emoji,
                              style: TextStyle(fontSize: 60),
                            ),
                            Container(
                              width: 42,
                              height: 24,
                              child: BackgroundButton(
                                title: '변경',
                                textStyle: TextStyle(fontSize: 8, color: Colors.white),
                                color: kDisabledColor,
                                onPressed: () {
                                  showEmojiDialog(EmojiService.randomEmoji());
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${user.email} 님의\n인연지수는',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    minHeight: 16,
                                    backgroundColor: kExpBackgroundColor,
                                    valueColor: AlwaysStoppedAnimation<Color>(kExpValueColor),
                                    value: user.exp / 100,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GradeButton(birth: user.birth),
                                  SizedBox(width: 5),
                                  Text(
                                    '동네대장🥳 입니다',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    MyPageLocation(
                      icon: CupertinoIcons.map_pin_ellipse,
                      title: '현재 동네',
                      titleColor: Color(0xFFF58651),
                      location: _currentTownName,
                      onTap: () async {
                        Loading.show();
                        if (await LocationService.getCurrentLocation()) {
                          setState(() {
                            print(LocationService.townName);
                            _currentTownName = LocationService.townName;
                          });
                          Loading.showSuccess('위치 변경 완료');
                        } else
                          Loading.showError('위치 읽기 실패');
                      },
                    ),
                    MyPageLocation(
                      icon: Icons.home_outlined,
                      title: '우리 동네',
                      location: _myTownName,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertPlatformDialog(
                                title: Text('동네 변경'),
                                content: Text('우리 동네를 현재 동네로 변경하시겠습니까?'),
                                children: [
                                  AlertPlatformDialogButton(child: Text('아니오'), onPressed: () {}),
                                  AlertPlatformDialogButton(
                                      child: Text('네'),
                                      onPressed: () async {
                                        Loading.show();
                                        await kFirestore.collection('member').doc(kAuth.currentUser.uid).update({
                                          'city': LocationService.cityName,
                                          'town': LocationService.townName,
                                          'location': LocationService.geoPoint
                                        }).catchError((error) {
                                          print(error);
                                          Loading.showError('변경 실패');
                                        });
                                        Loading.showSuccess('변경되었습니다');
                                      })
                                ],
                              );
                            });
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                color: Colors.white,
                child: Column(
                  children: [
                    MyPageButton(
                      icon: CupertinoIcons.person_crop_circle_badge_xmark,
                      title: '만남거부목록',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
