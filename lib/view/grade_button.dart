import 'package:flutter/material.dart';
import '../constants.dart';

class GradeButton extends StatelessWidget {
  GradeButton({@required this.grade});

  final int grade;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(
        color: kGradeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text('$grade학년', style: TextStyle(color: Colors.white)),
    );
  }
}
