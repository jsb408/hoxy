import 'package:hoxy/model/chat.dart';

import '../constants.dart';

class ChatViewModel {
  Chat chat = Chat();

  Future<void> sendChat(String chattingId) async {
    if(chat.content.isEmpty) return;

    await kFirestore.collection('chatting').doc(chattingId).collection('chat').add({
      'content': chat.content,
      'sender': kFirestore.collection('member').doc(kAuth.currentUser.uid),
      'date': DateTime.now()
    }).catchError((error) {
      print(error);
    });

    await kFirestore.collection('chatting').doc(chattingId).update({'date': DateTime.now()}).catchError((error) {
      print(error);
    });
  }
}
