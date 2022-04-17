
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

 
  // Future<List<Instruction>> deliverInstruction(List<Instruction> instructions,Position currentPosition,AudioPlayer player,int instLength) async {
    
  //   if(instructions.length == instLength){
  //    print('Instruction to be delivered: ${instructions[0].instruction}');
  //    await _tService.playAudio(player, Translation(text: instructions[0].instruction));
  //     instructions.removeAt(0);  
   

  //  }
  //  if(instructions.length > 1){
  //     if((Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, instructions[0].checkpoint['latitude'],instructions[0].checkpoint['longitude'])).abs() < 0.05){
  //      print(instructions[0].distance - Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, instructions[1].checkpoint['latitude'],instructions[1].checkpoint['longitude']));
  //       print(instructions[0].instruction);  //This is instruction is delivered
  //       await _tService.playAudio(player, Translation(text: instructions[0].instruction));
  //       instructions.removeAt(0);    
  //   }
    
  //  }else{
  //    if((instructions[0].distance - Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, instructions[0].checkpoint['latitude'],instructions[0].checkpoint['longitude'])).abs() < 0.05){
  //      print(instructions[0].distance - Geolocator.distanceBetween(currentPosition.latitude, currentPosition.longitude, instructions[0].checkpoint['latitude'],instructions[0].checkpoint['longitude']));
  //       print(instructions[0].instruction);  //This is instruction is delivered
  //       await _tService.playAudio(player, Translation(text: instructions[1].instruction));
  //       instructions.removeAt(0);    
  //   }
  //  }
  //  return instructions;
 
  //  }
  

  // For mocking location

  Future<List<Instruction>> deliverInstruction(List<Instruction> instructions,Map<String,double> currentPosition,AudioPlayer player,int instLength) async {
    
    if(instructions.length == instLength){
     print('Instruction to be delivered: ${instructions[0].instruction}');
     await _tService.playAudio(player, Translation(text: instructions[0].instruction));
      instructions.removeAt(0);  
   

   }else{
     print(instructions.length);
      print((instructions[0].distance - Geolocator.distanceBetween(currentPosition['latitude'], currentPosition['longitude'], instructions[0].checkpoint['latitude'],instructions[0].checkpoint['longitude'])).abs());
      if((Geolocator.distanceBetween(currentPosition['latitude'], currentPosition['longitude'], instructions[0].checkpoint['latitude'],instructions[0].checkpoint['longitude'])).abs() < 0.5){
      
        print(instructions[0].instruction); 
        String inst = instructions[0].instruction; //This is instruction is delivered
        instructions.removeAt(0); 
        await _tService.playAudio(player, Translation(text: inst));
           
    }
    
   }
  //  else{
  //   if((instructions[0].distance - Geolocator.distanceBetween(currentPosition['latitude'], currentPosition['longitude'], instructions[0].checkpoint['latitude'],instructions[0].checkpoint['longitude'])).abs() < 0.5){
  //     print(instructions[0].instruction);  //This is instruction is delivered
  //     await _tService.playAudio(player, Translation(text: instructions[0].instruction));
  //     instructions.removeAt(0);  
  //  }
  // }
   return instructions;
 
   }
}
