import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/view/bottom_button.dart';
import 'package:hoxy/view/write_property_button.dart';
import 'package:hoxy/viewmodel/post_view_model.dart';

enum Property { LOCATION, HEADCOUNT, COMMUNICATE }

class WritePostScreen extends StatefulWidget {
  WritePostScreen({@required this.user, @required this.selectedTown, @required this.locationList});

  final Member user;
  final int selectedTown;
  final List<List<String>> locationList;

  @override
  _WritePostScreenState createState() => _WritePostScreenState(selectedTown);
}

class _WritePostScreenState extends State<WritePostScreen> {
  PostViewModel _viewModel = PostViewModel();

  Member _user;

  List<List<String>> _locationList;
  get _townList => _locationList.map((e) => e.last).toList();
  FixedExtentScrollController _locationController;
  FixedExtentScrollController _headCountController = FixedExtentScrollController();
  FixedExtentScrollController _communicationController = FixedExtentScrollController();

  TextEditingController _tagController = TextEditingController();

  _WritePostScreenState(int initialLocation) {
    _locationController = FixedExtentScrollController(initialItem: initialLocation);
  }

  postPicker(FixedExtentScrollController controller, List<String> children, Property target) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 280,
        child: Column(
          children: [
            Row(
              children: [
                CupertinoButton(
                    child: Text('확인'),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: controller,
                itemExtent: 50,
                onSelectedItemChanged: (index) {
                  setState(() {
                    switch (target) {
                      case Property.LOCATION:
                        _locationController = FixedExtentScrollController(initialItem: index);
                        _viewModel.putLocation(_locationList[index]);
                        break;
                      case Property.HEADCOUNT:
                        _headCountController = FixedExtentScrollController(initialItem: index);
                        _viewModel.post.headcount = index + 2;
                        break;
                      case Property.COMMUNICATE:
                        _communicationController = FixedExtentScrollController(initialItem: index);
                        _viewModel.post
                          ..emoji = kCommunicateLevelIcons[index][Random().nextInt(3)]
                          ..communication = index;
                        break;
                    }
                  });
                },
                children: [for (String child in children) Center(child: Text(child))],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    _user = widget.user;
    _locationList = widget.locationList;

    _viewModel
      ..post.writer = kFirestore.collection('member').doc(_user.uid)
      ..putLocation(_locationList[widget.selectedTown]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('모임글 작성')),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all(color: kBackgroundColor, width: 0.5)),
                    child: TextField(
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
                      onChanged: (value) {
                        setState(() {
                          _viewModel.post.title = value;
                        });
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: WritePropertyButton(
                          title: _viewModel.post.town,
                          onTap: () {
                            postPicker(_locationController, _townList, Property.LOCATION);
                          },
                        ),
                      ),
                      Expanded(
                        child: WritePropertyButton(
                          title: _viewModel.post.headcount == 0 ? '모집인원' : _viewModel.post.headcount.toString(),
                          onTap: () {
                            if (_viewModel.post.headcount == 0)
                              setState(() {
                                _viewModel.post.headcount = 2;
                              });
                            postPicker(_headCountController, ['2', '3', '4'], Property.HEADCOUNT);
                          },
                        ),
                      ),
                    ],
                  ),
                  WritePropertyButton(
                    title: _viewModel.post.communication == null ? '소통레벨' : _viewModel.communicationLevel,
                    onTap: () {
                      if (_viewModel.post.communication == null)
                        setState(() {
                          _viewModel.post
                            ..emoji = kCommunicateLevelIcons[0][Random().nextInt(3)]
                            ..communication = 0;
                        });
                      postPicker(_communicationController, kCommunicateLevels, Property.COMMUNICATE);
                    },
                  ),
                  WritePropertyButton(
                    title: _viewModel.post.start == null ? '모임시간' : _viewModel.formattedStartTime,
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          height: 280,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  CupertinoButton(
                                      child: Text('확인'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                ],
                              ),
                              Expanded(
                                child: CupertinoDatePicker(
                                  minimumDate: DateTime.now(),
                                  initialDateTime: _viewModel.post.start,
                                  onDateTimeChanged: (DateTime value) {
                                    setState(() {
                                      _viewModel.post.start = value;
                                    });
                                    print(value);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    height: 220,
                    decoration: BoxDecoration(border: Border.all(color: kBackgroundColor, width: 0.5)),
                    child: TextField(
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
                      onChanged: (value) {
                        setState(() {
                          _viewModel.post.content = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(border: Border.all(color: kBackgroundColor, width: 0.5)),
                    child: Row(
                      children: [
                        Icon(CupertinoIcons.tag),
                        Flexible(
                          child: TextField(
                            controller: _tagController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '태그를 작성하시면 다양한 사람들이 볼 수 있어요',
                              contentPadding: EdgeInsets.only(left: 8),
                              hintStyle: TextStyle(
                                height: 0,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onChanged: (value) {
                              _viewModel.post.tag = value.split(' ');
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(border: Border(top: BorderSide(width: 0.5, color: kBackgroundColor))),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(style: TextStyle(fontSize: 13, color: Colors.black), children: [
                                TextSpan(text: '${_user.email}님은\n이번 모임에서 '),
                                TextSpan(
                                  text: _viewModel.nickname,
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                TextSpan(text: ' (으)로 활동합니다.')
                              ]),
                            ),
                          ),
                          Text('글 작성 시 모임 대화방이 생성되며,\n신청자는 대화방에 참여됩니다.',
                              textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: kAccentColor))
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
            disabled: !_viewModel.isIncomplete,
            onTap: () async {
              Loading.show();

              if (!await _viewModel.createPost()) {
                Loading.showError('업로드 실패');
                return;
              }

              Loading.showSuccess('업로드 완료');
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
