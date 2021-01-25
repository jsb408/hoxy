import 'package:flutter/material.dart';
import 'package:hoxy/screen/write_post_screen.dart';

import '../constants.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => WritePostScreen()));
        },
      ),
      body: Container(
        child: Center(
          child: Text('${kCommunicateLevelIcons[0][0]} Home Screen'),
        ),
      ),
    );
  }
}
