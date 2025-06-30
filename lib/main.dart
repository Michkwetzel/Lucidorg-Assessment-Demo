import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/changeNotifiers/radioButtonsState.dart';
import 'package:lucid_org/changeNotifiers/ratingBarState.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/screens/errorScreen.dart';
import 'package:lucid_org/screens/welcomeScreen.dart';
import 'package:lucid_org/services/firestoreService.dart';
import 'package:lucid_org/services/googleFunctionService.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';

Future<void> main() async {
  try {
    void initializeLogging() {
      Logger.root.level = Level.ALL;
      Logger.root.onRecord.listen((record) {
        print('${record.level.name}: ${record.loggerName}: ${record.time}: ${record.message}');
      });
    }

    WidgetsFlutterBinding.ensureInitialized();
    setUrlStrategy(PathUrlStrategy());

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    initializeLogging();
    String? surveyToken;
    String? companyUID;
    String? jobSearchUID;

    final uri = Uri.parse(html.window.location.href);

    surveyToken = uri.queryParameters['token1'];
    companyUID = uri.queryParameters['token2'];
    jobSearchUID = uri.queryParameters['token3'];

    surveyToken = 'sDpEZWVGf0NXD4de1jWe';
    companyUID = 'Xx49cPZF4glQdGJJVeRv';

    // surveyToken = 'test';
    // companyUID = 'test';

    if (surveyToken == null || companyUID == null) {
      throw MissingTokenException();
    }

    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RadioButtonState()),
        ChangeNotifierProvider(create: (context) => Ratingbarstate()),
        ChangeNotifierProvider(
          create: (context) => QuestionsProvider(
            radioButtonState: context.read<RadioButtonState>(),
            ratingBarState: context.read<Ratingbarstate>(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => SurveyDataProvider(surveyUID: surveyToken, companyUID: companyUID, jobSearchUID: jobSearchUID)),
        Provider<FirestoreService>(
          create: (context) {
            final questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
            final surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);
            return FirestoreService(questions: questionsProvider, surveyDataProvider: surveyDataProvider);
          },
          lazy: false,
        ),
        Provider<GoogleFunctionService>(create: (context) {
          final surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);
          return GoogleFunctionService(surveyDataProvider: surveyDataProvider);
        })
      ],
      child: MyApp(),
    ));
  } on Exception catch (e) {
    if (e is SurveyException) {
      runApp(
        MaterialApp(
          title: 'LucidORG',
          home: ErrorScreen(e.message),
        ),
      );
    } else {
      runApp(
        MaterialApp(
          title: 'LucidORG',
          home: ErrorScreen("Error, Please try again later or refresh browser"),
        ),
      );
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LucidORG',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFFADD1FF)),
        useMaterial3: true,
        fontFamily: 'Nunito',
      ),
      home: WelcomeScreen(),
    );
  }
}
