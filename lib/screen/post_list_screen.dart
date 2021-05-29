import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/view/item_post_list.dart';
import 'package:hoxy/viewmodel/post_list_view_model.dart';

import '../constants.dart';

class PostListScreen extends StatelessWidget {
  final PostListViewModel _viewModel = PostListViewModel();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: _viewModel.localityDropdown(_viewModel.user.city, _viewModel.user.town),
          automaticallyImplyLeading: false,
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => _viewModel.moveToWritePage(),
        ),
        backgroundColor: kBackgroundColor,
        body: _viewModel.posts.isEmpty
            ? Center(child: Text('등록된 글이 없습니다'))
            : ListView(children: [for (Post post in _viewModel.posts) ItemPostList(post: post)]),
        ),
      );
  }
}