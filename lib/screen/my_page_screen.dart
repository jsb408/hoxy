
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/screen/ban_list_screen.dart';
import 'package:hoxy/service/emoji_service.dart';
import 'package:hoxy/view/background_button.dart';
import 'package:hoxy/view/grade_button.dart';
import 'package:hoxy/view/my_page_element.dart';
import 'package:hoxy/viewmodel/my_page_view_model.dart';

import '../constants.dart';

class MyPageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyPageViewModel>(
      init: MyPageViewModel(),
      builder: (_viewModel) => Scaffold(
        appBar: AppBar(
          title: Text('마이페이지'),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () => _viewModel.signOut()
            )
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 12, right: 36, left: 12),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                                  '${_viewModel.user.email} 님은',
                                  textAlign: TextAlign.end,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GradeButton(birth: _viewModel.user.birth),
                                SizedBox(width: 5),
                                  Text(
                                    '입니다',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 36),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _viewModel.user.emoji,
                            style: TextStyle(fontSize: 60),
                          ),
                          Container(
                            width: 42,
                            height: 24,
                            child: BackgroundButton(
                              title: '변경',
                              textStyle: TextStyle(fontSize: 8, color: Colors.white),
                              color: kDisabledColor,
                              onPressed: () => _viewModel.showEmojiDialog(EmojiService.randomEmoji()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  MyPageLocation(
                    icon: CupertinoIcons.map_pin_ellipse,
                    title: '현재 동네',
                    titleColor: Color(0xFFF58651),
                    location: _viewModel.currentTownName,
                    onTap: () async => _viewModel.updateLocation(),
                  ),
                  MyPageLocation(
                    icon: Icons.home_outlined,
                    title: '우리 동네',
                    location: _viewModel.myTownName,
                    onTap: () => _viewModel.changeLocation()
                  ),
                ],
              ),
            ),
            SizedBox(height: 1),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white,
              child: Column(
                children: [
                  MyPageButton(
                    icon: CupertinoIcons.person_crop_circle_badge_xmark,
                    title: '만남거부목록',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BanListScreen())),
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
