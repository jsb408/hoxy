import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hoxy/screen/join_detail_screen.dart';
import 'package:hoxy/screen/location_screen.dart';
import 'package:hoxy/screen/login_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Hoxy(firstScreen: await autoLogin()));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
      ..userInteractions = false;
}

Future<StatelessWidget> autoLogin() async {
  if (kAuth.currentUser != null) { //로그인 되어있으면
    QuerySnapshot member = await kFirestore.collection('member').where('uid', isEqualTo: kAuth.currentUser!.uid).get();
    //detail이 입력되어 있으면 ? LocationScreen() : JoinDetailScreen()
    return member.docs.isNotEmpty ? LocationScreen() : JoinDetailScreen(uid: kAuth.currentUser!.uid);
  } else return LoginScreen();
}

class Hoxy extends StatelessWidget {
  Hoxy({required this.firstScreen});

  final StatelessWidget firstScreen;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
        floatingActionButtonTheme: Theme.of(context).floatingActionButtonTheme.copyWith(
          backgroundColor: kPrimaryColor
        ),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          iconTheme: IconThemeData().copyWith(
            color: Colors.black
          ),
          textTheme: TextTheme().copyWith(
            headline6: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.copyWith(
          bodyText2: Theme.of(context).textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w300
          )
        )
      ),
      home: firstScreen,
      builder: EasyLoading.init(),
    );
  }
}
