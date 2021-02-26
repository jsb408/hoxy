import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/ban.dart';
import 'package:hoxy/model/chatting.dart';
import 'package:hoxy/model/member.dart';
import 'package:hoxy/service/loading.dart';

class ItemBanList extends StatelessWidget {
  ItemBanList({required this.banSnapshot});

  final QueryDocumentSnapshot banSnapshot;

  @override
  Widget build(BuildContext context) {
    Ban ban = Ban.from(banSnapshot);

    return StreamBuilder<DocumentSnapshot>(
        stream: ban.user!.snapshots(),
        builder: (context, snapshot) {
          Member user = snapshot.hasData ? Member.from(snapshot.data!) : Member();

          return StreamBuilder<DocumentSnapshot>(
              stream: ban.chatting!.snapshots(),
              builder: (context, snapshot) {
                Chatting chatting = snapshot.hasData ? Chatting.from(snapshot.data!) : Chatting();

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Row(
                    children: [
                      SizedBox(width: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${user.emoji} ${chatting.nickname[user.uid]}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 5),
                          Text(
                            user.town,
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF707070),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, size: 14),
                        onPressed: () async {
                          Loading.show();
                          await ban.pair!.delete();
                          await banSnapshot.reference.delete();
                          Loading.dismiss();
                        },
                      ),
                    ],
                  ),
                );
              });
        });
  }
}
