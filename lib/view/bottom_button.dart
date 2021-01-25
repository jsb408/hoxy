import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';

class BottomButton extends StatelessWidget {
  BottomButton({@required this.onTap, @required this.buttonTitle, @required this.activated});

  final Function onTap;
  final String buttonTitle;
  final bool activated;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
        color: activated ? primaryColor : disabledColor,
        margin: EdgeInsets.only(top: 10.0),
        padding: defaultTargetPlatform == TargetPlatform.iOS
            ? EdgeInsets.only(bottom: 15.0)
            : EdgeInsets.all(0),
        height: 85,
        width: double.infinity,
      ),
    );
  }
}
