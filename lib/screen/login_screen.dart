import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/screen/join_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/view/login_button.dart';

import 'login_email_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/logo.png',
                  width: 300,
                ),
              ),
              SizedBox(height: 50),
              LoginButton(
                title: '구글로 로그인',
                color: Colors.white,
                borderColor: Colors.black,
                onPressed: () {
                  Loading.showError('준비중입니다');
                },
              ),
              LoginButton(
                title: '애플로 로그인',
                color: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  Loading.showError('준비중입니다');
                },
              ),
              LoginButton(
                title: '이메일로 로그인',
                color: kPrimaryColor,
                onPressed: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LoginEmailScreen()));
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('처음 오셨나요 HOXY?'),
                  CupertinoButton(
                    child: Text(
                      '회원가입',
                      style: TextStyle(fontSize: 14, color: Colors.blueAccent.shade400),
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => JoinScreen()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
