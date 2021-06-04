import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/view/item_chatting_list.dart';
import 'package:hoxy/viewmodel/chat_list_view_model.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatListViewModel>(
      init: ChatListViewModel(),
      builder: (_viewModel) => Scaffold(
          appBar: AppBar(
            title: Text('채팅'),
            automaticallyImplyLeading: false,
          ),
          body: _viewModel.chattingList.isEmpty
              ? Center(child: Text('채팅이 없습니다'))
              : ListView(
                  children: [
                    for (Chatting chatting in _viewModel.chattingList)
                      ItemChattingList(chatting: chatting)
                  ],
                )),
    );
  }
}
