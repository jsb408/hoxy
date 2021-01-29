import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id = '';
  String title = '';
  String content = '';
  DocumentReference writer;
  int headcount = 0;
  List<String> tag = [];
  DateTime date = DateTime.now();
  String emoji;
  int communication;
  DateTime start;
  DateTime end;
  String city = '';
  String town = '';
  GeoPoint location;
  String geohash = '';
  int view = 0;
  DocumentReference chat;

  Post();

  Post.from(DocumentSnapshot doc) {
    this.id = doc.id;
    this.title = doc['title'];
    this.content = doc['content'];
    this.writer = doc['writer'];
    this.headcount = doc['headcount'];
    this.tag = (doc['tag'] as List<dynamic>).map((e) => e.toString()).toList();
    this.date = (doc['date'] as Timestamp).toDate();
    this.emoji = doc['emoji'];
    this.communication = doc['communication'];
    this.start = (doc['start'] as Timestamp).toDate();
    this.end = (doc['end'] as Timestamp).toDate();
    this.city = doc['city'];
    this.town = doc['town'];
    this.location = doc['location'];
    this.geohash = doc['geohash'];
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
    'emoji' : this.emoji,
    'communication' : this.communication,
    'start' : this.start,
    'end' : this.end,
    'city' : this.city,
    'town' : this.town,
    'location' : this.location,
    'geohash' : this.geohash,
    'view' : this.view,
    'chat' : this.chat
  };
}