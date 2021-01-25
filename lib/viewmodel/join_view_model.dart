import 'package:flutter/material.dart';

class JoinViewModel {
  String email = '';
  String password = '';
  String confirm = '';
  String phone = '';
  String certNumber = '';

  bool get checkEmail => email.isNotEmpty && RegExp('^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*\$').hasMatch(email);
  bool get checkPassword => password.isNotEmpty && RegExp('^(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])(?=.*[!@#\$%^&*()?]).{8,16}\$').hasMatch(password);
  bool get checkConfirm => confirm == password;
  bool get checkPhone => phone.isNotEmpty;
  bool get checkCertNumber => certNumber.isNotEmpty;

  bool get isComplete => checkEmail && checkPassword && checkConfirm && checkPhone;
}