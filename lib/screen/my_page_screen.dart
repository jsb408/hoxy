import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/view/background_button.dart';
import 'package:hoxy/view/grade_button.dart';

import '../constants.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('마이페이지'),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            kFirestore.collection('member').doc(kAuth.currentUser.uid).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Member user = Member.from(snapshot.data);
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
                              width: 54,
                              height: 20,
                              child: BackgroundButton(
                                title: '변경',
                                textStyle: TextStyle(
                                    fontSize: 12, color: Colors.white),
                                color: kDisabledColor,
                                onPressed: () {},
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
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        kExpValueColor),
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
                      location: '양재동',
                    ),
                    MyPageLocation(
                      icon: Icons.home_outlined,
                      title: '우리 동네',
                      location: '풍덕천동',
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

class MyPageLocation extends StatelessWidget {
  MyPageLocation(
      {@required this.icon,
      @required this.title,
      @required this.location,
      this.titleColor = Colors.black});

  final IconData icon;
  final Color titleColor;
  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    return MyPageElement(
      icon: icon,
      child: RichText(
        text: TextSpan(
          style:
              TextStyle(color: Color(0xFF707070), fontWeight: FontWeight.w600),
          children: [
            TextSpan(
              text: '$title ',
              style: TextStyle(color: titleColor),
            ),
            TextSpan(text: location),
          ],
        ),
      ),
      isLocation: true,
    );
  }
}

class MyPageButton extends StatelessWidget {
  MyPageButton({@required this.icon, @required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MyPageElement(
        icon: icon,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ));
  }
}

class MyPageElement extends StatelessWidget {
  MyPageElement(
      {@required this.icon, @required this.child, this.isLocation = false});

  final IconData icon;
  final Widget child;
  final bool isLocation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 14),
      height: 50,
      child: Row(
        children: [
          Icon(
            icon,
            size: 24,
            color: Color(0xFF707070),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: child,
          ),
          if (!isLocation)
            Expanded(
              child: Text(
                '>',
                textAlign: TextAlign.end,
              ),
            ),
        ],
      ),
    );
  }
}
