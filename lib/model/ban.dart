import 'package:cloud_firestore/cloud_firestore.dart';

class Ban {
  String id = '';
  DocumentReference? user;
  DateTime date = DateTime.now();
  DocumentReference? chatting;
  DocumentReference? pair;
  bool active = true;

  Ban();

  Ban.from(DocumentSnapshot doc) {
    this.id = doc.id;
    this.user = doc['user'];
    this.date = (doc['date'] as Timestamp).toDate();
    this.chatting = doc['chatting'];
    this.active = doc['active'];
    if(this.active) this.pair = doc['pair'];
  }

  Map<String, dynamic> toMap() => {
    'id' : this.id,
    'user' : this.user,
    'date' : this.date,
    'chatting' : this.chatting,
    'pair' : this.pair,
    'active' : this.active,
  };
}