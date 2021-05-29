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
  Rx<Member> _user = Member().obs;
  Member get user => _user.value;

  RxList<DocumentReference> _banned = [].cast<DocumentReference>().obs;
  RxList<Post> _posts = [].cast<Post>().obs;
  List<Post> get posts => _posts;

  Rx<bool> _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  Rx<int> _selectedLocality = 0.obs;
  int get selectedLocality => _selectedLocality.value;

  List<String> _locationList = [];

  PostListViewModel() {
    onInit();

    Future<DocumentSnapshot> snapshot = kFirestore.collection('member').doc(kAuth.currentUser?.uid).get();
    Stream<QuerySnapshot> bannedSnapshot = kFirestore.collection('member').doc(kAuth.currentUser?.uid).collection('ban').snapshots();

    snapshot.then((value) {
      _user.value = Member.from(value);
      _locationList.add(LocationService.townName);
      if (LocationService.cityName != _user.value.city || LocationService.townName != _user.value.town)
        _locationList.add(_user.value.town);
    });

    bannedSnapshot.listen((event) => _banned.value = event.docs.map((e) => Ban.from(e).user!).toList());
  }

  @override
  void onInit() {
    super.onInit();
    ever(_isLoading, (bool value) => value ? Loading.show() : Loading.dismiss());
    ever(_banned, (List<DocumentReference> value) => refreshPosts());
    ever(_selectedLocality, (int value) => refreshPosts());
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
          value: _selectedLocality.value,
          items: items,
          onChanged: (value) {
            _isLoading.value = true;
            _selectedLocality.value = value ?? 0;
          },
      ),
    );
  }

  void moveToWritePage() => Get.to(() => WritePostScreen(selectedTown: _selectedLocality.value));

  void refreshPosts() {
    kFirestore.collection('post').orderBy('date', descending: true).snapshots()
        .listen((event) =>
    _posts.value = event.docs.where((element) =>
    LocationService.distanceBetween(
        _selectedLocality.value == 0 ? LocationService.geoPoint : user.location,
        element.get('location')) < 5000
        && !_banned.contains(element['writer'] as DocumentReference))
        .map((e) => Post.from(e))
        .toList());
    _isLoading.value = false;
  }
}