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
  String _selectedLocality = LocationService.townName;

  DropdownButtonHideUnderline _localityDropdown(String town) {
    List<DropdownMenuItem<String>> items = [
      DropdownMenuItem(
        child: Text(LocationService.townName),
        value: LocationService.townName,
      ),
      if(LocationService.townName != town)
        DropdownMenuItem(child: Text(town), value: town),
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
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: kFirestore.collection('member').doc(kAuth.currentUser.uid).get(),
      builder: (context, snapshot) {
        Member user = snapshot.hasData? Member.from(snapshot.data) : Member();
          return Scaffold(
            appBar: AppBar(
              title: snapshot.hasData ? _localityDropdown(user.town) : Text('우리 동네'),
              automaticallyImplyLeading: false,
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WritePostScreen(user: snapshot.data.reference, selectedTown: _selectedLocality,)));
              },
            ),
            body: snapshot.hasData ? Container(
              child: Center(
                child: Text('${kCommunicateLevelIcons[0][0]} Home Screen'),
              ),
            ) : Center(child: CircularProgressIndicator()),
          );
      },
    );
  }
}
