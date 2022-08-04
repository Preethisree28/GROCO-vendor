
import 'package:flutter/cupertino.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier{
  double? shopLatitude;
  double? shopLongitude;
  String? shopAddress;
  String? placeName;
  Future getCurrentAddress()async{
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    shopLatitude = _locationData.latitude;
    shopLongitude = _locationData.longitude;
    notifyListeners();

    final coordinates = Coordinates(_locationData.latitude, _locationData.longitude);
    final _addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var shopAddress = _addresses.first;
    this.shopAddress = shopAddress.addressLine;
    placeName = shopAddress.featureName;
    notifyListeners();
    return shopAddress;

  }





}