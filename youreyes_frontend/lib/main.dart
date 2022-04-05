import 'package:flutter/material.dart';
import 'package:youreyes_frontend/destination/widget/widget.dart';
import 'package:wakelock/wakelock.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Wakelock.enable();
  runApp(DestinationInputPage());
}

