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
    QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);

    //gets Questions
    //initGetQuestions(firestoreService);

    return Mainscreen(
      welcomeScreen: true,
      welcomeScreenLayout: WelcomeScreenComponentLayout(),
    );
  }
}

class WelcomeScreenComponentLayout extends StatelessWidget {
  const WelcomeScreenComponentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TopComponent(
          text: "Welcome to Test Survey",
          showCloseIcon: false,
        ),
        CustomProgressBar(),
        Padding(
          padding: MediaQuery.of(context).size.width > 600 ? const EdgeInsets.symmetric(vertical: 36) : const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Text(
            "Answers are saved anonomously.\nIf you exit before finishing, your results will not be saved",
            style: kRatingQTextStyle,
          ),
        ),
      ],
    );
  }
}
