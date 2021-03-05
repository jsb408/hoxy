import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/ban.dart';
import 'package:hoxy/view/item_ban_list.dart';

import '../constants.dart';

class BanListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('만남거부목록')),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 36,
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Text(
              '아래 목록의 회원들과 서로의 게시글이 표시되지 않습니다',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF645C5C),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: kFirestore.collection('member').doc(kAuth.currentUser.uid).collection('ban').where('active', isEqualTo: true).snapshots(),
              builder: (context, snapshot) {
                return snapshot.hasData ? Expanded(
                  child: ListView(
                    children: [
                      for (QueryDocumentSnapshot doc in snapshot.data!.docs) ItemBanList(banSnapshot: doc),
                    ],
                  ),
                ) : Container();
              }),
        ],
      ),
    );
  }
}
