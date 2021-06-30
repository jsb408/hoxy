import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/screen/chat_list_screen.dart';
import 'package:hoxy/screen/post_list_screen.dart';
import 'package:hoxy/screen/my_page_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _screens = [PostListScreen(), PostListScreen(), ChatListScreen(), MyPageScreen()];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    kMessaging.subscribeToTopic(kAuth.currentUser!.uid);

    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Center(
            child: _screens[_selectedIndex],
          ),
        ),
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: kPrimaryColor,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          unselectedItemColor: Colors.black,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '우리동네'),
            BottomNavigationBarItem(icon: Icon(CupertinoIcons.bell), label: '알림'),
            BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),
          ],
        ),
      ),
    );
  }
}
