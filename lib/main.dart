import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/cards.dart';
import 'package:front_survey_questions/changeNotifiers/screenGeometryState.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => Cards()),
      ChangeNotifierProvider(create: (context) => ScreenGeometryState()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Cards card = Provider.of<Cards>(context);

    return MaterialApp(
      title: 'Survey Questaniare',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFADD1FF)),
        useMaterial3: true,
        fontFamily: 'Nunito',
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Align(
          alignment: Alignment.topCenter,
          child: card.currentCard(),
        ),
      ),
    );
  }
}
