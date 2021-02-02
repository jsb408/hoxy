import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';

class WritePropertyButton extends StatelessWidget {
  WritePropertyButton({@required this.title, @required this.onTap, this.hasData = false, this.disabled = false});

  final String title;
  final Function onTap;
  final bool hasData;
  final bool disabled;

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
          '$title' + (hasData ? '' : ' >'),
          style: TextStyle(
            fontSize: 16,
            fontWeight: hasData ? FontWeight.w400 : FontWeight.w600,
            height: 1.25,
            color: disabled ? kDisabledColor : Colors.black,
          ),
        ),
      ),
      onTap: disabled ? null : onTap,
    );
  }
}
