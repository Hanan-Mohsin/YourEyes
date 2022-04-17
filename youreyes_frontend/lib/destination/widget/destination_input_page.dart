import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youreyes_frontend/destination/model/model.dart';
import 'package:youreyes_frontend/destination/service/service.dart';
import 'package:youreyes_frontend/image/widget/TakePicturePage.dart';
import 'package:youreyes_frontend/instruction/model/model.dart';
import 'package:youreyes_frontend/instruction/service/service.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class DestinationInputPage extends StatefulWidget{
  
  @override
  State<StatefulWidget> createState() => _DestinationInputPageState();


}

class _DestinationInputPageState extends State<DestinationInputPage>{

  final navigatorKey = GlobalKey<NavigatorState>();
  DestinationService _destinationService = DestinationService();
  InstructionService _instructionService = InstructionService();
  List<Instruction> _instructions = [];
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  bool stopped = false;
  AudioPlayer player = AudioPlayer();
   @override
  void initState() {

    
    _initSpeech();

   
    super.initState();
  }

  void _initSpeech() async {
    
    _speechEnabled = await _speechToText.initialize();
    print("Intializing");
    print(_speechEnabled);
    setState(() {});
   
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    
    setState(() {
      stopped = false;
      isListening = true;
    });
  }

 
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
    
    if(!stopped){  
      if(_lastWords !=''){
        print('fkjkfjkfjkfjkfjkf');
        print(_lastWords);
        setState(() {
          stopped = true;
        });
        await _getDestination(_lastWords);
             
      }
    }
    setState(() {});
    
    
  }
    
    
    

  void _onSpeechResult(SpeechRecognitionResult result)async{
    setState(() {
      _lastWords = result.recognizedWords;
      
    });
    
      _stopListening();

    
  
  
  }

  Future _playAudio(String pathToAudio)async{
   
   
    await player.setAsset(pathToAudio);
    player.play();
   
  }

  Future _getDestination(String query) async{
    if(query != ''){
    Map<String,dynamic> result = await _destinationService.getDestination(query);
    List<dynamic> _steps = await _destinationService.getRoute(result["destination"],result["address"]);
     setState(() {
        _instructions = _instructionService.getInstruction(_steps);
      
     });
    }
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      // Get a specific camera from the list of available cameras.

       navigatorKey.currentState!.pop();

      
       await navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => TakePicturePage(instructions: _instructions, camera: firstCamera, player: player)
        ),
      );
       
    
  }



  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      navigatorKey: navigatorKey,
      home:Scaffold(
        body: Container(
          
          width:MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
         // child: Center(
            child: ListView(
             // mainAxisSize: MainAxisSize.max,
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                 ElevatedButton(

                  onPressed:
                      // If not yet listening for speech start, otherwise stop

                    _speechToText.isNotListening ? _startListening : _stopListening,
                  //  tooltip: 'Listen',
                    child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic, size:90),

                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width,(MediaQuery.of(context).size.height/2) - 5)
                    )
                 ),
                  
                  

                  SizedBox(
                    height: 10,
                    child: Container(
                  
                    child: Text(
                      _speechToText.isListening
                          ? '$_lastWords'
                        
                          : _speechEnabled
                              ? (_lastWords == '' ? 'Tap the microphone to start listening...':'$_lastWords')
                              : 'Speech not available',
                    ),
                  ),
                  ),
                ElevatedButton(
                    onPressed: ()async{
                      await _getDestination('');
                       //await _playAudio('assets/Voice 004.mp3');
                    }, 
                    child: Text('Skip',style: TextStyle(fontSize:46)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(MediaQuery.of(context).size.width,(MediaQuery.of(context).size.height/2)-5)
                    )
                    ),
                    
                     
                  
                 
              //     Container(
              //       padding: EdgeInsets.all(16),
              //       child: Text(
              //         _speechToText.isListening
              //             ? '$_lastWords'
                        
              //             : _speechEnabled
              //                 ? (_lastWords == '' ? 'Tap the microphone to start listening...':'$_lastWords')
              //                 : 'Speech not available',
              //       ),
              //     ),
               ]
            ),
         // )
        )
      )
    );
    
  }


}