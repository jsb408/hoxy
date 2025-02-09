import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/view/item_post_list.dart';

import '../constants.dart';

class ItemRelateList extends StatelessWidget {
  ItemRelateList({required this.postId, required this.tag});

  final String postId;
  final String tag;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot> (
      stream: kFirestore.collection('post')
        .where('tag', arrayContains: tag)
        .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        
        List<QueryDocumentSnapshot> posts = snapshot.data!.docs.where((element) => element.id != postId && Post.from(element).start!.isAfter(DateTime.now())).toList();
        
        if (snapshot.data!.docs.length > 0) {
          List<int> dices = [];

          while (dices.length < (posts.length > 3 ? 3 : posts.length)) {
            int dice = Random().nextInt(posts.length);
            if (!dices.contains(dice)) dices.add(dice);
          }

          return Column(
                children: [
                  for (int dice in dices) ItemPostList(post: Post.from(posts[dice])),
                ]
          );
        } return Container();
      }
    );
  }
}
