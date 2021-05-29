import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hoxy/view/bottom_button.dart';
import 'package:hoxy/view/join_phone_number_text_field.dart';
import 'package:hoxy/view/join_text_field.dart';
import 'package:hoxy/viewmodel/join_view_model.dart';

class JoinScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future(() => !EasyLoading.isShow),
      child: Scaffold(
        appBar: AppBar(
          title: Text('회원가입'),
        ),
        backgroundColor: Colors.white,
        body: GetBuilder<JoinViewModel>(
          init: JoinViewModel(),
          builder: (_viewModel) => Column(
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
                      Form(
                        key: _viewModel.formKey,
                        child: Column(
                          children: [
                            JoinTextField(
                              title: '이메일',
                              readOnly: _viewModel.isComplete,
                              keyboardType: TextInputType.emailAddress,
                              hintText: '양식에 맞게 입력해주세요',
                              validator: (value) => _viewModel.checkEmail(value ?? ''),
                            ),
                            JoinTextField(
                              title: '비밀번호',
                              readOnly: _viewModel.isComplete,
                              hintText: '영문/숫자/기호를 모두 포함한 8자리 이상 입력',
                              obscureText: true,
                              validator: (value) => _viewModel.checkPassword(value ?? ''),
                            ),
                            JoinTextField(
                              title: '비밀번호 확인',
                              readOnly: _viewModel.isComplete,
                              hintText: '입력하신 비밀번호를 다시 한번 입력 해주세요.',
                              obscureText: true,
                              validator: (value) => _viewModel.checkConfirm(value ?? ''),
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
                                          hintText: ' - 기호 없이 숫자만 입력해주세요',
                                          readOnly: _viewModel.isComplete,
                                          buttonText: '인증하기',
                                          disabled: _viewModel.verificationId.isNotEmpty ||
                                              _viewModel.isComplete,
                                          validator: (value) => _viewModel.checkPhone(value ?? ''),
                                          onPressed: () async => _viewModel.checkValidate(),
                                        ),
                                        Visibility(
                                          visible: _viewModel.verificationId.isNotEmpty,
                                          child: JoinPhoneNumberTextField(
                                            hintText: '인증번호 입력',
                                            buttonText: '확인',
                                            validator: (value) {
                                              _viewModel.certNumber = value ?? '';
                                              return null;
                                            },
                                            onPressed: () async => _viewModel.checkCertNum(),
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
                    ],
                  ),
                ),
              ),
              BottomButton(
                buttonTitle: '진행하기',
                disabled: !_viewModel.isComplete,
                onTap: () => _viewModel.createUser(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
