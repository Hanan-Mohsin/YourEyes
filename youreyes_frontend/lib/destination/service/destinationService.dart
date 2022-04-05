import 'dart:convert';

import 'package:youreyes_frontend/api/service/service.dart';
import 'package:youreyes_frontend/destination/model/model.dart';
import 'package:youreyes_frontend/userLocation/model/userLocation.dart';
import 'package:youreyes_frontend/userLocation/service/service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;


class DestinationService{

  final http.Client httpClient = http.Client();
  APIService _apiService = APIService();

  Future<Map<String,dynamic>> getDestination(String query) async{
      UserLocationService _userLocationService = UserLocationService();
      UserLocation _userLocation = await _userLocationService.getCurrentLocation(); 
      List<Address> _addresses = await Geocoder.local.findAddressesFromQuery(query);
      Address _address = _addresses.first;
      print("Total Distance from geolocator: ${Geolocator.distanceBetween(_userLocation.latitude, _userLocation.longitude, _address.coordinates.latitude, _address.coordinates.longitude)}");
      print("Country: ${_address.countryName} , Feature name: ${_address.featureName} , Coordinates: ${_address.coordinates}");
      Map<String,double> destination = {"latitude":_address.coordinates.latitude,"longitude":_address.coordinates.longitude};
      return {"destination":Destination(destination: destination,userLocation: _userLocation),"address": _address};

    
      
  }

  Future<List<dynamic>> getRoute(Destination destination,Address address) async{
    Map<String,dynamic> route = await _apiService.sendDestination(destination);
    
    List<dynamic> _steps = [];
    int stepLength;
    var _firstDistance;
    _steps = route['routes'][0]['segments'][0]["steps"] as List;
    _firstDistance = route['routes'][0]['summary']["distance"];
    stepLength = _steps.length;
    _steps[stepLength -1]['maneuver']['location'] = [address.coordinates.longitude,address.coordinates.latitude];
    print("Length: $stepLength");
    print("Total distance from route: $_firstDistance");

     
    
    return _steps;
  }

}
 // For the first page
//1. getDestination
//2. getRoute
//3. getInstruction
