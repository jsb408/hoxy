import 'package:cloud_firestore/cloud_firestore.dart';

class Tag {
  String name = '';
  int count = 0;

  Tag(String name) {
    this.name = name;
    this.count = 1;
  }

  Tag.from(DocumentSnapshot doc) {
    this.name = doc.id;
    this.count = doc.get('count');
  }

  Map<String, dynamic> toMap() => {
    'name' : this.name,
    'count' : this.count,
  };
}