import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/service/loading.dart';

import '../constants.dart';

class ChatListViewModel extends GetxController {
  List<Chatting> chattingList = [].cast<Chatting>();

  @override
  void onInit() {
    super.onInit();

    Loading.show();

    kFirestore.collection('post')
      .snapshots()
      .listen((postSnapshot) { 
        List<Post> postList = postSnapshot.docs.map((e) => Post.from(e)).toList();

        kFirestore
          .collection('chatting')
          .where('member', arrayContains: kAuth.currentUser?.uid)
          .snapshots()
          .listen((event) {
            chattingList = event.docs.map((e) => Chatting.from(e))
              .where((element) {
                Post post = postList.singleWhere((post) => post.id == element.post!.id);
                return post.start!.add(Duration(
                  hours: 12,
                  minutes: post.duration,
                )).isAfter(DateTime.now());
              }).toList();
            chattingList.sort((a, b) => (b.date).compareTo(a.date));
            Loading.dismiss();
            update();
        });
      });
  }
}
