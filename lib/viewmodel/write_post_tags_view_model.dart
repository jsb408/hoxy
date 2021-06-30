import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/tag.dart';
import 'package:hoxy/view/alert_platform_dialog.dart';

class WritePostTagsViewModel extends GetxController {
  WritePostTagsViewModel({required this.initialTags}) {
    _tags.value = initialTags.toList();
  }

  final List<String> initialTags;

  RxList<String> _tags = [].cast<String>().obs;
  List<String> get tags => _tags;

  List<Tag> _samples = [];

  List<Tag> _filteredSamples = [];
  List<Tag> get filteredSamples => _filteredSamples;

  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  TextEditingController _tagsTextFieldController = TextEditingController();
  TextEditingController get tagsTextFieldController => _tagsTextFieldController;

  ScrollController _tagsScrollController = ScrollController();
  ScrollController get tagsScrollController => _tagsScrollController;
  
  @override
  void onInit() {
    super.onInit();

    kFirestore.collection('tag').get().then((value) {
      _samples = value.docs.map((e) => Tag.from(e)).toList();
      _samples.sort((a, b) => a.count < b.count ? 1 : 0);
      search('');
      update();
    });

    ever(_tags, (value) => search(_searchKeyword));
  }

  void addTag(String tag) {
    if(_tags.length < 5 && !_tags.contains(tag)) {
      _tagsTextFieldController.text = '';
      _searchKeyword = '';
      _tags.add(tag);
      _tagsScrollController.animateTo(_tagsScrollController.position.maxScrollExtent + 250, duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    } else if(_tags.length >= 5) {
      Get.dialog(
        AlertPlatformDialog(
            title: Text('태그가 너무 많아요'),
            content: Text('태그는 5개까지 작성 가능합니다.'),
            children: [AlertPlatformDialogButton(child: Text('확인'), onPressed: () {})],
        )
      );
    }
  }

  void removeTag(String tag) {
    _tags.remove(tag);
  }

  void search(String keyword) {
    if(keyword.length > 10) {
      _tagsTextFieldController.text = keyword.substring(0, 10);
      Get.dialog(
          AlertPlatformDialog(
            title: Text('태그가 너무 길어요'),
            content: Text('태그 길이는 10자 이내로 작성 바랍니다.'),
            children: [AlertPlatformDialogButton(child: Text('확인'), onPressed: () {})],
          )
      );
    }

    _searchKeyword = _tagsTextFieldController.text;
    _filteredSamples = _samples
        .where((element) => element.name.startsWith(keyword))
        .where((element) => !_tags.contains(element.name)).toList();
    update();
  }
}