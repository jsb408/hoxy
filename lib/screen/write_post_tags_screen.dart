import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              child: Text('적용'),
              onPressed: () => Get.back(result: _viewModel.tags),
            )
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Container(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                    [
                      for (Tag tag in _viewModel.tags)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 2),
                          child: InputChip(
                            label: Text(tag.name),
                            onPressed: () => _viewModel.removeTag(tag),
                            onDeleted: () => _viewModel.removeTag(tag),
                          ),
                        ),
                    ],
                ),
              ),
              TextField(
                controller: _viewModel.tagsTextFieldController,
                onChanged: (value) => _viewModel.search(value),
              ),
              Expanded(
                child: ListView(
                    children: [
                      if (_viewModel.searchKeyword.isNotEmpty
                          && _viewModel.tags.where((element) => element.name == _viewModel.searchKeyword).isEmpty)
                        ListTile(
                            title: Text('\'${_viewModel.searchKeyword}\' 등록'),
                            onTap: () => _viewModel.addTag(Tag(_viewModel.searchKeyword))),
                      for (Tag tag in _viewModel.samples)
                        ListTile(
                          title: Text(tag.name),
                          onTap: () => _viewModel.addTag(tag),
                        ),
                    ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
