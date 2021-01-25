import 'package:flutter/material.dart';
import '../constants.dart';

class BackgroundButton extends StatelessWidget {
  const BackgroundButton({@required this.title, this.color = kPrimaryColor, this.disabled = false, @required this.onPressed});

  final String title;
  final Color color;
  final bool disabled;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(title),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      color: color,
      disabledColor: kDisabledColor,
      onPressed: disabled ? null : onPressed,
    );
  }
}
