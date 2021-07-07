import 'package:flutter/material.dart';
import 'package:hoxy/model/alert.dart';
import 'package:hoxy/screen/chat_room_screen.dart';

class ItemAlertList extends StatelessWidget {
  ItemAlertList({required this.alert});

  final Alert alert;

  @override
  Widget build(BuildContext context) {
    if (alert.type == 'apply') {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatRoomScreen(chattingId: alert.target)));
        },
        child: Container(
          color: Colors.white,
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  alert.emoji,
                  style: TextStyle(fontSize: 40),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      alert.content,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF707070),
                      ),
                    ),
                    Text(
                      '1일 전',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF707070),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    } else
      return Container();
  }
}
