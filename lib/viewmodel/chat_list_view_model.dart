import 'package:get/get.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/service/loading.dart';

import '../constants.dart';

class ChatListViewModel extends GetxController {
  List<Chatting> chattingList = [].cast<Chatting>();

  @override
  void onInit() {
    super.onInit();

    Loading.show();
    kFirestore
        .collection('chatting')
        .where('member', arrayContains: kAuth.currentUser?.uid)
        .snapshots()
        .listen((event) {
      chattingList = event.docs.map((e) => Chatting.from(e)).toList();
      chattingList.sort((a, b) => (b.date).compareTo(a.date));
      Loading.dismiss();
      update();
    });
  }
}
