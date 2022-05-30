import 'package:just_audio/just_audio.dart';
import 'package:youreyes_frontend/direction/model/model.dart';
import 'package:youreyes_frontend/translation/model/model.dart';
import 'package:youreyes_frontend/translation/service/translationService.dart';

class DirectionService{
  TranslationService _tService = TranslationService();
  // void prepareDirecction(List<dynamic> detections){
  //   List<Direction> directions = [];
  //   directions.sort()
  //   for(var detection in detections){
  //     if(double.parse(detection['distance']) < 0.5){
  //       if(directions.isEmpty){
  //         if((double.parse(detection['BBoxes']['xmin'])> 0.3) & (double.parse(detection['BBoxes']['xmax']) <= 0.55)){
            
  //         }else if((double.parse(detection['BBoxes']['xmin'])> 0.55) & (double.parse(detection['BBoxes']['xmax']) < 0.7)){

  //         }
  //       }else{
          
  //       }
        
  //     }
  //   }
  // }
  Future<void> tellDirection(List<dynamic> detections, AudioPlayer player)async {
    String instruction='';
    String inst='';
    for(var detection in detections){
      if(double.parse(detection['distance']) <= 0.5){
        double xmid = (double.parse(detection['BBoxes']['xmax']) + double.parse(detection['BBoxes']['xmin']))/2;
         if((xmid > 0.3) & (xmid < 0.7)){
           if((xmid - 0.3).abs() < (xmid - 0.7).abs()){
             instruction = 'keep right';
              if(instruction != inst){
                await _tService.playAudio(player, Translation(text: instruction));
              }
             inst = 'keep right';
           }else if((xmid - 0.3).abs() > (xmid - 0.7).abs()){
                instruction = 'keep left';
                if(instruction != inst){
                  await _tService.playAudio(player, Translation(text: instruction));
                }
                inst = 'keep left';
           }
            
            
          }
          // else if((double.parse(detection['BBoxes']['xmin'])> 0.55) & (double.parse(detection['BBoxes']['xmax']) < 0.7)){
          //   instruction = 'keep left';
          //    if(instruction != inst){
          //     await _tService.playAudio(player, Translation(text: instruction));
          //   }
          //   inst = 'keep left';
          // }
      }
    }

  }
}
