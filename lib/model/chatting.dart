import 'package:cloud_firestore/cloud_firestore.dart';

class Chatting {
  String id = '';
  Map<String, dynamic> member = {};
  CollectionReference? chat;
  DocumentReference? post;
  DateTime date = DateTime.now();

  Chatting();

  Chatting.from(DocumentSnapshot chatting) {
    this.id = chatting.id;
    this.member = chatting['member'];
    this.post = chatting['post'];
    this.chat = chatting.reference.collection('chat');
    this.date = (chatting['date'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() => {
    'member' : this.member,
    'post' : this.post,
    'date' : this.date,
  };
}