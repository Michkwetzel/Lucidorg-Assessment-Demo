import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/changeNotifiers/radioButtonsState.dart';
import 'package:lucid_org/changeNotifiers/welcome_screen_provider.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/screens/errorScreen.dart';
import 'package:lucid_org/screens/welcomeScreen.dart';
import 'package:lucid_org/services/firestoreService.dart';
import 'package:lucid_org/services/authService.dart';
import 'package:lucid_org/utils/app_logger.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:logging/logging.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

Future<void> main() async {
  try {
    final logger = AppLogger.getLogger('Main');

    WidgetsFlutterBinding.ensureInitialized();
    setUrlStrategy(PathUrlStrategy());

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    AppLogger.initialize();
    Firestoreservice.initialize();
    String? orgId;
    String? assessmentId;
    String? docId;

    final uri = Uri.parse(html.window.location.href);
    // final token = uri.queryParameters['token'];
    // Token Example:
    // final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmdJZCI6IkVIbG9oWlVIZjRXN0RiZHllTTMxIiwiYXNzZXNzbWVudElkIjoiUVMzSmNmMks1QXNOd2xvd2VWbzciLCJkb2NJZCI6ImxBMFhWbTNpaTNXWGs4a1NVM2dVIiwiZXhwIjoxNzYwMTk1MTQzLCJpYXQiOjE3NTkzMzExNDN9.E__KR5O0vmBKwGz8O5W-rryGVOCEMiDHGFz8TUsjq_M";

    // if (token == null) {
    //   throw MissingTokenException();
    // }

    try {
      // Check if token is expired
      // if (JwtDecoder.isExpired(token)) {
      //   throw InvalidSurveyTokenException();
      // }

      // final decodedToken = JwtDecoder.decode(token);
      // orgId = decodedToken['orgId'] as String?;
      // assessmentId = decodedToken['assessmentId'] as String?;
      // docId = decodedToken['docId'] as String?;

      orgId = 'test';
      assessmentId = 'test';
      docId = 'test';

      logger.info('Initializing with orgId: $orgId, assessmentId: $assessmentId, docId: $docId');

      if (orgId == null || orgId.isEmpty ||
          assessmentId == null || assessmentId.isEmpty ||
          docId == null || docId.isEmpty) {
        throw InvalidSurveyTokenException();
      }

      // Store the JWT token in AuthService for API requests after validation
      //AuthService.setJwtToken(token);
    } on FormatException {
      throw InvalidSurveyTokenException();
    } catch (e) {
      if (e is InvalidSurveyTokenException) {
        rethrow;
      }
      throw MissingTokenException();
    }

    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RadioButtonState()),
        ChangeNotifierProvider(
          create: (context) => QuestionsProvider(
            radioButtonState: context.read<RadioButtonState>(),
          ),
        ),
        ChangeNotifierProvider(create: (context) => SurveyDataProvider(orgId: orgId, assessmentID: assessmentId, docId: docId)),
        ChangeNotifierProvider(create: (context) => WelcomeScreenProvider()),
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
