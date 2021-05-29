import 'package:get/get.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/service/loading.dart';

class ReadPostViewModel extends GetxController {
  ReadPostViewModel({required this.postId}) {
    onInit();
    _isLoading.value = true;
    kFirestore.collection('post').doc('postId').get().then((value) => _post.value = Post.from(value));
  }

  final String postId;

  Rx<Post> _post = Post().obs;
  Post get post => _post.value;

  Rx<Chatting> _chatting = Chatting().obs;
  Chatting get chatting => _chatting.value;

  Rx<bool> _isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(_isLoading, (bool value) => value ? Loading.show() : Loading.dismiss());
  }
}