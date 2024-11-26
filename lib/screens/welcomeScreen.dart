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
    // Load Questiosn from Firestore
    FirestoreService firestoreService = Provider.of<FirestoreService>(context, listen: false);
    initGetQuestions(firestoreService);
    return WelcomeScreenComponentLayout();
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
              SizedBox(
                height: 1,  
              ),
              Image.asset(
                'assets/logo/efficiency-1stLogo.png',
                width: 150,
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 350),
                decoration: BoxDecoration(
                  //border: Border.all(color: Colors.black, width: 0.6, style: BorderStyle.solid),
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
                          //Provider.of<FirestoreService>(context, listen: false).addQuestiontoDB();
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
