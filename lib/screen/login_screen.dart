import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/screen/join_screen.dart';
import 'package:hoxy/screen/main_screen.dart';
import 'package:hoxy/view/login_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MainScreen()));
              },
            ),
            LoginButton(
              title: '애플로 로그인',
              color: Colors.black,
              textColor: Colors.white,
              onPressed: () {},
            ),
            LoginButton(
              title: '이메일로 로그인',
              color: primaryColor,
              onPressed: () {},
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('처음 오셨나요 HOXY?'),
                MaterialButton(
                  child: Text('회원가입'),
                  textColor: Colors.blueAccent.shade400,
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => JoinScreen()));
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
