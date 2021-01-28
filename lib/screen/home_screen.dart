import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/screen/write_post_screen.dart';
import 'package:hoxy/service/location.dart';

import '../constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedLocality = 0;

  DropdownButtonHideUnderline _localityDropdown(String city, String town) {
    List<DropdownMenuItem<int>> items = [
      DropdownMenuItem(
        child: Text(LocationService.townName),
        value: 0,
      ),
      if (LocationService.cityName != city || LocationService.townName != town)
        DropdownMenuItem(child: Text(town), value: 1),
    ];

    return DropdownButtonHideUnderline(
      child: DropdownButton<int>(
          value: _selectedLocality,
          items: items,
          onChanged: (value) {
            setState(() {
              _selectedLocality = value;
            });
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: kFirestore.collection('member').doc(kAuth.currentUser.uid).get(),
      builder: (context, snapshot) {
        Member user = snapshot.hasData ? Member.from(snapshot.data) : Member();
        List<List<String>> locationList = [
          [LocationService.cityName, LocationService.townName]
        ];
        if (LocationService.cityName != user.city || LocationService.townName != user.town)
          locationList.add([user.city, user.town]);
        return Scaffold(
          appBar: AppBar(
            title: snapshot.hasData ? _localityDropdown(user.city, user.town) : Text('우리 동네'),
            automaticallyImplyLeading: false,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WritePostScreen(user: user, selectedTown: _selectedLocality, locationList: locationList),
                ),
              );
            },
          ),
          body: snapshot.hasData
              ? Container(
                  child: Center(
                    child: Text('${kCommunicateLevelIcons[0][0]} Home Screen'),
                  ),
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
