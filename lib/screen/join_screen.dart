import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/view/bottom_button.dart';
import 'package:hoxy/view/join_phone_number_text_field.dart';
import 'package:hoxy/view/join_text_field.dart';
import 'package:hoxy/viewmodel/join_view_model.dart';

class JoinScreen extends StatefulWidget {
  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  JoinViewModel viewModel = JoinViewModel();
  bool showCertTextField = false;
  bool isComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
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
                      child: Hero(
                        tag: 'logo',
                        child: Image.asset(
                          'images/logo.png',
                          width: 200,
                        ),
                      ),
                    ),
                  ),
                  JoinTextField(
                    title: '이메일',
                    textInputType: TextInputType.emailAddress,
                    hintText: '양식에 맞게 입력해주세요',
                    description: '로그인, 비밀번호 찾기 등에 사용됩니다.',
                    onChanged: (value) {
                      viewModel.email = value;
                    },
                  ),
                  JoinTextField(
                    title: '비밀번호',
                    hintText: '영문/숫자/기호를 모두 포함한 8자리 이상 입력',
                    description: '특수문자는 (! @ # \$ % ^ & ? _ ~) 만 가능합니다.',
                    obscureText: true,
                    onChanged: (value) {
                      viewModel.password = value;
                    },
                  ),
                  JoinTextField(
                    title: '비밀번호 확인',
                    hintText: '입력하신 비밀번호를 다시 한번 입력 해주세요.',
                    obscureText: true,
                    onChanged: (value) {
                      viewModel.confirm = value;
                    },
                  ),
                  Container(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '휴대전화 번호',
                          style: TextStyle(color: Colors.black),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              JoinPhoneNumberTextField(
                                hintText: ' - 기호를 제외한 번호를 입력해주세요',
                                buttonText: '인증하기',
                                onChanged: (value) {
                                  viewModel.phone = value;
                                },
                                onPressed: () {
                                  setState(() {
                                    showCertTextField = viewModel.isComplete;
                                  });
                                },
                              ),
                              Visibility(
                                visible: showCertTextField,
                                child: JoinPhoneNumberTextField(
                                  hintText: '인증번호 입력',
                                  buttonText: '확인',
                                  onChanged: (value) {
                                    viewModel.certNumber = value;
                                  },
                                  onPressed: () {
                                    setState(() {
                                      isComplete = viewModel.certNumber.isNotEmpty;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          BottomButton(
            buttonTitle: '진행하기',
            activated: isComplete,
            onTap: () {},
          )
        ],
      ),
    );
  }
}