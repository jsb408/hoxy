import 'package:flutter/material.dart';
import '../constants.dart';

class BackgroundButton extends StatelessWidget {
  const BackgroundButton(
      {required this.title,
      this.textStyle = const TextStyle(color: Colors.black),
      this.color = kPrimaryColor,
      this.disabled = false,
      required this.onPressed});

  final String title;
  final TextStyle textStyle;
  final Color color;
  final bool disabled;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(title,
        style: textStyle,),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(Color(0x44AAAAAA)),
        backgroundColor: MaterialStateProperty.all(disabled ? kDisabledColor : color),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        )
      ),
      onPressed: disabled ? null : onPressed,
    );
  }
}
