import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//region Colors
const kBackgroundColor = Color(0xFFF2F2F2);
const kPrimaryColor = Color(0xFFF5DF4D);
const kAccentColor = Color(0xFF003BFF);
const kDisabledColor = Color(0xFF818181);
const kGradeColor = Color(0xFF55CC91);
//endregion

//region Firebase
FirebaseAuth kAuth = FirebaseAuth.instance;
FirebaseFirestore kFirestore = FirebaseFirestore.instance;
//endregion

//region Styles
const kJoinTextStyle = TextStyle(fontSize: 18, color: Colors.black);
//endregion

const kCommunicateLevelIcons = [
  ['😷', '🤫', '🤐'], ['😀', '😃', '😄'], ['😆', '🤩', '🥳']
];
const kCommunicateLevels = [ '조용히 만나요', '대화는 해요', '재밌게 놀아요' ];