import 'package:flutter/material.dart';
import 'package:hoxy/screen/write_post_screen.dart';
import 'package:hoxy/service/location.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedLocality = LocationService.currentAddress.subLocality;

  DropdownButtonHideUnderline _localityDropdown() {
    List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(
        child: Text(LocationService.currentAddress.subLocality),
        value: LocationService.currentAddress.subLocality,
      ),
      DropdownMenuItem(child: Text('양재동'), value: '양재동'),
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: _selectedLocality,
        underline: null,
        items: items,
        onChanged: (value) {
          setState(() {
            _selectedLocality = value;
          });
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _localityDropdown(),
        automaticallyImplyLeading: false,
      ),
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
