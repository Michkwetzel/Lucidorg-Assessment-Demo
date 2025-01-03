import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/changeNotifiers/radioButtonsState.dart';
import 'package:front_survey_questions/changeNotifiers/ratingBarState.dart';
import 'package:front_survey_questions/screens/finalScreen.dart';
import 'package:front_survey_questions/screens/welcomeScreen.dart';
import 'package:front_survey_questions/services/firestoreService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart' as html; // Add this
import 'package:flutter_web_plugins/flutter_web_plugins.dart'; // Add this

Future<void> main() async {
  void initializeLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print('${record.level.name}: ${record.time}: ${record.message}');
    });
  }

  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  initializeLogging();

  final uri = Uri.parse(html.window.location.href);
  final surveyToken = uri.queryParameters['token'];

  runApp(MultiProvider(
    providers: [
      // Use ChangeNotifierProxyProvider because QuestionsProvider is ChangeNotifer
      ChangeNotifierProvider(create: (context) => RadioButtonState()),
      ChangeNotifierProvider(create: (context) => Ratingbarstate()),
      ChangeNotifierProvider(
        create: (context) => QuestionsProvider(
          radioButtonState: context.read<RadioButtonState>(),
          ratingBarState: context.read<Ratingbarstate>(),
        ),
      ),
      // User ProxyProvider because Firestore is service class but depends on ChangeNotifer QuestionsProvider
      Provider<FirestoreService>(
        create: (context) {
          final questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
          return FirestoreService(questions: questionsProvider, surveyToken: surveyToken);
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
      title: 'Effiency First',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFADD1FF)),
        useMaterial3: true,
        fontFamily: 'Nunito',
      ),
      home: WelcomeScreen(),
      routes: {'/finalscreen': (context) => const FinalScreen()},
    );
  }
}
