import 'package:just_audio/just_audio.dart';
import 'package:youreyes_frontend/translation/model/model.dart';

class TranslationService{
  
  String convert(Translation translation){

    String audioName = '';
    print('translation text: ${translation.text}');
    translation.audioMap.forEach((k,v) => {
      if(translation.text.contains(k)){
        audioName = v
      }


    });
    if(audioName == ''){
        print('[INFO] Audio not found for the text.');
      }
    return audioName;
    
  }

  Future playAudio(AudioPlayer player,Translation translation)async{
    String audioName = convert(translation);
    print('Audio nameeee: $audioName');
     print('gonna play');
    await player.setAsset(audioName);
   
    await player.play();
  }
}