import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/post.dart';
import 'package:intl/intl.dart';

import '../nickname.dart';

class PostViewModel {
  Post post = Post();
  String nickname = "${kNick[Random().nextInt(kNick.length)]} ${kName[Random().nextInt(kName.length)]}";

  get communicationLevel => kCommunicateLevels[post.communication];
  get formattedStartTime => DateFormat('yyyy년 MM월 dd일 HH:mm').format(post.start);
  get isIncomplete => post.title.isNotEmpty && post.content.isNotEmpty && post.headcount > 0 && post.start != null;

  putLocation(List<String> location) {
    post.city = location.first;
    post.town = location.last;
  }

  Future<bool> createPost() async {
    try {
      this.post
        ..date = DateTime.now()
        ..tag.insert(0, kCommunicateLevels[this.post.communication]);
      DocumentReference post = await kFirestore.collection('post').add(this.post.toMap());

      DocumentReference chatting = await kFirestore.collection('chatting').add({
        'post': post,
        'member': {nickname: this.post.writer.id}
      });

      await post.update({'chat': chatting});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
