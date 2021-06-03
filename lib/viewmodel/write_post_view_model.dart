import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/model/tag.dart';
import 'package:hoxy/screen/write_post_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/service/location_service.dart';
import 'package:hoxy/view/alert_platform_dialog.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import '../nickname.dart';

class WritePostViewModel extends GetxController {
  WritePostViewModel({this.selectedTown, String? post}) {
    Loading.show();

    kFirestore.collection('member').doc(kAuth.currentUser!.uid).get().then((value) {
      _user.value = Member.from(value);
      _locationList.add(LocationService.townName);
      _locationList.add(_user.value.town);
      _post
        ..writer = kFirestore.collection('member').doc(user.uid)
        ..town = _locationList[selectedTown ?? 0]
        ..location = selectedTown == 0 ? LocationService.geoPoint : user.location;

      _locationController = FixedExtentScrollController(initialItem: selectedTown ?? 0);

      if(post ==  null) {
        update();
        Loading.dismiss();
      }
    });

    if (post != null) {
      updateMode = true;

      kFirestore.collection('post').doc(post).snapshots().listen((event) {
        _post = Post.from(event);
        _post.tag = _post.tag.sublist(1);

        _titleController.text = _post.title;
        _contentController.text = _post.content;
        _tagController.text = "#${_post.tag.join(" #")}";

        _headCountController = FixedExtentScrollController(initialItem: _post.headcount - 2);
        _communicationController = FixedExtentScrollController(initialItem: _post.communication);
        _durationController = FixedExtentScrollController(initialItem: _post.duration ~/ 30 - 1);

        _post.chat!.snapshots().listen((value) {
          nickname = (value.get('nickname') as Map<String, dynamic>)[kAuth.currentUser!.uid]!;
          update();
        });

        update();
        Loading.dismiss();
      });
    }
  }

  Post _post = Post();
  Post get post => _post;
  Rx<Member> _user = Member().obs;
  Member get user => _user.value;
  String nickname = randomNickname;

  bool updateMode = false;

  int? selectedTown;

  List<String> _locationList = [];
  List<String> get locationList => _locationList;

  set title(String title) => _post.title = title;
  set content(String content) => _post.content = content;

  get communicationLevel => kCommunicateLevels[_post.communication];

  get formattedStartTime => DateFormat('MM월 dd일 HH:mm').format(_post.start ?? DateTime.now());

  get formattedTime =>
      '$formattedStartTime~${DateFormat('HH시 mm분').format((_post.start ?? DateTime.now()).add(Duration(minutes: _post.duration)))} (${NumberFormat('0.#').format(_post.duration / 60)}시간)';

  bool get isComplete =>
      _post.title.isNotEmpty &&
      _post.content.isNotEmpty &&
      _post.headcount > 0 &&
      _post.start != null &&
      _post.duration > 0 &&
      _post.communication != 9;

  TextEditingController _titleController = TextEditingController();
  TextEditingController get titleController => _titleController;
  TextEditingController _contentController = TextEditingController();
  TextEditingController get contentController => _contentController;
  TextEditingController _tagController = TextEditingController();
  TextEditingController get tagController => _tagController;

  FixedExtentScrollController _locationController = FixedExtentScrollController();
  FixedExtentScrollController get locationController => _locationController;
  FixedExtentScrollController _headCountController = FixedExtentScrollController();
  FixedExtentScrollController get headCountController => _headCountController;
  FixedExtentScrollController _communicationController = FixedExtentScrollController();
  FixedExtentScrollController get communicationController => _communicationController;
  FixedExtentScrollController _durationController = FixedExtentScrollController();
  FixedExtentScrollController get durationController => _durationController;

  void showHeadcountPicker() {
    if (_post.headcount < 2) {
      _post.headcount = 2;
      update();
    }
    postPicker(_headCountController, ['2', '3', '4'], Property.HEADCOUNT);
  }

  void showCommunicationLevelPicker() {
    if (_post.communication == 9) {
      _post
        ..emoji = kCommunicateLevelIcons[0][Random().nextInt(3)]
        ..communication = 0;
      update();
    }
    postPicker(_communicationController, kCommunicateLevels, Property.COMMUNICATE);
  }

  void showDurationPicker() {
    if (_post.duration == 0) {
      _post.duration = 30;
      update();
    }
    postPicker(_durationController,
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
                  initialDateTime: _post.start ??
                      DateTime.now().add(Duration(
                          minutes: DateTime.now().minute >= 30
                              ? 60 - DateTime.now().minute
                              : 30 - DateTime.now().minute)),
                  onDateTimeChanged: (DateTime value) {
                    _post.start = value;
                    update();
                  }),
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
                      _locationController = FixedExtentScrollController(initialItem: index);
                      _post
                        ..town = _locationList[index]
                        ..location = index == 0 ? LocationService.geoPoint : _user.value.location;
                      break;
                    case Property.HEADCOUNT:
                      _headCountController = FixedExtentScrollController(initialItem: index);
                      _post.headcount = index + 2;
                      break;
                    case Property.COMMUNICATE:
                      _communicationController = FixedExtentScrollController(initialItem: index);
                      _post
                        ..emoji = kCommunicateLevelIcons[index][Random().nextInt(3)]
                        ..communication = index;
                      break;
                    case Property.DURATION:
                      _durationController = FixedExtentScrollController(initialItem: index);
                      _post.duration = (index + 1) * 30;
                      break;
                  }
                  update();
                },
                children: [for (String child in children) Center(child: Text(child))],
              ),
            ),
          ],
        ),
      ));

  Future createPost() async {
    try {
      DocumentReference post = await kFirestore.collection('post').add(_post.toMap());
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

  Future updatePost() async {
    try {
      await kFirestore.collection('post').doc(_post.id).update(_post.toMap());

      Loading.showSuccess('수정 완료');
      Get.back();
    } catch (e) {
      print(e);
      Loading.showError('수정 실패');
    }
  }

  void countTag() {
    kFirestore.collection('tag').get().then((tags) => _post.tag.forEach((tag) {
          if (tags.docs.where((element) => element.id == tag).isNotEmpty) {
            kFirestore.collection('tag').doc(tag).update(
                {'count': tags.docs.firstWhere((element) => element.id == tag).get('count') + 1});
          } else {
            kFirestore.collection('tag').doc(tag).set(Tag(tag).toMap());
          }
        }));
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
            onPressed: () async {
              countTag();

              _post
                ..date = DateTime.now()
                ..tag.insert(0, kCommunicateLevels[this.post.communication]);

              Loading.show();

              if(updateMode)
                updatePost();
              else
                createPost();
            },
          ),
        ],
      ),
    );
  }

  void inputTags(List<Tag>? tags) {
    if (tags != null) _post.tag = tags.map((e) => e.name).toList();
    update();
  }
}
