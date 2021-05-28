import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hoxy/screen/join_detail_screen.dart';
import 'package:hoxy/screen/location_screen.dart';
import 'package:hoxy/service/loading.dart';

import '../constants.dart';

class LoginEmailViewModel extends GetxController {
  Rx<bool> _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  String email = '';
  String password = '';

  LoginEmailViewModel() {
    onInit();
  }

  @override
  void onInit() {
    super.onInit();
    ever(_isLoading, (bool value) => value ? Loading.show() : Loading.dismiss());
  }

  void login() async {
    _isLoading.value = true;
    try {
      await kAuth.signInWithEmailAndPassword(email: email, password: password);
      if (kAuth.currentUser == null) throw Exception();

      QuerySnapshot member = await kFirestore.collection('member').where('uid', isEqualTo: kAuth.currentUser!.uid).get();

      Get.offAll(member.docs.isNotEmpty ? LocationScreen() : JoinDetailScreen());
      _isLoading.value = false;
    } catch (e) {
      print(e);
      switch((e as FirebaseAuthException).code) {
        case 'invalid-email': {
          Loading.showError('잘못된 이메일 형식');
          break;
        }
        case 'wrong-password': {
          Loading.showError('비밀번호 오류');
          break;
        }
        default: Loading.showError('로그인 실패');
      }
    }
  }
}