import 'package:just_audio/just_audio.dart';
import 'package:youreyes_frontend/translation/model/model.dart';

class TranslationService{
  
  String convert(Translation translation){

    String audioName = '';
    translation.audioMap.forEach((k,v) => {
      if(translation.text == k){
        audioName = v
      }else{
        print('[INFO] Audio not found for the text.')
      }

    });
    return audioName;
    
  }

  void playAudio(AudioPlayer player,Translation translation){
    String audioName = convert(translation);
    print('Audio nameeee: $audioName');
    player.setAsset(audioName);
    player.play();
  }
}