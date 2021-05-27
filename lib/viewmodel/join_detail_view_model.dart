import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/screen/location_screen.dart';
import 'package:hoxy/service/emoji_service.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/service/location_service.dart';

import '../constants.dart';

class JoinDetailViewModel extends GetxController {
  final Rx<Member> _member = Member().obs;
  Member get member => _member.value;

  set position(Position position) => _member.value.location = GeoPoint(position.latitude, position.longitude);

  final Rx<bool> _isLoading = false.obs;
  final Rx<bool> _isComplete = false.obs;
  bool get isComplete => _isComplete.value;

  TextEditingController birthTextEditingController = TextEditingController();
  Rx<FixedExtentScrollController> _birthPickerController = FixedExtentScrollController().obs;
  FixedExtentScrollController get birthPickerController => _birthPickerController.value;

  JoinDetailViewModel() {
    onInit();
    _member.value
      ..uid = kAuth.currentUser!.uid
      ..email = kAuth.currentUser!.email!;
  }

  @override
  void onInit() {
    super.onInit();

    ever(_isLoading, (bool value) => value ? Loading.show() : Loading.dismiss());
    ever(_member, (Member value) => _isComplete.value = member.birth > 0 && member.city.isNotEmpty && member.town.isNotEmpty);
  }

  void changeBirthPicker(int index) {
    _birthPickerController.value = FixedExtentScrollController(initialItem: index);
    _member.update((member) => member!.birth = DateTime.now().year - 19 - index);
    birthTextEditingController.text = _member.value.birth.toString();
  }

  void getLocation() async {
    _isLoading.value = true;

    try {
      if (!await LocationService.getCurrentLocation()) {
        Loading.showError('권한을 설정해주세요');
        return;
      }

      _member.update((member) {
        member!
          ..city = LocationService.cityName
          ..town = LocationService.townName
          ..location = LocationService.geoPoint;
      });

      _isLoading.value = false;
    } catch (e) {
      print(e);
      Loading.showError('오류가 발생했습니다');
    }
  }

  void inputDetail() async {
    _isLoading.value = true;

    try {
      _member.update((member) {
        member!
          ..uid = kAuth.currentUser!.uid
          ..emoji = EmojiService.randomEmoji();
      });

      await kFirestore.collection('member').doc(kAuth.currentUser?.uid).set(member.toMap());

      Get.off(() => LocationScreen());
      _isLoading.value = false;
    } catch (e) {
      print(e);
      Loading.showError('가입에 실패했습니다');
    }
  }
}
