import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/service/emoji_service.dart';

import '../constants.dart';

class JoinViewModel extends GetxController {
  Rx<Member> member = Member().obs;
  Rx<String> password = ''.obs;
  Rx<String> certNumber = ''.obs;

  set position(Position position) => member.value.location = GeoPoint(position.latitude, position.longitude);

  String get formattedPhone => '+82 ${member.value.phone.substring(1)}';
  bool get isComplete => member.value.birth > 0 && member.value.city.isNotEmpty && member.value.town.isNotEmpty;

  String? checkEmail(String email) {
    member.value.email = email;

    if (email.isEmpty)
      return '이메일을 입력해주세요';
    else if (!RegExp('^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*\$').hasMatch(email))
      return '올바른 형식이 아닙니다';
    else
      return null;
  }

  String? checkPassword(String password) {
    this.password.value = password;

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
    else if (confirm != password.value)
      return '입력된 값이 비밀번호와 다릅니다';
    else
      return null;
  }

  String? checkPhone(String phone) {
    member.value.phone = phone;

    if (phone.isEmpty)
      return '휴대폰 번호를 입력해주세요';
    else if (!RegExp('^(?=.*[0-9]).{10,11}\$').hasMatch(phone))
      return '숫자만 입력해주세요';
    else
      return null;
  }

  Future<String?> checkDuplicate() async {
    QuerySnapshot phone = await kFirestore.collection('member').where('phone', isEqualTo: member.value.phone).get();
    QuerySnapshot email = await kFirestore.collection('member').where('email', isEqualTo: member.value.email).get();

    if (phone.docs.isNotEmpty) {
      return '이미 가입된 번호입니다';
    } else if (email.docs.isNotEmpty) {
      return '이미 가입된 메일입니다';
    } else
      return null;
  }

  Future<bool> createUser() async {
    try {
      await kAuth.currentUser?.updateEmail(member.value.email);
      await kAuth.currentUser?.updatePassword(password.value);

      member.value
        ..uid = kAuth.currentUser!.uid
        ..emoji = EmojiService.randomEmoji();

      kFirestore.collection('member').doc(kAuth.currentUser?.uid).set(member.value.toMap());

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
