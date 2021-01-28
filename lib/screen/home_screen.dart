import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/write_post_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/service/location.dart';
import 'package:hoxy/view/item_post_list.dart';

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
              Loading.show();
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
                  builder: (context) =>
                      WritePostScreen(user: user, selectedTown: _selectedLocality, locationList: locationList),
                ),
              );
            },
          ),
          body: snapshot.hasData
              ? StreamBuilder<QuerySnapshot>(
                  stream: kFirestore
                      .collection('post')
                      .where('city', isEqualTo: locationList[_selectedLocality].first)
                      .where('town', isEqualTo: locationList[_selectedLocality].last)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    Loading.dismiss();

                    if (snapshot.data.docs.isEmpty) {
                      return Center(child: Text('등록된 글이 없습니다'));
                    }

                    final posts = snapshot.data.docs.reversed;
                    List<ItemPostList> postList = [
                      for(var post in posts) ItemPostList(post: Post.from(post))
                    ];

                    return ListView(
                      children: postList,
                    );
                  },
                )
              : Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
