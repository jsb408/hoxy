import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/screen/main_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/service/location.dart';
import 'package:hoxy/view/background_button.dart';
import 'package:hoxy/view/bottom_button.dart';
import 'package:hoxy/view/grade_button.dart';
import 'package:hoxy/viewmodel/join_view_model.dart';

class JoinDetailScreen extends StatefulWidget {
  JoinDetailScreen({this.viewModel});

  final viewModel;

  @override
  _JoinDetailScreenState createState() => _JoinDetailScreenState();
}

class _JoinDetailScreenState extends State<JoinDetailScreen> {
  JoinViewModel _viewModel;
  TextEditingController _birthTextEditingController = TextEditingController();
  FixedExtentScrollController _birthPickerController =
      FixedExtentScrollController();

  CupertinoPicker birthPicker() {
    return CupertinoPicker(
      scrollController: _birthPickerController,
      itemExtent: 50,
      onSelectedItemChanged: (index) {
        setState(() {
          _viewModel.member.birth = DateTime.now().year - 19 - index;
          _birthTextEditingController.text = _viewModel.member.birth.toString();
        });
      },
      children: [
        for (int i = DateTime.now().year - 19; i > DateTime.now().year - 49; i--)
          Center(child: Text(i.toString()))
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => !EasyLoading.isShow);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('정보설정'),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          'images/logo.png',
                          width: 200,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40, bottom: 80),
                      child: Table(
                        columnWidths: {
                          0: FractionColumnWidth(0.35),
                          1: FixedColumnWidth(27)
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            children: [
                              Text(
                                '위치 설정',
                                textAlign: TextAlign.right,
                                style: kJoinTextStyle,
                              ),
                              SizedBox(),
                              Row(
                                children: [
                                  Text(
                                    _viewModel.member.town.isNotEmpty
                                        ? _viewModel.member.town
                                        : '동네 이름',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: _viewModel.member.town.isNotEmpty
                                          ? Colors.black
                                          : Colors.grey,
                                      fontWeight: FontWeight.w100,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  BackgroundButton(
                                    title: '설정하기',
                                    onPressed: () async {
                                      try {
                                        Loading.show();
                                        if (await LocationService
                                            .getCurrentLocation())
                                          Loading.showError('권한을 설정해주세요');
                                        else
                                          setState(() {
                                            _viewModel
                                              ..member.city = LocationService
                                                  .currentAddress.locality
                                              ..member.town = LocationService
                                                  .currentAddress.subLocality;
                                          });
                                        Loading.dismiss();
                                      } catch (e) {
                                        print(e);
                                        Loading.showError('오류가 발생했습니다');
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                          TableRow(children: [
                            SizedBox(height: 30),
                            SizedBox(height: 30),
                            SizedBox(height: 30)
                          ]),
                          TableRow(
                            children: [
                              Text(
                                '사용 연령 설정',
                                textAlign: TextAlign.right,
                                style: kJoinTextStyle,
                              ),
                              SizedBox(),
                              TextField(
                                readOnly: true,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  hintText: '출생년도 입력',
                                ),
                                controller: _birthTextEditingController,
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => Container(
                                        height: 250, child: birthPicker()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _viewModel.member.birth > 0,
                      child: Column(
                        children: [
                          Text('${_viewModel.member.email}님은',
                              style: kJoinTextStyle),
                          SizedBox(height: 18),
                          GradeButton(birth: _viewModel.member.birth),
                          SizedBox(height: 18),
                          Text('입니다.', style: kJoinTextStyle),
                          SizedBox(height: 50),
                          Text(
                              'HOXY 서비스는 설정한 위치와 연령이\n'
                              '다른 사용자에게 표시되며\n'
                              '닉네임은 모임마다 랜덤으로 생성됩니다.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomButton(
              buttonTitle: '가입하기',
              disabled: !_viewModel.isComplete,
              onTap: () async {
                Loading.show();
                if (await _viewModel.createUser()) {
                  Loading.dismiss();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                } else Loading.showError('가입에 실패했습니다');
              },
            ),
          ],
        ),
      ),
    );
  }
}
