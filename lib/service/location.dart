import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static Placemark currentAddress;

  static Future<bool> getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) throw Exception('Location Service in disabled.');

      /*LocationPermission permission = await Geolocator.checkPermission();

      switch (permission) {
        case LocationPermission.deniedForever:
          throw Exception('Location Permission is denied forever.');
          break;
        default:
          permission = await Geolocator.requestPermission();
          if (permission != LocationPermission.whileInUse && permission != LocationPermission.always)
            throw Exception('Location Permission is denied. (actual value: $permission)');
      }*/

      if (!await Permission.location.request().isGranted) throw Exception('Location Permission is denied');

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: 'ko_KR');
      currentAddress = placemarks.first;
      print(currentAddress);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
