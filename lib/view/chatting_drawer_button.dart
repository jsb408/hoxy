
import 'package:flutter/material.dart';

class ChattingDrawerButton extends StatelessWidget {
  const ChattingDrawerButton({required this.icon, required this.text, required this.onTap});

  final IconData icon;
  final String text;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        GestureDetector(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Color(0xFF707070),
                ),
                SizedBox(width: 8),
                Text(
                  text,
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}