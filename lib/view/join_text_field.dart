import 'package:flutter/material.dart';

class JoinTextField extends StatelessWidget {
  JoinTextField(
      {@required this.title,
      @required this.hintText,
      this.textInputType = TextInputType.text,
      this.obscureText = false,
      @required this.validator});

  final String title;
  final String hintText;
  final TextInputType textInputType;
  final bool obscureText;
  final Function validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  keyboardType: textInputType,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(height: 0),
                  ),
                  validator: validator,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
