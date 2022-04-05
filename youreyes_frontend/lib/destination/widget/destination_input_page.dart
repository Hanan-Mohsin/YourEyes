import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
    
    setState(() {});
  }

 
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
     
      
    if(_lastWords !=''){
      print(_lastWords);
      await _getDestination("Addis Ababa Institute of Technology");
      
     
    }
  }
    
    
    
  

  void _onSpeechResult(SpeechRecognitionResult result)async{
    setState(() {
      _lastWords = result.recognizedWords;
      
    });
    
       _stopListening();
    
    // print(_lastWords);
    //  await  _getDestination("Addis Ababa Institute of Technology");
    //   final cameras = await availableCameras();
    //   final firstCamera = cameras.first;
    //   // Get a specific camera from the list of available cameras.
    //   navigatorKey.currentState!.pop();
    //    navigatorKey.currentState!.push(
    //     MaterialPageRoute(
    //       builder: (context) => TakePicturePage(instructions: _instructions, camera: firstCamera)
    //     ),
    //   );
  
  
  }

  Future _getDestination(String query) async{
    Map<String,dynamic> result = await _destinationService.getDestination(query);
    List<dynamic> _steps = await _destinationService.getRoute(result["destination"],result["address"]);
    
     setState(() {
        _instructions = _instructionService.getInstruction(_steps);
      
     });
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      // Get a specific camera from the list of available cameras.
       navigatorKey.currentState!.pop();
       await navigatorKey.currentState!.push(
        MaterialPageRoute(
          builder: (context) => TakePicturePage(instructions: _instructions, camera: firstCamera)
        ),
      );
    
  }



  @override
  Widget build(BuildContext context) {
  
    return MaterialApp(
      navigatorKey: navigatorKey,
      home:Scaffold(
        body: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed:
                      // If not yet listening for speech start, otherwise stop
                    _speechToText.isNotListening ? _startListening : _stopListening,
                    tooltip: 'Listen',
                    child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
                 ),

                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    onPressed: ()async{
                      //sawait getDestination('Afarensis International Hotel');
                    }, 
                    child: Text('settt')),
                     SizedBox(
                    height: 10,
                  ),

                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      _speechToText.isListening
                          ? '$_lastWords'
                        
                          : _speechEnabled
                              ? (_lastWords == '' ? 'Tap the microphone to start listening...':'$_lastWords')
                              : 'Speech not available',
                    ),
                  ),
              ]
            ),
          )
        )
      )
    );
    
  }


}