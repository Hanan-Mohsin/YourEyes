
import 'package:geolocator/geolocator.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youreyes_frontend/instruction/model/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:youreyes_frontend/translation/model/translation.dart';
import 'package:youreyes_frontend/translation/service/translationService.dart';

class InstructionService{
  TranslationService _tService = TranslationService();
  List<Instruction> getInstruction(List<dynamic> steps){
    List<Instruction> instructions = [];
    for(var step in steps){
      instructions.add(Instruction(instruction: step["instruction"], 
       
      checkpoint: {"longitude":step['maneuver']["location"][0],"latitude":step['maneuver']["location"][1]},
      distance: step["distance"]));
    }
    return instructions;
    
  }

 
  // instructions and address will be passed from the previous pages

  Future<List<Instruction>> deliverInstruction(List<Instruction> instructions,Position currentPosition,AudioPlayer player,int instLength) async {
    
    if(instructions.length == instLength){
     print('Instruction to be delivered: ${instructions[0].instruction}');
     await _tService.playAudio(player, Translation(text: "turn right"));
      instructions.removeAt(0);  
   

   }
   if(instructions.length > 1){
      if((instructions[0].distance - Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, instructions[1].checkpoint['latitude'],instructions[1].checkpoint['longitude'])).abs() < 0.5){
       print(instructions[0].distance - Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, instructions[1].checkpoint['latitude'],instructions[1].checkpoint['longitude']));
        print(instructions[1].instruction);  //This is instruction is delivered
        //play(instructions[1].instruction,player);
        await _tService.playAudio(player, Translation(text: "turn right"));
        instructions.removeAt(0);    
    }
    
   }
   return instructions;
 
   }
  }
