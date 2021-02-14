import 'package:flutter/material.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';

class ItemMemberList extends StatelessWidget {
  const ItemMemberList({required this.member, required this.chatting, this.isLeader = false, this.isMe = false});

  final Member member;
  final Chatting chatting;
  final bool isLeader, isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Text(
            '${member.emoji} ${chatting.member[member.uid]}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          if (isLeader)
            Padding(
              padding: EdgeInsets.only(left: 4),
              child: Image.asset(
                'images/crown.png',
                width: 14,
              ),
            ),
          if (isMe)
            Padding(
              padding: EdgeInsets.only(left: 4),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5944D),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text('나', style: TextStyle(fontSize: 8, color: Colors.white)),
                ],
              ),
            )
        ],
      ),
    );
  }
}