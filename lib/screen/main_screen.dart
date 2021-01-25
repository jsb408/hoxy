import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/screen/chat_list_screen.dart';
import 'package:hoxy/screen/home_screen.dart';
import 'package:hoxy/screen/my_page_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _screens = [HomeScreen(), HomeScreen(), ChatListScreen(), MyPageScreen()];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('풍덕천동'),
        automaticallyImplyLeading: false,
      ),
      body: WillPopScope(
        onWillPop: () {
          return Future(() => false);
        },
        child: Center(
          child: _screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: kPrimaryColor,
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          showSelectedLabels: false,
          backgroundColor: Colors.black,
          unselectedItemColor: Colors.black,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '우리동네'),
            BottomNavigationBarItem(icon: Icon(Icons.whatshot_outlined), label: '이름없는기능'),
            BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline), label: '채팅'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '마이페이지'),
          ],
        ),
      ),
    );
  }
}
