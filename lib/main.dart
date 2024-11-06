import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/cardState.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/changeNotifiers/screenGeometryState.dart';
import 'package:front_survey_questions/screens/mainScreen.dart';
import 'package:front_survey_questions/screens/welcomeScreen.dart';
import 'package:front_survey_questions/services/firestoreService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';

Future<void> main() async {
  void initializeLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeLogging();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => CardState()),
      ChangeNotifierProvider(create: (context) => ScreenGeometryState()),
      ChangeNotifierProvider(create: (context) => QuestionsProvider()),
      ProxyProvider<QuestionsProvider, FirestoreService>(
        update: (context, questionsProvider, firestoreService) => FirestoreService(questions: questionsProvider),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    CardState card = Provider.of<CardState>(context);

    return MaterialApp(
      title: 'Survey',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFADD1FF)),
        useMaterial3: true,
        fontFamily: 'Nunito',
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: WelcomeScreen(),
      ),
    );
  }
}
