import 'package:cloud_firestore/cloud_firestore.dart';

class Alert {
  String id = '';
  DateTime date = DateTime.now();
  String title = '';
  String content = '';
  String type = '';
  String uid = '';
  String emoji = '';
  String target = '';

  Alert.from(DocumentSnapshot doc) {
    this.id = doc.id;
    this.date = (doc['date'] as Timestamp).toDate();
    this.title = doc['title'];
    this.content = doc['content'];
    this.emoji = doc['emoji'];
    this.type = doc['type'];
    this.uid = doc['uid'];
    this.target = doc['target'];
  }
}