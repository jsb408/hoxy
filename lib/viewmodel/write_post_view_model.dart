import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/write_post_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/service/location_service.dart';
import 'package:hoxy/view/alert_platform_dialog.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../nickname.dart';

class WritePostViewModel extends GetxController {
  WritePostViewModel({this.selectedTown}) {
    _isLoading.value = true;
    onInit();
    kFirestore.collection('member').doc(kAuth.currentUser!.uid).get().then((value) {
      _user.value = Member.from(value);
      _locationList.add(LocationService.townName);
      _locationList.add(_user.value.town);
      _post.update((post) => post!
        ..writer = kFirestore.collection('member').doc(user.uid)
        ..town = _locationList[0]);
      geoPoint = selectedTown == 0 ? LocationService.geoPoint : user.location;

      _locationController.value = FixedExtentScrollController(initialItem: selectedTown ?? 0);
      _post.update((post) => post!.town = _locationList[selectedTown ?? 0]);
      _isLoading.value = false;
    });
  }

  Rx<Post> _post = Post().obs;
  Post get post => _post.value;
  Rx<Member> _user = Member().obs;
  Member get user => _user.value;
  String nickname = randomNickname;

  int? selectedTown;

  Rx<bool> _isLoading = false.obs;

  List<String> _locationList = [];
  List<String> get locationList => _locationList;

  set geoPoint(GeoPoint geoPoint) => _post.update((post) => post!.location = geoPoint);

  set title(String title) => _post.update((post) => post!.title = title);
  set content(String content) => _post.update((post) => post!.content = content);
  set tag(List<String> tag) => _post.update((post) => post!.tag = tag);

  get communicationLevel => kCommunicateLevels[_post.value.communication];

  get formattedStartTime => DateFormat('MM월 dd일 HH:mm').format(_post.value.start ?? DateTime.now());

  get formattedTime =>
      '$formattedStartTime~${DateFormat('HH시 mm분').format((_post.value.start ?? DateTime.now()).add(Duration(minutes: _post.value.duration)))} (${NumberFormat('0.#').format(_post.value.duration / 60)}시간)';

  Rx<bool> _isComplete = false.obs;
  get isComplete => _isComplete.value;

  Rx<TextEditingController> _titleController = TextEditingController().obs;
  TextEditingController get titleController => _titleController.value;
  Rx<TextEditingController> _contentController = TextEditingController().obs;
  TextEditingController get contentController => _contentController.value;
  Rx<TextEditingController> _tagController = TextEditingController().obs;
  TextEditingController get tagController => _tagController.value;

  Rx<FixedExtentScrollController> _locationController = FixedExtentScrollController().obs;
  FixedExtentScrollController get locationController => _locationController.value;
  Rx<FixedExtentScrollController> _headCountController = FixedExtentScrollController().obs;
  FixedExtentScrollController get headCountController => _headCountController.value;
  Rx<FixedExtentScrollController> _communicationController = FixedExtentScrollController().obs;
  FixedExtentScrollController get communicationController => _communicationController.value;
  Rx<FixedExtentScrollController> _durationController = FixedExtentScrollController().obs;
  FixedExtentScrollController get durationController => _durationController.value;

  @override
  void onInit() {
    super.onInit();
    ever(_isLoading, (bool value) => value ? Loading.show() : Loading.dismiss());
    ever(_post, (Post value) => _isComplete.value = value.title.isNotEmpty &&
                                value.content.isNotEmpty &&
                                value.headcount > 0 &&
                                value.start != null &&
                                value.duration > 0 &&
                                value.communication != 9
    );
  }

  void showHeadcountPicker() {
    if (_post.value.headcount < 2) _post.update((post) => post!.headcount = 2);
    postPicker(_headCountController.value, ['2', '3', '4'], Property.HEADCOUNT);
  }

  void showCommunicationLevelPicker() {
    if (_post.value.communication == 9)
      _post.update((post) => post!
        ..emoji = kCommunicateLevelIcons[0][Random().nextInt(3)]
        ..communication = 0);
    postPicker(_communicationController.value, kCommunicateLevels, Property.COMMUNICATE);
  }

  void showDurationPicker() {
    if (_post.value.duration == 0) _post.update((post) => post!.duration = 30);
    postPicker(_durationController.value,
        ['30분', '1시간', '1시간 30분', '2시간', '2시간 30분', '3시간', '3시간 30분', '4시간'], Property.DURATION);
  }

  void showStartTimePicker() {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        height: 280,
        child: Column(
          children: [
            Row(
              children: [
                CupertinoButton(
                  child: Text('확인'),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                minuteInterval: 30,
                minimumDate: DateTime.now(),
                initialDateTime: _post.value.start ??
                    DateTime.now().add(Duration(
                        minutes: DateTime.now().minute >= 30
                            ? 60 - DateTime.now().minute
                            : 30 - DateTime.now().minute)),
                onDateTimeChanged: (DateTime value) => _post.update((post) => post!.start = value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void postPicker(FixedExtentScrollController controller, List<String> children, Property target) =>
      Get.bottomSheet(Container(
        color: Colors.white,
        height: 280,
        child: Column(
          children: [
            Row(
              children: [
                CupertinoButton(
                  child: Text('확인'),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: controller,
                itemExtent: 50,
                onSelectedItemChanged: (index) {
                  switch (target) {
                    case Property.LOCATION:
                      _locationController.value = FixedExtentScrollController(initialItem: index);
                      _post.update((post) => post!.town = _locationList[index]);
                      geoPoint = index == 0 ? LocationService.geoPoint : _user.value.location;
                      break;
                    case Property.HEADCOUNT:
                      _headCountController.value = FixedExtentScrollController(initialItem: index);
                      _post.update((post) => post!.headcount = index + 2);
                      break;
                    case Property.COMMUNICATE:
                      _communicationController.value =
                          FixedExtentScrollController(initialItem: index);
                      _post.update((post) => post!
                        ..emoji = kCommunicateLevelIcons[index][Random().nextInt(3)]
                        ..communication = index);
                      break;
                    case Property.DURATION:
                      _durationController.value = FixedExtentScrollController(initialItem: index);
                      _post.update((post) => post!.duration = (index + 1) * 30);
                      break;
                  }
                },
                children: [for (String child in children) Center(child: Text(child))],
              ),
            ),
          ],
        ),
      ));

  Future createPost() async {
    Get.back();
    _isLoading.value = true;

    try {
      _post.value
        ..date = DateTime.now()
        ..tag.insert(0, kCommunicateLevels[this.post.communication]);
      DocumentReference post = await kFirestore.collection('post').add(this.post.toMap());
      DocumentReference chatting = await kFirestore.collection('chatting').add({
        'post': post,
        'member': [this.post.writer!.id],
        'nickname': {this.post.writer!.id: nickname},
        'date': DateTime.now(),
      });

      await post.update({'chat': chatting});
      Loading.showSuccess('업로드 완료');
      Get.back();
    } catch (e) {
      print(e);
      Loading.showError('업로드 실패');
    }
  }

  void showWriteDialog() {
    Get.dialog(
      AlertPlatformDialog(
        title: Text('글 작성하기'),
        content: Text('글을 게시하시겠습니까?'),
        children: [
          AlertPlatformDialogButton(
            child: Text('아니오'),
            onPressed: () {},
          ),
          AlertPlatformDialogButton(
            child: Text('예'),
            onPressed: () async => createPost(),
          ),
        ],
      ),
    );
  }
}
