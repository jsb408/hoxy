import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/screen/login_screen.dart';
import 'package:hoxy/service/emoji_service.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/service/location_service.dart';
import 'package:hoxy/view/alert_platform_dialog.dart';

import '../constants.dart';

class MyPageViewModel extends GetxController {
  String _currentTownName = LocationService.townName;
  String get currentTownName => _currentTownName;

  String _myTownName = '';
  String get myTownName => _myTownName;

  Member _user = Member();
  Member get user => _user;

  @override
  void onInit() {
    super.onInit();

    kFirestore.collection('member').doc(kAuth.currentUser?.uid).snapshots().listen((event) {
      _user = Member.from(event);
      _myTownName = _user.town;
      update();
    });
  }

  void showEmojiDialog(String emoji) {
    Get.dialog(
      AlertPlatformDialog(
        title: Text('이모지 변경'),
        content: Text(emoji, style: TextStyle(fontSize: 40)),
        children: [
          AlertPlatformDialogButton(
            child: Text('적용'),
            onPressed: () async {
              Loading.show();
              await kFirestore.collection('member').doc(kAuth.currentUser?.uid).update({'emoji': emoji});
              Loading.dismiss();
            },
          ),
          AlertPlatformDialogButton(
            child: Text('재시도'),
            onPressed: () {
              showEmojiDialog(EmojiService.randomEmoji());
            },
          ),
          AlertPlatformDialogButton(
            child: Text('취소'),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  void updateLocation() async {
    Loading.show();
    if (await LocationService.getCurrentLocation()) {
      print(LocationService.townName);
      _currentTownName = LocationService.townName;
      update();
      Loading.showSuccess('위치 변경 완료');
    } else Loading.showError('위치 읽기 실패');
  }

  void changeLocation() async {
    Get.dialog(
        AlertPlatformDialog(
            title: Text('동네 변경'),
            content: Text('우리 동네를 현재 동네로 변경하시겠습니까?'),
            children: [
              AlertPlatformDialogButton(child: Text('아니오'), onPressed: () {}),
              AlertPlatformDialogButton(
                  child: Text('네'),
                  onPressed: () async {
                    Loading.show();
                    await kFirestore
                        .collection('member')
                        .doc(kAuth.currentUser?.uid)
                        .update({
                      'city': LocationService.cityName,
                      'town': LocationService.townName,
                      'location': LocationService.geoPoint
                    }).catchError((error) {
                      print(error);
                      Loading.showError('변경 실패');
                    });
                    Loading.showSuccess('변경되었습니다');
                  })
            ],
        ));
  }

  void signOut() {
    Get.dialog(AlertPlatformDialog(
        title: Text('로그아웃'),
        content: Text('로그아웃하시겠습니까?'),
        children: [
          AlertPlatformDialogButton(child: Text('아니오'), onPressed: () {}),
          AlertPlatformDialogButton(
            child: Text('네'),
            onPressed: () {
              kMessaging.unsubscribeFromTopic(kAuth.currentUser!.uid);
              kAuth.signOut();
              Get.off(LoginScreen());
            },
          ),
        ],
      ));
  }
}