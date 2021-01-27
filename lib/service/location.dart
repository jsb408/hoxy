import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static Placemark currentAddress;

  static Future<bool> getCurrentLocation() async {
    try {
      if(!await Geolocator.isLocationServiceEnabled()) throw Exception();

      LocationPermission permission = await Geolocator.checkPermission();

      switch(permission) {
        case LocationPermission.deniedForever:
          throw Exception();
          break;
        default:
          permission = await Geolocator.requestPermission();
          if (permission != LocationPermission.whileInUse && permission != LocationPermission.always)
            throw Exception();
      }

      Position position = await Geolocator.getCurrentPosition();
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude, localeIdentifier: 'ko_KR');
      currentAddress = placemarks.first;
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}