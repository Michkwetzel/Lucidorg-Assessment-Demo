import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/changeNotifiers/radioButtonsState.dart';
import 'package:lucid_org/changeNotifiers/ratingBarState.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/screens/errorScreen.dart';
import 'package:lucid_org/screens/welcomeScreen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
    final token = uri.queryParameters['token'];

    if (token == null) {
      throw MissingTokenException();
    }

    try {
      final decodedToken = JwtDecoder.decode(token);
      orgId = decodedToken['orgId'];
      assessmentId = decodedToken['assessmentId'];
      docId = decodedToken['docId'];

      if (orgId == null || assessmentId == null || docId == null) {
        throw MissingTokenException();
      }
    } catch (e) {
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
        ChangeNotifierProvider(create: (context) => SurveyDataProvider(orgId: orgId, assessmentID: assessmentId, docId: docId)),
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
