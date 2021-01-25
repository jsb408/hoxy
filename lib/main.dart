import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/screen/login_screen.dart';
import 'constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(Hoxy());
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
      home: LoginScreen(),
    );
  }
}
