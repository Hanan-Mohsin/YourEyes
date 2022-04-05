import 'package:geolocator/geolocator.dart';
import 'package:youreyes_frontend/userLocation/model/model.dart';

class UserLocationService{
    Future<UserLocation> getCurrentLocation() async{
      late Position _currentLocation;
      LocationPermission permission = await Geolocator.checkPermission();
      if(permission == LocationPermission.denied){
        permission = await Geolocator.requestPermission();
        if(permission == LocationPermission.denied){
          print("Location permission is denied once");
        }
        if(permission == LocationPermission.deniedForever){
          print("Location is denied forever");
        }
      }
      
        await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best).then((Position position){
              _currentLocation = position;
              print("{Longitude: ${_currentLocation.longitude} : Latitude: ${_currentLocation.latitude}");
              
          
          }).catchError((e){
            print(e);
            return null;
          });
        return UserLocation(longitude: _currentLocation.longitude, latitude: _currentLocation.latitude);
    }

  //   void listenChange(Position currentPosition) {
  //      Geolocator.getPositionStream().listen((position) {
        
  //     //  print("Position changed: $position");
  //     });
  // }
}