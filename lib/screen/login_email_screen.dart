import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/screen/location_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/view/background_button.dart';

import 'join_detail_screen.dart';

class LoginEmailScreen extends StatelessWidget {
  //TODO : ViewModel 적
  @override
  Widget build(BuildContext context) {
    String _email = '';
    String _password = '';

    return WillPopScope(
      onWillPop: () {
        return Future(() => !EasyLoading.isShow);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('로그인'),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Hero(
                    tag: 'logo',
                    child: Image.asset(
                      'images/logo.png',
                      width: 200,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이메일',
                  ),
                  onChanged: (value) {
                    _email = value;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '패스워드',
                  ),
                  onChanged: (value) {
                    _password = value;
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: BackgroundButton(
                  title: '로그인',
                  onPressed: () async {
                    Loading.show();
                    try {
                      await kAuth.signInWithEmailAndPassword(email: _email, password: _password);
                      if (kAuth.currentUser == null) throw Exception();

                      QuerySnapshot member = await kFirestore.collection('member').where('uid', isEqualTo: kAuth.currentUser!.uid).get();

                      Navigator.push(context, MaterialPageRoute(builder: (context) =>
                        member.docs.isNotEmpty ? LocationScreen() : JoinDetailScreen(uid: kAuth.currentUser!.uid)));
                      Loading.dismiss();
                    } catch (e) {
                      print(e);
                      //TODO : 에러코드 분리
                      Loading.showError('로그인 실패');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
