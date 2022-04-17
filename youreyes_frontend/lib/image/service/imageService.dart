import 'package:camera/camera.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youreyes_frontend/api/service/service.dart';
import 'package:youreyes_frontend/image/model/model.dart';
import 'package:youreyes_frontend/translation/service/translationService.dart';

class ImageService{

  APIService _apiService = APIService();
  String imagePath = 'imagePath';

  Future<bool> takePicture(CameraController controller,Future<void> intializeCamera,AudioPlayer player) async{
    bool returned = false;
   // if(imagePath != ''){
   
     // imagePath = '';
      print("blaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
        
      try{
          await intializeCamera;
          print("TAKING PICTURE");
          final image = await controller.takePicture();
        
          print(image.path);
          
          imagePath = image.path;
          print("IMAGE PATH: $imagePath");        
         return true;
         // returned = await uploadImage(Image(imagePath: imagePath),player);
        
      }catch(e){
        print('erorrrrrrrrrrrrrrrrrrrrr$e');
        returned = false;
      }
      return returned;
    //}
  }

  Future uploadImage(Image image, AudioPlayer player) async{
    await _apiService.sendImage(image, player);
  }


  
}