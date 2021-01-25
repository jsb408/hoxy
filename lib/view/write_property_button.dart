import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';

class WritePropertyButton extends StatelessWidget {
  WritePropertyButton({@required this.title, @required this.onTap});

  final String title;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: kBackgroundColor, width: 0.5)
        ),
        padding: EdgeInsets.only(left: 30, top: 16, bottom: 16),
        width: double.infinity,
        child: Text(
          '$title >',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      onTap: onTap,
    );
  }
}
