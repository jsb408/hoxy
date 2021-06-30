import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/tag.dart';
import 'package:hoxy/viewmodel/write_post_tags_view_model.dart';

class WritePostTagsScreen extends StatelessWidget {
  WritePostTagsScreen({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WritePostTagsViewModel>(
      init: WritePostTagsViewModel(initialTags: tags),
      builder: (_viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('태그추가'),
          actions: [
            TextButton(
              child: Text('적용', style: TextStyle(color: Colors.black)),
              onPressed: () => Get.back(result: _viewModel.tags),
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              color: Color(0xFFCFCFCF),
              height: 50,
              child: ListView(
                controller: _viewModel.tagsScrollController,
                scrollDirection: Axis.horizontal,
                children: [
                  for (String tag in _viewModel.tags)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: InputChip(
                        label: Text(tag, style: TextStyle(color: Colors.white)),
                        backgroundColor: kTagChipColor,
                        deleteIcon: Icon(CupertinoIcons.multiply, size: 14),
                        deleteIconColor: Colors.white,
                        onDeleted: () => _viewModel.removeTag(tag),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    children: [
                      TextField(
                        controller: _viewModel.tagsTextFieldController,
                        onChanged: (value) => _viewModel.search(value),
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 20, top: 20),
                        child: Text('추천 태그',
                            style: TextStyle(
                              color: Color(0xFF676767),
                            )),
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            if (_viewModel.searchKeyword.isNotEmpty &&
                                !_viewModel.tags.contains(_viewModel.searchKeyword))
                              ListTile(
                                  title: Text('\'${_viewModel.searchKeyword}\' 등록하기'),
                                  onTap: () => _viewModel
                                      .addTag(_viewModel.searchKeyword.removeAllWhitespace)),
                            for (Tag tag in _viewModel.filteredSamples)
                              ListTile(
                                title: Text(tag.name),
                                //trailing: Text(tag.count.toString()),
                                onTap: () => _viewModel.addTag(tag.name),
                              ),
                          ],
                        ),
                      ),
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}
