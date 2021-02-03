import 'package:flutter/material.dart';
import '../constants.dart';

class BackgroundButton extends StatelessWidget {
  const BackgroundButton(
      {required this.title,
      this.textStyle,
      this.color = kPrimaryColor,
      this.disabled = false,
      required this.onPressed});

  final String title;
  final TextStyle? textStyle;
  final Color color;
  final bool disabled;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        title,
        style: textStyle,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: color,
      disabledColor: kDisabledColor,
      onPressed: disabled ? null : onPressed,
    );
  }
}
