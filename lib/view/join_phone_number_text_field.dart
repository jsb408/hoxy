import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';

class JoinPhoneNumberTextField extends StatelessWidget {
  JoinPhoneNumberTextField(
      {@required this.hintText,
        @required this.buttonText,
        @required this.onChanged,
        @required this.onPressed});

  final String hintText;
  final String buttonText;
  final Function onChanged;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      height: 35,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(height: 0),
              ),
              onChanged: onChanged,
            ),
          ),
          SizedBox(width: 10),
          FlatButton(
            child: Text(buttonText),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5),
            ),
            color: primaryColor,
            onPressed: onPressed,
          ),
        ],
      ),
    );
  }
}
