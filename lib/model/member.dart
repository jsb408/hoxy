import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  String uid = '';
  String email = '';
  String phone = '';
  String emoji = '😀';
  int birth = 0;
  String city = '';
  String town = '';
  int exp = 50;

  Member();

  Member.from(DocumentSnapshot doc) {
    this.uid = doc.id;
    this.email = doc['email'];
    this.emoji = doc['emoji'];
    this.birth = doc['birth'];
    this.city = doc['city'];
    this.town = doc['town'];
    this.exp = doc['exp'];
  }

  Map<String, dynamic> toMap() => {
    'uid' : this.uid,
    'email' : this.email,
    'birth' : this.birth,
    'emoji' : this.emoji,
    'city' : this.city,
    'town' : this.town,
    'exp' : this.exp
  };
}