import 'package:get/get.dart';
import 'package:hoxy/model/chat.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/post.dart';

class ItemChattingListViewModel extends GetxController {
  ItemChattingListViewModel({required this.chatting});

  Chatting chatting;
  Post post = Post();
  Chat? recentChat = Chat();

  @override
  void onInit() {
    super.onInit();

    chatting.post!.snapshots().listen((event) {
      post = Post.from(event);
      update();
    });

    chatting.chat!.orderBy('date', descending: true).snapshots().listen((event) {
      recentChat = event.docs.isEmpty ? null : Chat.from(event.docs.first);
      update();
    });
  }
}