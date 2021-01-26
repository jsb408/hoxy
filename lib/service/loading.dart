import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  static void show(String status) {
    EasyLoading.show(status: status);
  }
}