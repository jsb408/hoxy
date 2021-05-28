import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hoxy/view/background_button.dart';
import 'package:hoxy/viewmodel/login_email_view_model.dart';


class LoginEmailScreen extends StatelessWidget {
  final LoginEmailViewModel _viewModel = LoginEmailViewModel();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future(() => !EasyLoading.isShow);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('로그인'),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이메일',
                  ),
                  onChanged: (value) => _viewModel.email = value,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '패스워드',
                  ),
                  onChanged: (value) => _viewModel.password = value,
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: BackgroundButton(
                  title: '로그인',
                  onPressed: () async => _viewModel.login(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
