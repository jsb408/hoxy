import 'package:flutter/material.dart';
import 'package:hoxy/screen/main_screen.dart';
import 'constants.dart';

void main() => runApp(Hoxy());

class Hoxy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        floatingActionButtonTheme: FloatingActionButtonThemeData().copyWith(
          backgroundColor: primaryColor
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
        primaryColor: primaryColor,
        scaffoldBackgroundColor: Color(0xFFF2F2F2),
      ),
      home: MainScreen(),
    );
  }
}
