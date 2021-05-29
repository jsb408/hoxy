import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/screen/write_post_tags_screen.dart';
import 'package:hoxy/view/bottom_button.dart';
import 'package:hoxy/view/write_property_button.dart';
import 'package:hoxy/viewmodel/write_post_view_model.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

enum Property { LOCATION, HEADCOUNT, COMMUNICATE, DURATION }

class WritePostScreen extends StatelessWidget {
  WritePostScreen({this.selectedTown});

  final int? selectedTown;

  /*@override
  void initState() {
    super.initState();

    if (widget.viewModel == null) {
      _locationList = widget.locationList;

      _viewModel
        ..post.writer = kFirestore.collection('member').doc(user.uid)
        ..post.town = _locationList![widget.selectedTown!]
        ..geoPoint = widget.selectedTown == 0 ? LocationService.geoPoint : user.location;
    } else {
      _viewModel = widget.viewModel!;

      _titleController.text = _viewModel.post.title;
      _contentController.text = _viewModel.post.content;
      _tagController.text = _viewModel.post.tag.sublist(1).join(" ");

      _headCountController = FixedExtentScrollController(initialItem: _viewModel.post.headcount - 2);
      _communicationController = FixedExtentScrollController(initialItem: _viewModel.post.communication);
      _durationController = FixedExtentScrollController(initialItem: _viewModel.post.duration ~/ 30 - 1);
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('모임글 작성')),
      backgroundColor: Colors.white,
      body: GetBuilder<WritePostViewModel>(
        init: WritePostViewModel(selectedTown: selectedTown),
        builder: (_viewModel) => Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: kBackgroundColor, width: 0.5)),
                      child: TextField(
                        controller: _viewModel.titleController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '글 제목',
                          contentPadding: EdgeInsets.only(left: 30),
                          hintStyle: TextStyle(
                            height: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onChanged: (value) => _viewModel.title = value,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: WritePropertyButton(
                            title: _viewModel.post.town,
                            onTap: () => _viewModel.postPicker(_viewModel.locationController,
                                _viewModel.locationList, Property.LOCATION),
                            hasData: true,
                            //TODO : disabled
                            //disabled: widget.viewModel != null,
                          ),
                        ),
                        Expanded(
                          child: WritePropertyButton(
                            title: _viewModel.post.headcount < 2
                                ? '모집인원'
                                : _viewModel.post.headcount.toString(),
                            onTap: () => _viewModel.showHeadcountPicker(),
                            hasData: _viewModel.post.headcount >= 2,
                          ),
                        ),
                      ],
                    ),
                    WritePropertyButton(
                      title: _viewModel.post.communication == 9
                          ? '소통레벨'
                          : _viewModel.communicationLevel,
                      onTap: () => _viewModel.showCommunicationLevelPicker(),
                      hasData: _viewModel.post.communication != 9,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: WritePropertyButton(
                            title: _viewModel.post.start == null
                                ? '시작시간'
                                : _viewModel.formattedStartTime,
                            onTap: () => _viewModel.showStartTimePicker(),
                            hasData: _viewModel.post.start != null,
                          ),
                        ),
                        Expanded(
                          child: WritePropertyButton(
                            title: _viewModel.post.duration == 0
                                ? '모임시간'
                                : '${NumberFormat('0.#').format(_viewModel.post.duration / 60)}시간',
                            onTap: () => _viewModel.showDurationPicker(),
                            hasData: _viewModel.post.duration > 0,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 220,
                      decoration:
                          BoxDecoration(border: Border.all(color: kBackgroundColor, width: 0.5)),
                      child: TextField(
                          controller: _viewModel.contentController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: '모임의 성격과 소통레벨에 맞게 작성해주세요.',
                            contentPadding: EdgeInsets.only(left: 20),
                            hintStyle: TextStyle(
                              height: 0,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onChanged: (value) => _viewModel.content = value),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20),
                      decoration:
                          BoxDecoration(border: Border.all(color: kBackgroundColor, width: 0.5)),
                      child: Row(
                        children: [
                          Icon(CupertinoIcons.tag),
                          Flexible(
                            child: WritePropertyButton(
                              title: _viewModel.post.tag.isEmpty
                                  ? '태그'
                                  : '#' + _viewModel.post.tag.join(' #'),
                              onTap: () async => _viewModel.inputTags(
                                await Get.to(
                                  () => WritePostTagsScreen(tags: _viewModel.post.tag),
                                  fullscreenDialog: true,
                                ),
                              ),
                              hasData: _viewModel.post.tag.isNotEmpty,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(top: BorderSide(width: 0.5, color: kBackgroundColor))),
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: TextStyle(fontSize: 13, color: Colors.black),
                                    children: [
                                      TextSpan(text: '${_viewModel.user.email}님은\n이번 모임에서 '),
                                      TextSpan(
                                        text: _viewModel.nickname,
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                      ),
                                      TextSpan(text: ' (으)로 활동합니다.')
                                    ]),
                              ),
                            ),
                            Text('글 작성 시 모임 대화방이 생성되며,\n신청자는 대화방에 참여됩니다.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 11, color: kAccentColor))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomButton(
              buttonTitle: '등록하기',
              disabled: !_viewModel.isComplete,
              onTap: () => _viewModel.showWriteDialog(),
            ),
          ],
        ),
      ),
    );
  }
}
