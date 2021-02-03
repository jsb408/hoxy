import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emojis/emoji.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoxy/model/member.dart';

import '../constants.dart';

class JoinViewModel extends Member {
  Member member = Member();
  String password = '';
  String certNumber = '';

  set position(Position position) => member.location = GeoPoint(position.latitude, position.longitude);

  String get formattedPhone => '+82 ${member.phone.substring(1)}';
  bool get isComplete => member.birth > 0 && member.city.isNotEmpty && member.town.isNotEmpty;

  String? checkEmail(String email) {
    member.email = email;

    if (email.isEmpty)
      return '이메일을 입력해주세요';
    else if (!RegExp('^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*\$').hasMatch(email))
      return '올바른 형식이 아닙니다';
    else
      return null;
  }

  String? checkPassword(String password) {
    this.password = password;

    if (password.isEmpty)
      return '비밀번호를 입력해주세요';
    else if (!RegExp('^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[!@#\$%^&*()?]).{8,16}\$').hasMatch(password))
      return '올바른 형식이 아닙니다';
    else
      return null;
  }

  String? checkConfirm(String confirm) {
    if (confirm.isEmpty)
      return '비밀번호를 입력해주세요';
    else if (confirm != password)
      return '입력된 값이 비밀번호와 다릅니다';
    else
      return null;
  }

  String? checkPhone(String phone) {
    member.phone = phone;

    if (phone.isEmpty)
      return '휴대폰 번호를 입력해주세요';
    else if (!RegExp('^(?=.*[0-9]).{10,11}\$').hasMatch(phone))
      return '숫자만 입력해주세요';
    else
      return null;
  }

  Future<String?> checkDuplicate() async {
    QuerySnapshot phone = await kFirestore.collection('member').where('phone', isEqualTo: member.phone).get();
    QuerySnapshot email = await kFirestore.collection('member').where('email', isEqualTo: member.email).get();

    if (phone.docs.isNotEmpty) {
      return '이미 가입된 번호입니다';
    } else if (email.docs.isNotEmpty) {
      return '이미 가입된 메일입니다';
    } else
      return null;
  }

  String randomEmoji() {
    List<String> emojis = Emoji.all().map((e) => e.toString()).toList();
    return emojis[Random().nextInt(emojis.length)];
  }

  Future<bool> createUser() async {
    try {
      await kAuth.currentUser.updateEmail(member.email);
      await kAuth.currentUser.updatePassword(password);

      member
        ..uid = kAuth.currentUser.uid
        ..emoji = randomEmoji();

      kFirestore.collection('member').doc(kAuth.currentUser.uid).set(member.toMap());

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
