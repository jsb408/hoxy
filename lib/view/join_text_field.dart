import 'package:flutter/material.dart';

class JoinTextField extends StatelessWidget {
  JoinTextField(
      {required this.title,
      required this.hintText,
      this.readOnly = false,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      required this.validator});

  final String title;
  final String hintText;
  final bool readOnly;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?) validator;

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
                  readOnly: readOnly,
                  keyboardType: keyboardType,
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
