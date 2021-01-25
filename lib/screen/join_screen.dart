import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/screen/join_detail_screen.dart';
import 'package:hoxy/view/bottom_button.dart';
import 'package:hoxy/view/join_phone_number_text_field.dart';
import 'package:hoxy/view/join_text_field.dart';
import 'package:hoxy/view/progress_hud.dart';
import 'package:hoxy/viewmodel/join_view_model.dart';

import '../constants.dart';

class JoinScreen extends StatefulWidget {
  @override
  _JoinScreenState createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen> {
  final _formKey = GlobalKey<FormState>();

  JoinViewModel viewModel = JoinViewModel();

  bool _isComplete = false;
  bool _isLoading = false;
  String _verificationId = '';

  void showLoadingBar() {
    setState(() {
      _isLoading = true;
    });
  }

  void hideLoadingBar() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('회원가입'),
      ),
      backgroundColor: Colors.white,
      body: ProgressHUD(
        inAsyncCall: _isLoading,
        child: Column(
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
                      key: _formKey,
                      child: Column(
                        children: [
                          JoinTextField(
                            title: '이메일',
                            textInputType: TextInputType.emailAddress,
                            hintText: '양식에 맞게 입력해주세요',
                            validator: (value) {
                              return viewModel.checkEmail(value);
                            },
                          ),
                          JoinTextField(
                            title: '비밀번호',
                            hintText: '영문/숫자/기호를 모두 포함한 8자리 이상 입력',
                            obscureText: true,
                            validator: (value) {
                              return viewModel.checkPassword(value);
                            },
                          ),
                          JoinTextField(
                            title: '비밀번호 확인',
                            hintText: '입력하신 비밀번호를 다시 한번 입력 해주세요.',
                            obscureText: true,
                            validator: (value) {
                              return viewModel.checkConfirm(value);
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
                                        disabled: _verificationId.isNotEmpty,
                                        validator: (value) {
                                          return viewModel.checkPhone(value);
                                        },
                                        onPressed: () async {
                                          showLoadingBar();
                                          if (_formKey.currentState.validate()) {
                                            await kAuth.verifyPhoneNumber(
                                              phoneNumber: viewModel.formattedPhone,
                                              verificationCompleted: (credential) async {
                                                setState(() {
                                                  _isComplete = true;
                                                });
                                              },
                                              verificationFailed: (e) {
                                                print(e);
                                                hideLoadingBar();
                                              },
                                              codeSent: (verificationId, resendToken) {
                                                print(verificationId);
                                                setState(() {
                                                  _verificationId = verificationId;
                                                  hideLoadingBar();
                                                });
                                              },
                                              codeAutoRetrievalTimeout: (verificationId) async {
                                                setState(() {
                                                  _verificationId = '';
                                                });
                                              },
                                            );
                                          } else hideLoadingBar();
                                        },
                                      ),
                                      Visibility(
                                        visible: _verificationId.isNotEmpty,
                                        child: JoinPhoneNumberTextField(
                                          hintText: '인증번호 입력',
                                          buttonText: '확인',
                                          validator: (value) {
                                            viewModel.certNumber = value;
                                            return null;
                                          },
                                          onPressed: () async {
                                            showLoadingBar();
                                            try {
                                              print(_verificationId);
                                              PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
                                                  verificationId: _verificationId, smsCode: viewModel.certNumber);
                                              final newUser = await kAuth.signInWithCredential(phoneAuthCredential);
                                              if (newUser != null) {
                                                setState(() {
                                                  _isComplete = true;
                                                });
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                            hideLoadingBar();
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
                  ],
                ),
              ),
            ),
            BottomButton(
              buttonTitle: '진행하기',
              disabled: !_isComplete,
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => JoinDetailScreen(viewModel: viewModel)));
              },
            )
          ],
        ),
      ),
    );
  }
}
