import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/model/chat.dart';
import 'package:hoxy/view/chat_room_drawer.dart';
import 'package:hoxy/view/message_bubble.dart';
import 'package:hoxy/viewmodel/chatting_view_model.dart';
import 'dart:io' show Platform;

import '../constants.dart';

class ChatRoomScreen extends StatelessWidget {
  ChatRoomScreen({required this.chattingId});

  final String chattingId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChattingViewModel>(
        init: ChattingViewModel(chattingId: chattingId),
        builder: (_viewModel) {
          AppBar appBar = AppBar(
            title: Text(_viewModel.post.title),
            leading: IconButton(
              icon: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          );

          return Scaffold(
            appBar: appBar,
            endDrawer: ChatRoomDrawer(
              chatting: _viewModel.chatting,
              post: _viewModel.post,
              members: _viewModel.members,
              topPadding: appBar.preferredSize.height,
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    reverse: true,
                    children: [
                      if (_viewModel.members.isNotEmpty)
                        for (Chat chat in _viewModel.chats)
                          MessageBubble(
                            chat: chat,
                            sender: _viewModel.members
                                .singleWhere((element) => chat.sender!.id == element.uid),
                            chatting: _viewModel.chatting,
                          ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: Platform.isIOS ? 28 : 8,
                  ),
                  color: kPrimaryColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 14),
                          child: TextField(
                            controller: _viewModel.chatController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(left: 14),
                              fillColor: Colors.white,
                              filled: true,
                              hintText: '메세지 입력',
                              border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onChanged: (value) => _viewModel.inputMessage(value),
                          ),
                        ),
                      ),
                      TextButton(
                          child: Icon(Icons.send),
                          onPressed: () async => _viewModel.sendChat(chattingId))
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }
}
