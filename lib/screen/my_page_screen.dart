import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/screen/login_screen.dart';
import 'package:hoxy/view/background_button.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: BackgroundButton(
          title: '로그아웃',
          onPressed: () {
            kAuth.signOut();
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
          },
        ),
      ),
    );
  }
}
