
import 'package:flutter/material.dart';
import 'package:hoxy/model/chat.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/screen/profile_screen.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.chat, required this.sender, required this.chatting});

  final Chat chat;
  final Member sender;
  final Chatting chatting;

  bool get isMe => sender.uid == kAuth.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.only(right: 5),
                child: Text(sender.emoji, style: TextStyle(fontSize: 30)),
              ),
              onTap: () {
                ProfileScreen.present(context, sender, chatting);
              },
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (!isMe)
                Text(
                  chatting.nickname[sender.uid],
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                  ),
                ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (isMe)
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        DateFormat('MM.dd. HH:mm').format(chat.date),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  Material(
                    borderRadius: isMe
                        ? BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomLeft: Radius.circular(5.0),
                    )
                        : BorderRadius.only(
                      topLeft: Radius.circular(5.0),
                      topRight: Radius.circular(5.0),
                      bottomRight: Radius.circular(5.0),
                    ),
                    color: isMe ? kPrimaryColor : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                      child: Text(
                        chat.content,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                  ),
                  if (!isMe)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        DateFormat('MM.dd. HH:mm').format(chat.date),
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
