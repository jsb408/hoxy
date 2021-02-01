import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/post.dart';
import 'package:hoxy/view/item_post_list.dart';

import '../constants.dart';

class ItemRelateList extends StatelessWidget {
  ItemRelateList({@required this.tag});

  final String tag;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: kFirestore
          .collection('post')
          .where('tag', arrayContains: tag)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<Post> posts = snapshot.data.docs.map((e) => Post.from(e)).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text('#$tag'),
            ),
            Column(
              children: [for (int i = 0; i < 3; i++) ItemPostList(post: posts[Random().nextInt(posts.length)])],
            ),
          ],
        );
      },
    );
  }
}
