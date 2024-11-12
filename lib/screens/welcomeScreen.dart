import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/components/components.dart';
import 'package:front_survey_questions/constants.dart';
import 'package:front_survey_questions/services/firestoreService.dart';
import 'package:provider/provider.dart';
import 'mainScreen.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  void initGetQuestions(FirestoreService firestoreService) async {
    await firestoreService.getQuestions();
  }

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = Provider.of<FirestoreService>(context, listen: false);

    //gets Questions
    initGetQuestions(firestoreService);

    return WelcomeScreenComponentLayout();
  }
}

class WelcomeScreenComponentLayout extends StatelessWidget {
  const WelcomeScreenComponentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3F94FF),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
          child: Container(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/logo/efficiency-1stLogo.png',
                  width: 150,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome to the Survey',
                      style: kWelcomeScreenH1TextStyle,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Answers are saved anonymously. If you exit before finishing, your result will not be saved',
                      style: kWelcomeScreenH2TextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                CustomStartButton(
                  onPressed: () {
                    //Provider.of<FirestoreService>(context, listen: false).addQuestiontoDB();
                    log.info('Start Button pressed');
                    Provider.of<QuestionsProvider>(context, listen: false).nextQuestion(-1);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Mainscreen()));
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
