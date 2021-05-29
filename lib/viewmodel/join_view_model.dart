import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/join.dart';
import 'package:hoxy/screen/join_detail_screen.dart';
import 'package:hoxy/service/loading.dart';
import '../constants.dart';

class JoinViewModel extends GetxController {
  final Join _join = Join();

  String _certNumber = '';
  set certNumber(String number) => _certNumber = number;

  bool _isComplete = false;
  bool get isComplete => _isComplete;
  String _verificationId = '';
  String get verificationId => _verificationId;

  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  String get formattedPhone => '+82 ${_join.phone.substring(1)}';

  @override
  void onInit() {
    super.onInit();
  }

  String? checkEmail(String email) {
    _join.email = email;

    if (email.isEmpty)
      return '이메일을 입력해주세요';
    else if (!RegExp('^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*\$').hasMatch(email))
      return '올바른 형식이 아닙니다';
    else
      return null;
  }

  String? checkPassword(String password) {
    _join.password = password;

    if (password.isEmpty)
      return '비밀번호를 입력해주세요';
    else if (!RegExp('^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[!@#\$%^&*()?]).{8,16}\$')
        .hasMatch(password))
      return '올바른 형식이 아닙니다';
    else
      return null;
  }

  String? checkConfirm(String confirm) {
    if (confirm.isEmpty)
      return '비밀번호를 입력해주세요';
    else if (confirm != _join.password)
      return '입력된 값이 비밀번호와 다릅니다';
    else
      return null;
  }

  String? checkPhone(String phone) {
    _join.phone = phone;

    if (phone.isEmpty)
      return '휴대폰 번호를 입력해주세요';
    else if (!RegExp('^(?=.*[0-9]).{10,11}\$').hasMatch(phone))
      return '숫자만 입력해주세요';
    else
      return null;
  }

  Future<String?> checkDuplicate() async {
    QuerySnapshot phone =
        await kFirestore.collection('member').where('phone', isEqualTo: _join.phone).get();
    QuerySnapshot email =
        await kFirestore.collection('member').where('email', isEqualTo: _join.email).get();

    if (phone.docs.isNotEmpty) {
      return '이미 가입된 번호입니다';
    } else if (email.docs.isNotEmpty) {
      return '이미 가입된 메일입니다';
    } else
      return null;
  }

  Future createUser() async {
    Loading.show();

    try {
      await kAuth.currentUser?.updateEmail(_join.email);
      await kAuth.currentUser?.updatePassword(_join.password);
      Loading.dismiss();

      Get.off(() => JoinDetailScreen());
    } catch (e) {
      print(e);
      Loading.showError('가입에 실패했습니다');
    }
  }

  void checkValidate() async {
    Loading.show();

    if (!_formKey.currentState!.validate()) {
      Loading.dismiss();
      return;
    }

    String? duplicate = await checkDuplicate();

    if (duplicate != null) {
      Loading.showError(duplicate);
      return;
    }

    await kAuth.verifyPhoneNumber(
      phoneNumber: formattedPhone,
      verificationCompleted: (credential) {
        _isComplete = true;
        Loading.dismiss();
      },
      verificationFailed: (e) {
        print(e);
        Loading.showError('인증 실패');
      },
      codeSent: (verificationId, resendToken) async {
        Loading.showSuccess('번호가 전송되었습니다');
        _verificationId = verificationId;
        Loading.dismiss();
        update();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        print('codeAuthRetrievalTimeout');
      },
    );
  }

  void checkCertNum() async {
    Loading.show();
    if (_formKey.currentState!.validate()) {
      try {
        AuthCredential phoneAuthCredential =
            PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _certNumber);
        await kAuth.signInWithCredential(phoneAuthCredential);

        if (kAuth.currentUser != null) {
          Loading.showSuccess('인증 완료');
          _verificationId = '';
          _isComplete = true;
          update();
        }
      } catch (e) {
        Loading.showError('인증 실패');
        print(e);
      }
    }
    Loading.dismiss();
  }
}
