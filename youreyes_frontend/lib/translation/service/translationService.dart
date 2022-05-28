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


   String mapAudio(Translation translation){
    String text = translation.text.toLowerCase();
    String translationText = '';
    if(text.contains('turn')){
      if(text.contains('right')){
        translationText = 'turn right';
      }else if(text.contains('left')){
        translationText = 'turn left';
      }
    }else if(text.contains('keep')){
      if(text.contains('right')){
        translationText = 'keep right';
      }else if(text.contains('left')){
        translationText = 'keep left';
      }
    }
    else if(text.contains('arrive')){
      if(text.contains('right')){
        translationText = 'arrived right';
      }else if(text.contains('left')){
        translationText = 'arrived left';
      }
    }
    else if(text.contains('roundabout')){
      if(text.contains('1st')){
        translationText = 'roundabout 1st';
      }else if(text.contains('2nd')){
        translationText = 'roundabout 2nd';
      }
      else if(text.contains('3rd')){
        translationText = 'roundabout 3rd';
      }
      else if(text.contains('4th')){
        translationText = 'roundabout 4th';
      }
    }else if(text.contains('northwest')){
        translationText = 'northwest';

    }else if(text.contains('southwest')){
       translationText = 'southwest';
    }else if(text.contains('continue')){
      translationText = 'continue';
    }else{
       translationText = 'continue';
    }
    return translationText;
  }

  Future playAudio(AudioPlayer player,Translation translation)async{
    String directionName = mapAudio(translation);
    Translation trans = Translation(text: directionName);
    String audioName = convert(trans);

    print('Audio nameeee: $audioName');
     print('gonna play');
    await player.setAsset(audioName);
   
    await player.play();
  }
}
