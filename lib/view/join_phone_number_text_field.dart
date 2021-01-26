import 'package:flutter/material.dart';
import 'package:hoxy/view/background_button.dart';

class JoinPhoneNumberTextField extends StatelessWidget {
  JoinPhoneNumberTextField(
      {@required this.hintText,
      this.readOnly = false,
      @required this.buttonText,
      this.keyboardType = TextInputType.text,
      this.disabled = false,
      @required this.validator,
      @required this.onPressed});

  final String hintText;
  final bool readOnly;
  final String buttonText;
  final TextInputType keyboardType;
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
            readOnly: readOnly,
            keyboardType: keyboardType,
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
