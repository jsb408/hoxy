import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hoxy/screen/location_screen.dart';
import 'package:hoxy/screen/login_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //if(kAuth.currentUser != null) await LocationService.getCurrentLocation();
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
      theme: ThemeData.light().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
          backgroundColor: kPrimaryColor
        ),
        appBarTheme: AppBarTheme().copyWith(
          iconTheme: IconThemeData().copyWith(
            color: Colors.black
          ),
          textTheme: TextTheme(
            headline6: TextStyle(
              fontSize: 24,
              color: Colors.black,
            ),
          ),
        ),
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
      ),
      home: kAuth.currentUser == null ? LoginScreen() : LocationScreen(),
      builder: EasyLoading.init(),
    );
  }
}
