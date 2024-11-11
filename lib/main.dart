import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/changeNotifiers/radioButtonsState.dart';
import 'package:front_survey_questions/changeNotifiers/ratingBarState.dart';
import 'package:front_survey_questions/helperClasses/results.dart';
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
      Provider<Results>(create: (context) => Results()),
      // Use ChangeNotifierProxyProvider because QuestionsProvider is ChangeNotifer
      ChangeNotifierProxyProvider<Results, QuestionsProvider>(
        create: (context) => QuestionsProvider(context.read<Results>()),
        update: (context, results, previousQuestionsProvider) {
          // on Results update. update QuestionProviders results
          if (previousQuestionsProvider == null) {
            return QuestionsProvider(results);
          }
          previousQuestionsProvider.updateResults(results);
          return previousQuestionsProvider;
        },
      ),
      ChangeNotifierProvider(create: (context) => RadioButtonState()),
      ChangeNotifierProvider(create: (context) => Ratingbarstate()),
      // User ProxyProvider because Firestore is service class but depends on ChangeNotifer QuestionsProvider
      Provider<FirestoreService>(
        create: (context) {
          final questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
          return FirestoreService(questions: questionsProvider);
        },
        lazy: true,
      )
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Survey',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFADD1FF)),
        useMaterial3: true,
        fontFamily: 'Nunito',
      ),
      home: WelcomeScreen(),
    );
  }
}
