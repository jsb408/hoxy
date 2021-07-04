import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hoxy/model/alert.dart';
import 'package:hoxy/view/item_alert_list.dart';
import 'package:hoxy/viewmodel/alert_list_view_model.dart';

class AlertListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AlertListViewModel>(
        init: AlertListViewModel(),
        builder: (_viewModel) => Scaffold(
              appBar: AppBar(
                title: Text('알림'),
                automaticallyImplyLeading: false,
              ),
              body: _viewModel.alertList.isEmpty
                  ? Center(child: Text('알림이 없습니다'))
                  : ListView(
                children: [
                  for (Alert alert in _viewModel.alertList)
                    ItemAlertList(alert: alert)
                ],
              ),
        ),
    );
  }
}
