import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'dart:io' show Platform;

class BottomButton extends StatelessWidget {
  BottomButton({required this.onTap, required this.buttonTitle, required this.disabled});

  final void Function() onTap;
  final String buttonTitle;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        child: Center(
          child: Text(
            buttonTitle,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
        color: disabled ? kDisabledColor : kPrimaryColor,
        //margin: EdgeInsets.only(top: 10.0),
        padding: Platform.isIOS ? EdgeInsets.only(bottom: 15.0) : EdgeInsets.all(0),
        height: 85,
        width: double.infinity,
      ),
    );
  }
}
