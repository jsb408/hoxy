import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/post.dart';
import 'package:intl/intl.dart';

import '../nickname.dart';

class PostViewModel {
  Post post = Post();
  String nickname = randomNickname;

  set geoPoint(GeoPoint geoPoint) => post.location = geoPoint;

  get communicationLevel => kCommunicateLevels[post.communication];
  get formattedStartTime => DateFormat('MM월 dd일 HH:mm').format(post.start ?? DateTime.now());
  get isIncomplete => post.title.isNotEmpty && post.content.isNotEmpty && post.headcount > 0 && post.start != null;

  Future<bool> createPost() async {
    try {
      this.post
        ..date = DateTime.now()
        ..tag.insert(0, kCommunicateLevels[this.post.communication]);
      DocumentReference post = await kFirestore.collection('post').add(this.post.toMap());
      DocumentReference chatting = await kFirestore.collection('chatting').add({
        'post': post,
        'member': { this.post.writer!.id : nickname }
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

  List<Post> filterPosts(List<QueryDocumentSnapshot> docs, GeoPoint location) {
    final posts = docs.map((e) => Post.from(e));

    return posts.where((element) => Geolocator.distanceBetween(
        location.latitude, location.longitude,
        element.location!.latitude, element.location!.longitude) < 5000).toList();
  }
}
