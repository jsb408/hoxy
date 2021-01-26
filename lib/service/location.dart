import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class Location {
  double latitude;
  double longitude;

  Future<Address> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition();
      latitude = position.latitude;
      longitude = position.longitude;

      final address = await Geocoder.local.findAddressesFromCoordinates(Coordinates(latitude, longitude));
      return address.first;
    } catch (e) {
      print(e);
    }
    return null;
  }
}