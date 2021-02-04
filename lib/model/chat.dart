import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  String content = '';
  DocumentReference? sender;
  DateTime date = DateTime.now();

  Chat();

  Chat.from(DocumentSnapshot chat) {
    this.content = chat['content'];
    this.sender = chat['sender'];
    this.date = (chat['date'] as Timestamp).toDate();
  }

  Map<String, dynamic> toMap() => {
        'content': this.content,
        'sender': this.sender,
        'date': this.date,
      };
}
