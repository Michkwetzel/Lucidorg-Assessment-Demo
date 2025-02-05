import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/surveyDataProvider.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/changeNotifiers/radioButtonsState.dart';
import 'package:front_survey_questions/changeNotifiers/ratingBarState.dart';
import 'package:front_survey_questions/exceptions.dart';
import 'package:front_survey_questions/screens/errorScreen.dart';
import 'package:front_survey_questions/screens/finalScreen.dart';
import 'package:front_survey_questions/screens/welcomeScreen.dart';
import 'package:front_survey_questions/services/firestoreService.dart';
import 'package:front_survey_questions/services/googleFunctionService.dart';
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

    final uri = Uri.parse(html.window.location.href);

    surveyToken = uri.queryParameters['token1'];
    companyUID = uri.queryParameters['token2'];

    surveyToken = '1u9fslM08q7O5DCleGct';
    companyUID = 'testCompany';

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
        ChangeNotifierProvider(create: (context) => SurveyDataProvider()),
        Provider<FirestoreService>(
          create: (context) {
            final questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
            return FirestoreService(questions: questionsProvider, surveyToken: surveyToken, companyUID: companyUID);
          },
          lazy: false,
        ),
        Provider<GoogleFunctionService>(create: (context) {
          return GoogleFunctionService(surveyToken: surveyToken, companyUID: companyUID);
        })
      ],
      child: MyApp(),
    ));
  } on Exception catch (e) {
    if (e is SurveyException) {
      runApp(
        ErrorScreen(e.message),
      );
    } else {
      runApp(
        ErrorScreen("Error, Please try again later or refresh browser"),
      );
    }
  }
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
    );
  }
}
