import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hoxy/model/post.dart';

import '../constants.dart';
import 'grade_button.dart';

class ItemPostList extends StatelessWidget {
  ItemPostList({@required this.post});

  final Post post;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: post.writer.get(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                post.emoji,
                style: TextStyle(fontSize: 40),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: TextStyle(fontSize: 18, color: Colors.black)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('01.19 18시~21시 (3시간)', style: TextStyle(fontSize: 11, color: kTimeColor)),
                      GradeButton(birth: 1990),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${post.town} ${timeText(post.date)}",
                        style: TextStyle(fontSize: 12, color: kSubContentColor),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.remove_red_eye_outlined,
                            size: 12,
                            color: kSubContentColor,
                          ),
                          Text(post.view.toString(), style: TextStyle(fontSize: 12, color: kSubContentColor)),
                        ],
                      ),
                    ],
                  ),
                  Text(post.tag.join(' #'),
                    style: TextStyle(fontSize: 11, color: kTagColor),),
                ],
              ),
              Stack(
                alignment: Alignment.center,
                children: [
                  Icon(CupertinoIcons.circle, size: 50, color: Color.fromRGBO(234, 234, 234, 1.0)),
                  Text('1/4'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
