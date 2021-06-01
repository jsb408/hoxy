import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/view/background_button.dart';
import 'package:hoxy/view/grade_button.dart';
import 'package:hoxy/view/item_relate_list.dart';
import 'package:hoxy/viewmodel/read_post_view_model.dart';
import 'package:intl/intl.dart';
import 'dart:io' show Platform;

class ReadPostScreen extends StatelessWidget {
  ReadPostScreen({required this.postId});

  final String postId;

  Divider divider() => Divider(height: 0, thickness: 1);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ReadPostViewModel> (
      init: ReadPostViewModel(postId: postId),
      builder: (_viewModel) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(_viewModel.post.title),
          actions: [_viewModel.writer.uid == kAuth.currentUser?.uid
                ? _viewModel.writerActionSheet()
                : _viewModel.viewerActionSheet()
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(_viewModel.post.emoji, style: TextStyle(fontSize: 40)),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('예정시간',
                                      style: TextStyle(color: Color.fromRGBO(55, 68, 78, 1.0))),
                                  Text(
                                    _viewModel.formattedTime,
                                    style: TextStyle(fontSize: 14, color: kTimeColor),
                                  ),
                                  SizedBox(height: 6),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${_viewModel.post.town} ${timeText(_viewModel.post.date)}",
                                        style: TextStyle(fontSize: 12, color: kSubContentColor),
                                      ),
                                      SizedBox(width: 9),
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 12,
                                        color: kSubContentColor,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        (_viewModel.post.view).toString(),
                                        style: TextStyle(fontSize: 12, color: kSubContentColor),
                                      ),
                                      SizedBox(width: 12),
                                      GradeButton(birth: _viewModel.writer.birth),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                CircularProgressIndicator(
                                  backgroundColor: kProgressBackgroundColor,
                                  value: _viewModel.chatting.member.length /
                                      _viewModel.post.headcount,
                                ),
                                Text('${_viewModel.chatting.member.length}/${_viewModel.post.headcount}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      divider(),
                      Container(
                        padding: EdgeInsets.only(top: 20, right: 25, left: 25, bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(minHeight: 300),
                              child: Text(_viewModel.post.content, style: TextStyle(fontSize: 20)),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.rotationY(pi),
                                    child: Icon(CupertinoIcons.tag)),
                                SizedBox(width: 5),
                                Expanded(
                                  child: Text(
                                    '#${_viewModel.post.tag.join(' #')}',
                                    style: TextStyle(fontSize: 15, color: kTagColor),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      divider(),
                      Container(
                        padding: EdgeInsets.only(top: 10, right: 15, left: 25, bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        _viewModel.nickname,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(width: 3),
                                      Text(_viewModel.post.town,
                                          style: TextStyle(fontSize: 12, color: kDisabledColor)),
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text('인연지수', style: TextStyle(color: kDisabledColor)),
                                      Icon(Icons.help_outline, size: 8),
                                      SizedBox(width: 2),
                                      Container(
                                        width: 53,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: LinearProgressIndicator(
                                            minHeight: 8,
                                            backgroundColor: kExpBackgroundColor,
                                            valueColor: AlwaysStoppedAnimation<Color>(kExpValueColor),
                                            value: _viewModel.writer.exp / 100,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '총 모임참여 ${_viewModel.writer.participation}회',
                              style: TextStyle(fontSize: 12, color: kDisabledColor),
                            ),
                          ],
                        ),
                      ),
                      divider(),
                      Padding(
                        padding: EdgeInsets.only(left: 25, top: 8, right: 15),
                        child: Text('연관모임'),
                      ),
                      //TODO: 연관글이 없으면 안 뜨게 해야
                      for (String tag in _viewModel.relatedTag())
                        ItemRelateList(postId: _viewModel.post.id, tag: tag)
                    ],
                  ),
                ),
              ),
            ),
            Container(
              //height: 110,
              child: Column(
                children: [
                  Divider(
                    height: 1,
                    thickness: 2,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, right: 16, bottom: Platform.isIOS ? 48 : 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${DateFormat('MM월 dd일 HH시').format(_viewModel.post.start ?? DateTime.now())} 예정',
                                style: TextStyle(
                                  color: Color.fromRGBO(26, 59, 196, 1.0),
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    _viewModel.post.town,
                                    style: TextStyle(fontSize: 14, color: kDisabledColor),
                                  ),
                                  SizedBox(width: 4),
                                  Text(
                                    '${_viewModel.nickname}님의 모임',
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: SizedBox(
                            width: 142,
                            height: 44,
                            child: BackgroundButton(
                              title: '신청하기',
                              onPressed: () => _viewModel.showApplyDialog(),
                              disabled: _viewModel.chatting.member.contains(kAuth.currentUser?.uid),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
