import 'package:flutter/material.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/view/bottom_button.dart';
import 'package:hoxy/view/write_property_button.dart';

class WritePostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('모임글 작성')),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: kBackgroundColor, width: 0.5)),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '글 제목',
                        contentPadding: EdgeInsets.only(left: 30),
                        hintStyle: TextStyle(
                          height: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: WritePropertyButton(
                          title: '모임지역',
                          onTap: () {},
                        ),
                      ),
                      Expanded(
                        child: WritePropertyButton(
                          title: '모임인원',
                          onTap: () {},
                        ),
                      )
                    ],
                  ),
                  WritePropertyButton(
                    title: '소통레벨',
                    onTap: () {},
                  ),
                  WritePropertyButton(
                    title: '모임시간',
                    onTap: () {},
                  ),
                  Container(
                    height: 280,
                    decoration: BoxDecoration(
                        border: Border.all(color: kBackgroundColor, width: 0.5)),
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '모임의 성격과 소통레벨에 맞게 작성해주세요.',
                        contentPadding: EdgeInsets.only(left: 20),
                        hintStyle: TextStyle(
                          height: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: kBackgroundColor, width: 0.5)),
                    child: Row(
                      children: [
                        Icon(Icons.tag),
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: '태그를 작성하시면 다양한 사람들이 볼 수 있어요',
                              contentPadding: EdgeInsets.only(left: 8),
                              hintStyle: TextStyle(
                                height: 0,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                                width: 0.5, color: kBackgroundColor))),
                    child: Center(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: RichText(
                              text: TextSpan(
                                  style: TextStyle(fontSize: 13, color: Colors.black),
                                  children: [
                                    TextSpan(
                                        text: 'kgun38@gmail.com님은 이번 모임에서 '),
                                    TextSpan(
                                      text: '하얀 여우',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600
                                      ),
                                    ),
                                    TextSpan(text: ' 로 활동합니다.')
                                  ]),
                            ),
                          ),
                          Text('글 작성 시 모임 대화방이 생성되며,\n신청자는 대화방에 참여됩니다.',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 11, color: kAccentColor))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BottomButton(onTap: () {}, buttonTitle: '등록하기', disabled: true,)
        ],
      ),
    );
  }
}
