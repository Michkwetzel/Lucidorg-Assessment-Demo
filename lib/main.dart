import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/cards.dart';
import 'package:front_survey_questions/changeNotifiers/screenGeometryState.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      title: 'Survey Questions',
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
