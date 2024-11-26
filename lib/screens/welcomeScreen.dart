import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/components/components.dart';
import 'package:front_survey_questions/constants.dart';
import 'package:front_survey_questions/services/firestoreService.dart';
import 'package:provider/provider.dart';
import 'mainScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initGetQuestions();
  }

  Future<void> initGetQuestions() async {
    try {
      FirestoreService firestoreService = Provider.of<FirestoreService>(context, listen: false);
      await firestoreService.getQuestions();

      // Update state to indicate loading is complete
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      // Handle potential errors
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load questions: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? LoadingScreen() : WelcomeScreenComponentLayout();
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/efficiency-1stLogo.png',
              width: 150,
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(
              color: Colors.blue, // Customize color as needed
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
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
                'assets/logo/efficiency-1stLogo.png',
                width: 150,
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
                        onPressed: () {
                          log.info('Start Button pressed');
                          Provider.of<QuestionsProvider>(context, listen: false).nextQuestion(-2); //-2 for first card
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Mainscreen()));
                        },
                      )
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
