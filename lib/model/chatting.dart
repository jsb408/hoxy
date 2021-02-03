import 'package:cloud_firestore/cloud_firestore.dart';

class Chatting {
  Map<String, dynamic> member = {};
  DocumentReference? post;

  Chatting();

  Chatting.from(DocumentSnapshot chatting) {
    this.member = chatting['member'];
    this.post = chatting['post'];
  }

  Map<String, dynamic> toMap() => {
    'member' : this.member,
    'post' : this.post,
  };
}