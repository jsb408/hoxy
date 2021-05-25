import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/service/loading.dart';

import '../constants.dart';

class ChattingViewModel {
  Chatting chatting = Chatting();

  Future<void> enterChatRoom(String nickname) async {
    chatting.member.add(kAuth.currentUser!.uid);

    await kFirestore
        .collection('chatting')
        .doc(chatting.id)
        .update({
      'member': chatting.member,
      'nickname.${kAuth.currentUser?.uid}': nickname,
    }).catchError((error) {
      print(error);
      Loading.showError('신청 오류');
    });
    await kFirestore
        .collection('chatting')
        .doc(chatting.id)
        .update({
      'date': DateTime.now()
    });
  }

  Future<void> escapeChatRoom() async {
    chatting.member.remove(kAuth.currentUser?.uid);
    await kFirestore
        .collection('chatting')
        .doc(chatting.id)
        .update({'member': chatting.member});
  }
}