import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:get/get.dart';
import 'package:hoxy/screen/join_detail_screen.dart';
import 'package:hoxy/screen/location_screen.dart';
import 'package:hoxy/screen/login_screen.dart';
import 'constants.dart';

Future<void> _messageHandler(RemoteMessage message) async {
  print('background message ${message.data['content']}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterNotificationChannel.registerNotificationChannel(
    id: "chatting",
    name: "채팅",
    description: "채팅 메시지가 왔을 때 울리는 알림",
    importance: NotificationImportance.IMPORTANCE_HIGH,
  );
  await FlutterNotificationChannel.registerNotificationChannel(
    id: "alert",
    name: "모임",
    description: "모임 관련 알림",
    importance: NotificationImportance.IMPORTANCE_HIGH,
  );

  FirebaseMessaging.onBackgroundMessage(_messageHandler);
  runApp(Hoxy(firstScreen: await autoLogin()));
  configLoading();
}

void configLoading() {
  EasyLoading.instance
      ..userInteractions = false;
}

Future<StatelessWidget> autoLogin() async {
  if (kAuth.currentUser != null) { //로그인 되어있으면
    QuerySnapshot member = await kFirestore.collection('member').where('uid', isEqualTo: kAuth.currentUser!.uid).get();
    //detail이 입력되어 있으면 ? LocationScreen() : JoinDetailScreen()
    return member.docs.isNotEmpty ? LocationScreen() : JoinDetailScreen();
  } else return LoginScreen();
}

class Hoxy extends StatelessWidget {
  Hoxy({required this.firstScreen});

  final StatelessWidget firstScreen;

  @override
  Widget build(BuildContext context) {
    kMessaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        criticalAlert: true,
        sound: true
    );

    kMessaging.getToken().then((value) {
      print(value);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("message recieved: ${event.data['content']}");
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print('Message Clicked!');
    });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Theme.of(context).copyWith(
        floatingActionButtonTheme: Theme.of(context).floatingActionButtonTheme.copyWith(
          backgroundColor: kPrimaryColor
        ),
        appBarTheme: Theme.of(context).appBarTheme.copyWith(
          iconTheme: IconThemeData().copyWith(
            color: Colors.black
          ),
          textTheme: TextTheme().copyWith(
            headline6: TextStyle(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
        ),
        primaryColor: kPrimaryColor,
        scaffoldBackgroundColor: kBackgroundColor,
        textTheme: Theme.of(context).textTheme.copyWith(
          bodyText2: Theme.of(context).textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w300
          )
        )
      ),
      home: firstScreen,
      builder: EasyLoading.init(),
    );
  }
}
