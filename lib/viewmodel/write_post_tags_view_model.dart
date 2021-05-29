import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/tag.dart';

class WritePostTagsViewModel extends GetxController {
  WritePostTagsViewModel({required this.initialTags}) {
    _tags = initialTags.map((e) => Tag(e)).toList();
  }

  final List<String> initialTags;

  List<Tag> _tags = [];
  List<Tag> get tags => _tags;

  List<Tag> _samples = [];
  List<Tag> get samples => _samples;

  String _searchKeyword = '';
  String get searchKeyword => _searchKeyword;

  Rx<TextEditingController> _tagsTextFieldController = TextEditingController().obs;
  TextEditingController get tagsTextFieldController => _tagsTextFieldController.value;

  @override
  void onInit() {
    super.onInit();
    search('');

    ever(_tagsTextFieldController, (TextEditingController value) => search(value.text));
  }

  void addTag(Tag tag) {
    if(_tags.length < 5 && _tags.where((element) => element.name == tag.name).isEmpty)
      _tags.add(tag);
    _tagsTextFieldController.update((val) => val!.text = '' );
    update();
  }

  void removeTag(Tag tag) {
    _tags.remove(tag);
    update();
  }

  void search(String keyword) {
    _searchKeyword = keyword;
    kFirestore.collection('tag').get().then((value) {
      _samples = value.docs.map((e) => Tag.from(e))
          .where((element) => element.name.startsWith(keyword))
          .where((element) => _tags.where((tag) => tag.name == element.name).isEmpty).toList();
      _samples.sort((a, b) => a.count < b.count ? 1 : 0);
      update();
    });
  }
}