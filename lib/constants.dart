import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

//region Colors
const kBackgroundColor = Color(0xFFF2F2F2);
const kPrimaryColor = Color(0xFFF5DF4D);
const kAccentColor = Color(0xFF003BFF);
const kDisabledColor = Color(0xFF818181);
const kTimeColor = Color(0xFFF5944D);
const kSubContentColor = Color(0xFF89929A);
const kTagColor = Color(0xFF0B8CFF);
const kProgressBackgroundColor = Color.fromRGBO(234, 234, 234, 1.0);
const kExpBackgroundColor = Color(0xAC939597);
const kExpValueColor = Color.fromRGBO(77, 244, 96, 1.0);
const kTagChipColor = Color(0xFF3F87E4);

const kGradeColors = [
  Colors.black, Colors.black, Colors.blue, Color(0xFF55CC91), kPrimaryColor, Colors.deepPurple
];
//endregion

//region Firebase
final FirebaseAuth kAuth = FirebaseAuth.instance;
final FirebaseFirestore kFirestore = FirebaseFirestore.instance;
final FirebaseMessaging kMessaging = FirebaseMessaging.instance;
//endregion

//region Styles
const kJoinTextStyle = TextStyle(fontSize: 18, color: Colors.black);
//endregion

const kCommunicateLevelIcons = [
  ['😷', '🤫', '🤐'],
  ['😀', '😃', '😄'],
  ['😆', '🤩', '🥳']
];
const kCommunicateLevels = ['조용히 만나요', '대화는 해요', '재밌게 놀아요'];

String timeText(DateTime date) {
  Duration difference = DateTime.now().difference(date);

  if (difference.inDays > 0)
    return "${difference.inDays}일 전";
  else if (difference.inHours > 0)
    return "${difference.inHours}시간 전";
  else if (difference.inMinutes > 0)
    return "${difference.inMinutes}분 전";
  else
    return "${difference.inSeconds}초 전";
}
