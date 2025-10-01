import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/components/custonButtons/custom_start_button.dart';
import 'package:lucid_org/constants.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/screens/errorScreen.dart';
import 'package:lucid_org/screens/loading_screen.dart';
import 'package:lucid_org/screens/mainScreen.dart';
import 'package:lucid_org/services/firestoreService.dart';
import 'package:lucid_org/helperClasses/questionMultipleChoice.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

Logger log = Logger('WelcomeScreen');

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;
  bool _error = false;
  String _errorText = '';
  String _loadingText = "Validating Assessment";
  Logger logger = Logger('WelcomeScreen');

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  // Fixed initialization method
  Future<void> _initializeScreen() async {
    if (mounted) {
      setState(() {
        _loadingText = "Loading Survey";
      });
    }

    try {
      final surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);
      final questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);

      // First Check tokens and get current Assessment DocName
      await surveyDataProvider.init();

      // Get Questions
      final questions = await Firestoreservice.getQuestions();
      if (questions.isNotEmpty) {
        // Fix: Properly cast the nested map structure
        Map<String, Map<String, dynamic>> multipleChoiceQuestions = questions.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value as Map)));

        int count = 0;

        multipleChoiceQuestions.forEach((key, value) {
          count++;
          questionsProvider.addQuestion(Questionmultiplechoice(
            textHeading: value['textHeading'] ?? 'Default Text',
            index: value['index'],
            type: QuestionType.multipleChoice,
          ));
        });

        logger.info("$count Multiple choice Questions loaded into QuestionsProvider.");
        questionsProvider.sortQuestions();
        logger.info("getQuestions successful");
      } else {
        throw SurveyException(
          'There was an error getting the questions. Please click the link again',
          'Configuration Error'
        );
      }

      // Done Loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on SurveyException catch (e) {
      _handleError(e.message);
    } catch (e) {
      logger.severe('Unexpected Error: $e');
      _handleError("Unexpected Error");
    }
  }

  void _handleError(String message) {
    if (mounted) {
      setState(() {
        _error = true;
        _errorText = message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingScreen(_loadingText)
        : _error
            ? ErrorScreen(
                _errorText,
              )
            : const WelcomeScreenComponentLayout();
  }
}

class WelcomeScreenComponentLayout extends StatelessWidget {
  const WelcomeScreenComponentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 1),
              Image.asset(
                'assets/logo/logo.jpg',
                width: 300,
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 350),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 4)],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Welcome to the Assessment', style: kWelcomeScreenH1TextStyle),
                      SizedBox(height: 8),
                      Text('The assessment will take approximately 15min. If you exit before finishing, your result will not be saved', style: kWelcomeScreenH2TextStyle),
                      SizedBox(height: 24),
                      CustomStartButton(
                        onPressed: () async {
                          log.info('Start Button pressed');
                          await onSurveyStarted(context);
                        },
                      ),
                      // CustomStartButton(
                      //   onPressed: () async {
                      //     Provider.of<FirestoreService>(context, listen: false).addQuestiontoDB();
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSurveyStarted(BuildContext context) async {
    final surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);
    final questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);

    if (questionsProvider.currentIndex == -1) {
      questionsProvider.nextQuestion();
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => Mainscreen()));

    // Perform heavy operations after navigation using natural async/await
    if (surveyDataProvider.product != Product.test && !surveyDataProvider.surveyStarted) {
      await surveyDataProvider.startSurvey();
    }
  }
}
