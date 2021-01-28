import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id = '';
  String title = '';
  String content = '';
  DocumentReference writer;
  int headcount = 0;
  List<String> tag = [];
  DateTime date = DateTime.now();
  int communication;
  DateTime start;
  DateTime end;
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
    this.headcount = doc['headcount'];
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

  Map<String, dynamic> toMap() => {
    'title' : this.title,
    'content' : this.content,
    'writer' : this.writer,
    'headcount' : this.headcount,
    'tag' : this.tag,
    'date' : this.date,
    'communication' : this.communication,
    'start' : this.start,
    'end' : this.end,
    'city' : this.city,
    'town' : this.town,
    'view' : this.view,
    'chat' : this.chat
  };
}