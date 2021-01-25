import 'package:flutter/material.dart';
import 'package:hoxy/view/background_button.dart';

class JoinPhoneNumberTextField extends StatelessWidget {
  JoinPhoneNumberTextField(
      {@required this.hintText,
      @required this.buttonText,
        this.disabled = false,
      @required this.validator,
      @required this.onPressed});

  final String hintText;
  final String buttonText;
  final bool disabled;
  final Function validator;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: TextFormField(
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(height: 0),
            ),
            validator: validator,
          ),
        ),
        SizedBox(width: 10),
        BackgroundButton(
          title: buttonText,
          disabled: disabled,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
