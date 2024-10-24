import 'package:flutter/material.dart';
import 'package:front_survey_questions/screens/mainScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey Questaniare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
        fontFamily: 'Nunito'
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: mainScreen(),
      ),
    );
  }
}
