import 'dart:async';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youreyes_frontend/destination/service/service.dart';
import 'package:youreyes_frontend/image/service/imageService.dart';
import 'package:youreyes_frontend/instruction/model/model.dart';
import 'package:youreyes_frontend/instruction/service/service.dart';


// A screen that allows users to take a picture using a given camera.
class TakePicturePage extends StatefulWidget {
  const TakePicturePage({
    Key? key,
    required this.instructions,
    required this.camera,
    required this.player
  }) : super(key: key);

  final CameraDescription camera;
  final List<Instruction> instructions;
  final AudioPlayer player;
  @override
  TakePicturePageState createState() => TakePicturePageState();
}

class TakePicturePageState extends State<TakePicturePage> with WidgetsBindingObserver{
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool done = false;
  late Timer _timer;
  late Timer _timer2;
  Map<String,double> _currentPosition = {};

  DestinationService _destinationService = DestinationService();
  InstructionService _instructionService = InstructionService();
  List<Instruction> _instructions = [];
  late AudioPlayer player;
  ImageService _imageService = ImageService();
  bool isDone = true;
  int instLength = 0;
 
 

  @override
  void initState() {
   
   
   //  WidgetsFlutterBinding.ensureInitialized();
     WidgetsBinding.instance!.addObserver(this);
    
      //_listenChange();
    
    // To display the current output from the Camera,
    // create a CameraController.
    player = AudioPlayer();
 
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );
    _initializeControllerFuture = _controller.initialize();
      if(widget.instructions.length != 0){
       setState(() {
         instLength = widget.instructions.length;
         _instructions = widget.instructions;
       });
       for(Instruction instruction in _instructions){
        print(instruction.instruction);
        print(instruction.checkpoint);
        print(instruction.distance);
       }
      
      }
      if(_instructions.length == instLength){
        _listenChange();
      }
     super.initState();
     
     
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _timer.cancel();
   // _timer2.cancel();
    _controller.dispose();
    player.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

 

  // void _listenChange() async{
  //    if(_instructions.length > 0){
  //     Geolocator.getPositionStream().listen((position) {
  //     if(mounted){
         
          
  //         _instructionService.deliverInstruction(_instructions, position, widget.player,instLength).then((inst){
  //           setState(() {
  //             _instructions = inst;
  //           });
  //         });
        
  //     }
        
  //     //  print("Position changed: $position");
  //     });
  //    }
  // }

   void _listenChange(){
     print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
     if(_instructions.length > 0){
      if(mounted){
         
          setState(() {
            _currentPosition['latitude'] = _instructions[0].checkpoint['latitude'];
            _currentPosition['longitude'] = _instructions[0].checkpoint['longitude'];
          });
          _instructionService.deliverInstruction(_instructions, _currentPosition, widget.player,instLength).then((inst){
            setState(() {
              _instructions = inst;
            });
          });
        
      }
 
     }
  }

  @override
  Widget build(BuildContext context) {
    if(mounted){
     
         _timer = Timer(Duration(seconds: 10),() {
        if(mounted&isDone){
          setState(() {
            isDone = false;
          });
        _imageService.takePicture(_controller, _initializeControllerFuture, player).then((value){setState(() {
          isDone = value;
          // if(isDone){
          //   //direction method is called
          // }
          
        });});
        }
    });

    //  _timer2 = Timer(Duration(seconds:40),() {
    //    if(mounted){
    //       _listenChange();
    //    }
       
        
    // });
      
      
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            done = true;
           // print("Camera mounted");
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
         
        },
      ),
      // floatingActionButton: FloatingActionButton(
      //   // Provide an onPressed callback.
      //   onPressed: () async {
      //     // Take the Picture in a try / catch block. If anything goes wrong,
      //     // catch the error.
      //     try {
      //       // Ensure that the camera is initialized.
      //       await _initializeControllerFuture;

      //       // Attempt to take a picture and get the file `image`
      //       // where it was saved.
      //       print("TAKING PICTURE");
      //       final image = await _controller.takePicture();
      //       print("IMAGE PATH: ${image.path}");
      //       // If the picture was taken, display it on a new screen.
      //       // await Navigator.of(context).push(
      //       //   MaterialPageRoute(
      //       //     builder: (context) => DisplayPictureScreen(
      //       //       // Pass the automatically generated path to
      //       //       // the DisplayPictureScreen widget.
      //       //       imagePath: image.path,
      //       //     ),
      //       //   ),
      //       // );
      //     } catch (e) {
      //       // If an error occurs, log the error to the console.
      //       print(e);
      //     }
      //   },
      //   child: const Icon(Icons.camera_alt),
      // ),
    );
  }
}

