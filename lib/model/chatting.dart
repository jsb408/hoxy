import 'package:cloud_firestore/cloud_firestore.dart';

class Chatting {
  String id = '';
  List<String> member = [];
  Map<String, dynamic> nickname = {};
  CollectionReference? chat;
  DocumentReference? post;
  DateTime date = DateTime.now();

  Chatting();

  Chatting.from(DocumentSnapshot chatting) {
    this.id = chatting.id;
    this.member = (chatting['member'] as List<dynamic>).map((e) => e.toString()).toList();
    this.nickname = chatting['nickname'];
    this.post = chatting['post'];
    this.chat = chatting.reference.collection('chat');
    this.date = (chatting['date'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() => {
    'member' : this.member,
    'nickname' : this.nickname,
    'post' : this.post,
    'date' : this.date,
  };
}