import 'package:flutter/material.dart';
import '../constants.dart';

class GradeButton extends StatelessWidget {
  GradeButton({@required this.birth});

  final int birth;

  @override
  Widget build(BuildContext context) {
    int grade = (DateTime.now().year - birth + 1) ~/ 10;

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
