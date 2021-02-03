import 'package:flutter_easyloading/flutter_easyloading.dart';

class Loading {
  static show({String? status}) {
    EasyLoading.show(status: status);
  }

  static dismiss() {
    EasyLoading.dismiss();
  }

  static showSuccess(String status) {
    EasyLoading.showSuccess(status, dismissOnTap: true);
  }

  static showError(String status) {
    EasyLoading.showError(status, dismissOnTap: true);
  }
}