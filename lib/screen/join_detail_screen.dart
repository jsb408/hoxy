import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
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
  bool _isComplete = false;
  bool _rightYear = false;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  '동네 이름',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w100,
                                  ),
                                ),
                                SizedBox(width: 12),
                                BackgroundButton(
                                    title: '설정하기', onPressed: () {}),
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
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: '출생년도 입력',
                              ),
                              onChanged: (value) {
                                int birth = int.parse(value);
                                setState(() {
                                  if (birth > 1900) {
                                    _rightYear = true;
                                    _viewModel.birth = birth;
                                  } else
                                    _rightYear = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _rightYear,
                    child: Column(
                      children: [
                        Text('${_viewModel.email}님은', style: kJoinTextStyle),
                        SizedBox(height: 18),
                        GradeButton(grade: _viewModel.grade),
                        SizedBox(height: 18),
                        Text('입니다.', style: kJoinTextStyle),
                        SizedBox(height: 50),
                        Text(
                            'HOXY 서비스는 설정한 위치와 연령이\n'
                                '다른 사용자에게 표시되며\n'
                                '닉네임은 모임마다 랜덤으로 생성됩니다.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color:Colors.black)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          BottomButton(
            buttonTitle: '가입하기',
            disabled: !_isComplete,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
