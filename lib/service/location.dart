import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class LocationService {
  static Placemark currentAddress;
  static get townName => currentAddress == null ? '범일동' : currentAddress.subLocality;

  static Future<bool> getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled())
        throw Exception('Location Service in disabled.');

      Platform.isIOS ? checkIOSPermission() : checkPermission();

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude,
          localeIdentifier: 'ko_KR');
      currentAddress = placemarks.first;
      print(currentAddress);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static checkIOSPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    switch (permission) {
      case LocationPermission.deniedForever:
        throw Exception('Location Permission is denied forever.');
        break;
      default:
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse && permission != LocationPermission.always)
          throw Exception(
              'Location Permission is denied. (actual value: $permission)');
    }
  }

  static checkPermission() async {
    if (!await Permission.location.request().isGranted) throw Exception('Location Permission is denied');
  }
}
