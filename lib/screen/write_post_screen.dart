import 'package:flutter/material.dart';

class WritePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('모임글 작성'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('모임지역 >'),
                Text('모임인원 >'),
              ],
            ),
            Text('소통레벨 >'),
            Text('모임시간 >'),
            TextField(),
            Row(
              children: [
                Icon(Icons.tag),
                Expanded(child: TextField(),),
              ],
            ),
            Text('kgun38@gmail.com님은 이번 모임에서 하얀여우로 활동합니다.'),
          ],
        ),
      ),
      floatingActionButton: Container(
        width: double.infinity,
        height: 80,
        child: FloatingActionButton.extended(
          shape: ContinuousRectangleBorder(),
          isExtended: true,
          label: Text(
            '작성하기',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
          ),
          onPressed: () {},
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
