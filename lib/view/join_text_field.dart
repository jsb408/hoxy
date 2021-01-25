import 'package:flutter/material.dart';

class JoinTextField extends StatelessWidget {
  JoinTextField(
      {@required this.title,
      @required this.hintText,
      this.textInputType = TextInputType.text,
      this.obscureText = false,
      this.description,
      @required this.onChanged});

  final String title;
  final String hintText;
  final TextInputType textInputType;
  final String description;
  final bool obscureText;
  final Function onChanged;

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
                Container(
                  padding: EdgeInsets.only(top: 8),
                  height: 35,
                  child: TextField(
                    keyboardType: textInputType,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      hintText: hintText,
                      hintStyle: TextStyle(height: 0),
                    ),
                    onChanged: onChanged,
                  ),
                ),
                if (description != null)
                  Text(
                    description,
                    style: TextStyle(
                      color: Color(0xFF918DFF),
                      fontSize: 10,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
