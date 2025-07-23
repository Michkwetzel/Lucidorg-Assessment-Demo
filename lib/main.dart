import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/changeNotifiers/radioButtonsState.dart';
import 'package:lucid_org/changeNotifiers/ratingBarState.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/screens/errorScreen.dart';
import 'package:lucid_org/screens/welcomeScreen.dart';
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
    String? orgId;
    String? assessmentId;
    String? docId;

    final uri = Uri.parse(html.window.location.href);

    orgId = uri.queryParameters['orgId'];
    assessmentId = uri.queryParameters['assessmentId'];
    docId = uri.queryParameters['docId'];

    orgId = 'test';
    assessmentId = 'test';
    docId = 'test';

    // surveyToken = 'test';
    // companyUID = 'test';

    if (orgId == null || assessmentId == null || docId == null) {
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
        ChangeNotifierProvider(create: (context) => SurveyDataProvider(orgId: orgId, assessmentID: assessmentId, docId: docId, googleFunctionService: Provider.of<GoogleFunctionService>(context, listen: false))),
        Provider<GoogleFunctionService>(create: (context) {
          final surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);
          return GoogleFunctionService(surveyDataProvider: surveyDataProvider, questionsProvider: Provider.of<QuestionsProvider>(context, listen: false));
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
