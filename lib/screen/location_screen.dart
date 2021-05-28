import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hoxy/constants.dart';
import 'package:hoxy/screen/main_screen.dart';
import 'package:hoxy/service/loading.dart';
import 'package:hoxy/service/location_service.dart';
import 'package:hoxy/view/background_button.dart';

class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: LocationService.getCurrentLocation(),
      builder: (context, snapshot) {
        print(snapshot.connectionState);
        if (snapshot.connectionState == ConnectionState.done) {
          if (LocationService.currentAddress == null) {
            return Center(
              child: BackgroundButton(
                title: '권한설정',
                onPressed: () async {
                  Loading.show();

                  if (!await LocationService.getCurrentLocation()) {
                    Loading.showError('권한을 설정해주세요');
                    Geolocator.openAppSettings();
                    return;
                  }

                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                  Loading.dismiss();
                },
              ),
            );
          } else {
            return MainScreen();
          }
        } else
          return Container(
            color: kBackgroundColor,
            child: Center(child:CircularProgressIndicator()),
          );
      },
    );
  }
}
