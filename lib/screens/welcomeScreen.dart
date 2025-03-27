import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/startedProvider.dart';
import 'package:front_survey_questions/changeNotifiers/surveyDataProvider.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/components/custonButtons/custom_start_button.dart';
import 'package:front_survey_questions/constants.dart';
import 'package:front_survey_questions/exceptions.dart';
import 'package:front_survey_questions/screens/errorScreen.dart';
import 'package:front_survey_questions/screens/loading_screen.dart';
import 'package:front_survey_questions/screens/mainScreen.dart';
import 'package:front_survey_questions/services/firestoreService.dart';
import 'package:front_survey_questions/services/googleFunctionService.dart';
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

  // Combined initialization method
  Future<void> _initializeScreen() async {
    if (mounted) {
      setState(() {
        _loadingText = "Loading Survey";
      });
    }
    try {
      final firestoreService = Provider.of<FirestoreService>(context, listen: false);
      final surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);

      // First Check tokens and get current Assssment DocName
      final infoList = await firestoreService.checkTokens();
      final String? emailType = infoList[0];
      final String? latestDocname = infoList[1];

      if (latestDocname == "test") {
        surveyDataProvider.updateLatestDocname('test');
        await firestoreService.getQuestions('Test Company');
        // Done Loading
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
        return;
      }

      surveyDataProvider.updateLatestDocname(latestDocname);
      surveyDataProvider.updateEmailType(emailType);

      // Get companyName
      final companyName = await firestoreService.getCompanyName();
      if (companyName == null) {
        throw Exception('Company Name doesnt exist');
      }

      // Then get questions and replace with company Name
      await firestoreService.getQuestions(companyName);

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
                      Text('Answers are saved anonymously. If you exit before finishing, your result will not be saved', style: kWelcomeScreenH2TextStyle),
                      SizedBox(height: 24),
                      CustomStartButton(
                        onPressed: () async {
                          log.info('Start Button pressed');
                          Provider.of<QuestionsProvider>(context, listen: false).nextQuestion();
                          String? latestDocName = Provider.of<SurveyDataProvider>(context, listen: false).latestDocname;
                          String? surveyUID = Provider.of<SurveyDataProvider>(context, listen: false).surveyUID;
                          String? CompanyUID = Provider.of<SurveyDataProvider>(context, listen: false).comapnyUID;
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  backgroundColor: Colors.transparent,
                                  child: Center(
                                    child: const CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              });
                          // Check if you can start survey if yes change status in db
                          if (Provider.of<StartedProvider>(context, listen: false).canSendStartRequest == true) {
                            print("sending google request to start");
                            Provider.of<StartedProvider>(context, listen: false).disableStartingAgain();
                            await Provider.of<GoogleFunctionService>(context, listen: false).surveyStarted(latestDocName);
                          }
                          await Provider.of<StartedProvider>(context, listen: false).checkStartedinDB(latestDocName!, surveyUID!, CompanyUID!).then(
                            (value) {
                              Navigator.pop(context);
                            },
                          );
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Mainscreen()));
                        },
                      ),
                      // For updating data
                      // CustomStartButton(
                      //   onPressed: () async {
                      //     Provider.of<FirestoreService>(context, listen: false).addQuestiontoDB();
                      //     Provider.of<GoogleFunctionService>(context,listen: false).pushTestResults();
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
}
