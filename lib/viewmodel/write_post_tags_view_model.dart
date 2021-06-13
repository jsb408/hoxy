import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/tag.dart';

class WritePostTagsViewModel extends GetxController {
  WritePostTagsViewModel({required this.initialTags}) {
    _tags.value = initialTags;
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
    }
  }

  void removeTag(String tag) {
    _tags.remove(tag);
  }

  void search(String keyword) {
    if(keyword.length > 10) {
      _tagsTextFieldController.text = keyword.substring(0, 9);
    }

    _searchKeyword = _tagsTextFieldController.text;
    _filteredSamples = _samples
        .where((element) => element.name.startsWith(keyword))
        .where((element) => !_tags.contains(element.name)).toList();
    update();
  }
}