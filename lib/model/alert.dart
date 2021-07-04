import 'package:cloud_firestore/cloud_firestore.dart';

class Alert {
  String id = '';
  DateTime date = DateTime.now();
  String content = '';
  String type = '';
  String uid = '';

  Alert.from(DocumentSnapshot doc) {
    this.id = doc.id;
    this.date = (doc['date'] as Timestamp).toDate();
    this.content = doc['content'];
    this.type = doc['type'];
    this.uid = doc['uid'];
  }
}