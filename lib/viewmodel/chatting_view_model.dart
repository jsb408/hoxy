import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/chat.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/model/post.dart';

import '../constants.dart';

class ChattingViewModel extends GetxController {
  ChattingViewModel({required this.chattingId});

  final String chattingId;

  Chatting _chatting = Chatting();
  Chatting get chatting => _chatting;

  Post _post = Post();
  Post get post => _post;

  List<Member> _members = [];
  List<Member> get members => _members;

  List<Chat> _chats = [];
  List<Chat> get chats => _chats;

  Chat _chat = Chat();
  Chat get chat => _chat;

  TextEditingController chatController = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    kFirestore.collection('chatting').doc(chattingId).snapshots().listen((event) {
      _chatting = Chatting.from(event);

      _chatting.post!.snapshots().listen((event) {
        _post = Post.from(event);
        update();
      });

      _chatting.chat!.snapshots().listen((event) {
        _chats = event.docs.map((e) => Chat.from(e)).toList();
        update();
      });

      update();
    });

    kFirestore.collection('member').snapshots().listen((event) {
      _members = event.docs.map((e) => Member.from(e)).toList();
      update();
    });
  }

  void inputMessage(String message) {
    _chat.content = message;
  }

  Future sendChat(String chattingId) async {
    if(chat.content.isEmpty) return;

    await kFirestore.collection('chatting').doc(chattingId).collection('chat').add({
      'content': chat.content,
      'sender': kFirestore.collection('member').doc(kAuth.currentUser?.uid),
      'date': DateTime.now()
    }).catchError((error) {
      print(error);
    });

    await kFirestore.collection('chatting').doc(chattingId).update({'date': DateTime.now()}).catchError((error) {
      print(error);
    });

    chatController.clear();
  }
}