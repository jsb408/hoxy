import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../constants.dart';

class ItemPostSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          color: Colors.white,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '😆',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 175, height: 15, color: Colors.white),
                      SizedBox(height: 2),
                      Container(width: 175, height: 9, color: Colors.white),
                      SizedBox(width: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(width: 85, height: 9, color: Colors.white),
                          SizedBox(width: 9),
                          Icon(
                            Icons.remove_red_eye_outlined,
                            size: 12,
                            color: kSubContentColor,
                          ),
                          SizedBox(width: 4),
                          Text('0', style: TextStyle(fontSize: 12, color: kSubContentColor)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Container(width: 175, height: 9, color: Colors.white),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        backgroundColor: kProgressBackgroundColor,
                        value: 0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          height: 0,
          thickness: 1,
        ),
      ],
    );
  }
}

class ItemChattingSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          color: Colors.white,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300],
            highlightColor: Colors.grey[100],
            child: Row(
              children: [
                SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(width: 135, height: 15, color: Colors.white),
                      SizedBox(height: 5),
                      Container(width: 110, height: 9, color: Colors.white),
                      SizedBox(height: 9),
                      Container(width: 110, height: 9, color: Colors.white),
                    ],
                  ),
                ),
                Container(width: 80, height: 12, color: Colors.white),
              ],
            ),
          ),
        ),
        Divider(height: 0, thickness: 2),
      ],
    );
  }
}