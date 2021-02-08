import 'package:cloud_firestore/cloud_firestore.dart';

class Chatting {
  String id = '';
  Map<String, dynamic> member = {};
  CollectionReference? chat;
  DocumentReference? post;

  Chatting();

  Chatting.from(DocumentSnapshot chatting) {
    this.id = chatting.id;
    this.member = chatting['member'];
    this.post = chatting['post'];
    this.chat = chatting.reference.collection('chat');
  }

  Map<String, dynamic> toMap() => {
    'member' : this.member,
    'post' : this.post,
  };
}