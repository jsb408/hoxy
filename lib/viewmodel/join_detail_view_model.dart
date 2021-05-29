import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  Member _member = Member();
  Member get member => _member;

  set position(Position position) => _member.location = GeoPoint(position.latitude, position.longitude);

  bool get isComplete => member.birth > 0 && member.city.isNotEmpty && member.town.isNotEmpty;

  TextEditingController birthTextEditingController = TextEditingController();
  Rx<FixedExtentScrollController> _birthPickerController = FixedExtentScrollController().obs;
  FixedExtentScrollController get birthPickerController => _birthPickerController.value;

  @override
  void onInit() {
    super.onInit();

    _member
      ..uid = kAuth.currentUser!.uid
      ..email = kAuth.currentUser!.email!;
  }

  CupertinoPicker birthPicker() => CupertinoPicker(
      scrollController: birthPickerController,
      itemExtent: 50,
      onSelectedItemChanged: (index) => changeBirthPicker(index),
      children: [
        for (int i = DateTime.now().year - 19; i > DateTime.now().year - 49; i--)
          Center(child: Text(i.toString()))
      ],
  );

  void changeBirthPicker(int index) {
    _birthPickerController.value = FixedExtentScrollController(initialItem: index);
    _member.birth = DateTime.now().year - 19 - index;
    birthTextEditingController.text = _member.birth.toString();
    update();
  }

  void getLocation() async {
    Loading.show();

    try {
      if (!await LocationService.getCurrentLocation()) {
        Loading.showError('권한을 설정해주세요');
        return;
      }

      _member
          ..city = LocationService.cityName
          ..town = LocationService.townName
          ..location = LocationService.geoPoint;

      update();
      Loading.dismiss();
    } catch (e) {
      print(e);
      Loading.showError('오류가 발생했습니다');
    }
  }

  void inputDetail() async {
    Loading.show();

    try {
      _member
          ..uid = kAuth.currentUser!.uid
          ..emoji = EmojiService.randomEmoji();

      await kFirestore.collection('member').doc(kAuth.currentUser?.uid).set(member.toMap());

      Get.off(() => LocationScreen());
      update();
      Loading.dismiss();
    } catch (e) {
      print(e);
      Loading.showError('가입에 실패했습니다');
    }
  }
}
