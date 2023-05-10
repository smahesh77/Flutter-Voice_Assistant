import 'package:flutter/material.dart';
import 'package:voice_assistant/speechScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech to Text',
      theme: ThemeData(
       
        primarySwatch: Colors.blue,
      ),
      home: SpeechScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
