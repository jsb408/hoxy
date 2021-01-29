import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hoxy/screen/location_screen.dart';
import 'package:hoxy/screen/login_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Hoxy());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
      ..userInteractions = false;
}

class Hoxy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        /*textTheme: Theme.of(context).textTheme.copyWith(
          bodyText2: Theme.of(context).textTheme.bodyText2.copyWith(
            //fontWeight: FontWeight.w300
          )
        )*/
      ),
      home: kAuth.currentUser == null || kAuth.currentUser.email.isEmpty ? LoginScreen() : LocationScreen(),
      builder: EasyLoading.init(),
    );
  }
}
