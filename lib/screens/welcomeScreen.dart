import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/changeNotifiers/welcome_screen_provider.dart';
import 'package:lucid_org/components/custonButtons/custom_start_button.dart';
import 'package:lucid_org/constants.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/screens/errorScreen.dart';
import 'package:lucid_org/screens/loading_screen.dart';
import 'package:lucid_org/screens/mainScreen.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

Logger log = Logger('WelcomeScreen');

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Schedule initialization for after the first frame to avoid calling
    // notifyListeners during build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeScreen();
    });
  }

  Future<void> _initializeScreen() async {
    final welcomeProvider = Provider.of<WelcomeScreenProvider>(context, listen: false);
    final surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);
    final questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);

    await welcomeProvider.initialize(surveyDataProvider, questionsProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WelcomeScreenProvider>(
      builder: (context, welcomeProvider, child) {
        if (welcomeProvider.isLoading) {
          return LoadingScreen(welcomeProvider.loadingText);
        }

        if (welcomeProvider.hasError) {
          return ErrorScreen(welcomeProvider.errorText);
        }

        return const WelcomeScreenComponentLayout();
      },
    );
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
