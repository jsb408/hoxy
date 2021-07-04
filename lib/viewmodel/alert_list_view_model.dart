import 'package:get/get.dart';
import 'package:hoxy/model/alert.dart';
import 'package:hoxy/service/loading.dart';

import '../constants.dart';

class AlertListViewModel extends GetxController {
  List<Alert> alertList = [].cast<Alert>();
  
  @override
  void onInit() {
    super.onInit();
    
    Loading.show();
    kFirestore
      .collection('alert')
      .where('uid', isEqualTo: kAuth.currentUser?.uid)
      .snapshots()
      .listen((event) {
        alertList = event.docs.map((e) => Alert.from(e)).toList();
        alertList.sort((a, b) => (b.date).compareTo(a.date));
        Loading.dismiss();
        update();
    });
  }
}