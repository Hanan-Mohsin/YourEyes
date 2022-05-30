import 'dart:convert';
import 'dart:io';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:youreyes_frontend/destination/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:youreyes_frontend/direction/service/service.dart';
import 'package:youreyes_frontend/image/model/model.dart';
import 'package:youreyes_frontend/translation/model/translation.dart';
import 'package:youreyes_frontend/translation/service/translationService.dart';



class APIService{
  final http.Client httpClient = http.Client();
  //TranslationService _translationService = TranslationService();
  DirectionService _directionService = DirectionService();
  bool isPlaying = false;
  Future<Map<String,dynamic>>sendDestination(Destination destination)async{
    Map<String,dynamic> _route={};
    var apiKey = "5b3ce3597851110001cf6248f177b3f89dd449be9df8c76482496382";
    var body =  '{"coordinates":[[${destination.userLocation.longitude},${destination.userLocation.latitude}],[${destination.destination["longitude"]},${destination.destination["latitude"]}]],"instructions":"true","maneuvers":"true"}';
    var url = "https://api.openrouteservice.org/v2/directions/foot-walking";
    final response = await httpClient.post(
      Uri.parse(url),
      headers: <String, String>{
        'Accept': 'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
        'Authorization': apiKey,
        'Content-Type': 'application/json; charset=utf-8'
      },
      body: body,
    );
    print(response.statusCode);
   
    if (response.statusCode == 200) {
      _route = jsonDecode(response.body);
    }else{
      throw Exception('Failed to get route.');
    }
    return _route;
  }

  Future<bool> sendImage(Image image,AudioPlayer player)async{

    var imageFile = File(image.imagePath);
    print("clfjfldjfkljdlaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
      // open a bytestream
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://192.168.1.11:5000/image");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('image', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      
      // setState((){
      //   imageName = value;
      //   print("Image Name: $imageName");
        
        
      // });

        //print("Image Name: $value");
        Map result = json.decode(value);
        print("result: ${result['detections']}");
        _directionService.tellDirection(result['detections'], player).then((value) => null);
          // directon method is called here
          // Another option
        //  player.setAsset("assets/Background-1.mp3");
        //  player.play();

          //_translationService.playAudio(player, Translation(text: 'right'));
          // if(!isPlaying){
          //   isPlaying = true;
          //   _translationService.playAudio(player, Translation(text: 'trial'));
          // }else{
          //   if(player.processingState == ProcessingState.completed){
          //     _translationService.playAudio(player, Translation(text: 'trial'));
          //   }
          // }

        // }

        // if(player.playerState.playing){
        //   player.pause();
        //   player.setAsset("assets/Background-1.mp3");
        //   player.play();
          

        // }else{
        //   player.setAsset("assets/Background-1.mp3");
        //   player.play();
          
        // }
      
    });
    
    if(response.statusCode == 200){
      return true;
    }else{
      return false;
    }
     

  }
}

