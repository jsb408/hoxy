import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id = '';
  String title = '';
  String content = '';
  DocumentReference writer;
  List<String> tag = [];
  DateTime date = DateTime.now();
  int communication = 0;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();
  String city = '';
  String town = '';
  int view = 0;
  DocumentReference chat;

  Post();

  Post.from(DocumentSnapshot doc) {
    this.id = doc.id;
    this.title = doc['title'];
    this.content = doc['content'];
    this.writer = doc['writer'];
    this.tag = doc['tag'];
    this.date = doc['date'];
    this.communication = doc['communication'];
    this.start = doc['start'];
    this.end = doc['end'];
    this.city = doc['city'];
    this.town = doc['town'];
    this.view = doc['view'];
    this.chat = doc['chat'];
  }
}