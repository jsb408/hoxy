import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/ban.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/write_post_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/service/location_service.dart';

import '../constants.dart';

class PostListViewModel extends GetxController {
  Member _user = Member();
  Member get user => _user;

  RxList<DocumentReference> _banned = [].cast<DocumentReference>().obs;
  RxList<Post> _posts = [].cast<Post>().obs;
  List<Post> get posts => _posts;

  int _selectedLocality = 0;
  int get selectedLocality => _selectedLocality;

  List<String> _locationList = [];

  @override
  void onInit() {
    super.onInit();

    Future<DocumentSnapshot> snapshot =
        kFirestore.collection('member').doc(kAuth.currentUser?.uid).get();

    snapshot.then((value) {
      _user = Member.from(value);
      _locationList.add(LocationService.townName);
      if (LocationService.cityName != _user.city ||
          LocationService.townName != _user.town) _locationList.add(_user.town);
      update();
    });

    kFirestore.collection('member').doc(kAuth.currentUser?.uid).collection('ban').snapshots()
        .listen((event) => _banned.value = event.docs.map((e) => Ban.from(e).user!).toList());

    refreshPosts();
  }

  DropdownButtonHideUnderline localityDropdown(String city, String town) {
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
          Loading.show();
          _selectedLocality = value ?? 0;
          refreshPosts();
          update();
        },
      ),
    );
  }

  void moveToWritePage() => Get.to(() => WritePostScreen(selectedTown: _selectedLocality));

  void refreshPosts() {
    kFirestore.collection('post').orderBy('date', descending: true).snapshots().listen((event) {
      _posts.value = event.docs
          .where((element) =>
      LocationService.distanceBetween(
          _selectedLocality == 0 ? LocationService.geoPoint : user.location,
          element.get('location')) <
          5000 &&
          !_banned.contains(element['writer'] as DocumentReference))
          .map((e) => Post.from(e))
          .toList();
      Loading.dismiss();
    });
  }
}
