import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  LoginButton(
      {required this.title,
      required this.color,
      required this.onPressed,
      this.textColor = Colors.black,
      this.borderColor = Colors.transparent});

  final String title;
  final Color color;
  final Color textColor;
  final Color borderColor;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        height: 48,
        width: 286,
        child: TextButton(
          child: Text(title, style: TextStyle(color: textColor)),
          style: ButtonStyle(
              overlayColor: MaterialStateProperty.all(Color(0x44AAAAAA)),
              backgroundColor: MaterialStateProperty.all<Color>(color),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: borderColor,
                    width: 1,
                  ),
                ),
              )),
          onPressed: onPressed,
        ),
/*      FlatButton(
        height: 48,
        minWidth: 286,
        child: Text(title),
        color: color,
        textColor: textColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: borderColor,
            width: 1,
          ),
        ),*/
      ),
    );
  }
}
