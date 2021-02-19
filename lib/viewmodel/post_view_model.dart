import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/screen/write_post_screen.dart';
import 'package:hoxy/view/alert_platform_dialog.dart';
import 'package:intl/intl.dart';

import '../nickname.dart';

class PostViewModel {
  Post post = Post();
  String nickname = randomNickname;

  set geoPoint(GeoPoint geoPoint) => post.location = geoPoint;

  get communicationLevel => kCommunicateLevels[post.communication];
  get formattedStartTime => DateFormat('MM월 dd일 HH:mm').format(post.start ?? DateTime.now());
  get formattedTime => '$formattedStartTime~${DateFormat('HH시 mm분').format((post.start ?? DateTime.now()).add(Duration(minutes: post.duration)))} (${NumberFormat('0.#').format(post.duration / 60)}시간)';
  get isIncomplete => post.title.isNotEmpty && post.content.isNotEmpty && post.headcount > 0 && post.start != null;

  Future<bool> createPost() async {
    try {
      this.post
        ..date = DateTime.now()
        ..tag.insert(0, kCommunicateLevels[this.post.communication]);
      DocumentReference post = await kFirestore.collection('post').add(this.post.toMap());
      DocumentReference chatting = await kFirestore.collection('chatting').add({
        'post': post,
        'member': {this.post.writer!.id: nickname},
        'date': DateTime.now(),
      });

      await post.update({'chat': chatting});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updatePost() async {
    try {
      post.tag[0] = kCommunicateLevels[this.post.communication];
      await kFirestore.collection('post').doc(post.id).update(this.post.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deletePost() async {
    try {
      post.chat!.delete().whenComplete(() => kFirestore.collection('post').doc(post.id).delete());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  List<Post> filterPosts(List<QueryDocumentSnapshot> docs, GeoPoint location) {
    final posts = docs.map((e) => Post.from(e));

    return posts
        .where((element) =>
            Geolocator.distanceBetween(
                location.latitude, location.longitude, element.location!.latitude, element.location!.longitude) <
            5000)
        .toList();
  }

  List<String> relatedTag() {
    List<int> dices = post.tag.isEmpty ? [] : [0];

    while (dices.length < (post.tag.length > 3 ? 3 : post.tag.length)) {
      int dice = Random().nextInt(post.tag.length - 1) + 1;
      if (!dices.contains(dice)) dices.add(dice);
    }

    return List.generate(dices.length, (index) => post.tag[dices[index]]);
  }

  void showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertPlatformDialog(
        title: Text('삭제하기'),
        content: Text('삭제하시겠습니까?'),
        children: [
          AlertPlatformDialogButton(
            child: Text('아니오'),
            onPressed: () {},
          ),
          AlertPlatformDialogButton(
            child: Text('예'),
            onPressed: () {
              deletePost();
            },
          ),
        ],
      ),
    );
  }

  void showUpdatePost(BuildContext context, Member user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WritePostScreen(user: user, viewModel: this)),
    );
  }

  Future<bool> reportPost(String content) async {
    try {
      await kFirestore.collection('report').add({
        'writer': kFirestore.collection('member').doc(kAuth.currentUser.uid),
        'post': kFirestore.collection('post').doc(post.id),
        'date': DateTime.now(),
        'content': content
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}