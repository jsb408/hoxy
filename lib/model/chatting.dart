import 'package:cloud_firestore/cloud_firestore.dart';

class Chatting {
  Map<String, dynamic> member = {};
  CollectionReference? chat;
  DocumentReference? post;

  Chatting();

  Chatting.from(DocumentSnapshot chatting) {
    this.member = chatting['member'];
    this.post = chatting['post'];
    this.chat = chatting.reference.collection('chat');
  }

  Map<String, dynamic> toMap() => {
    'member' : this.member,
    'post' : this.post,
  };
}