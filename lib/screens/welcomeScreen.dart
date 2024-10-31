import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/components/components.dart';
import 'package:front_survey_questions/services/firestoreService.dart';
import 'package:provider/provider.dart';

import '../changeNotifiers/cardState.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService = Provider.of<FirestoreService>(context);
    QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(context);

    return MainContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LinearProgressIndicator(
            value: 0,
          ),
          SizedBox(height: 10),
          TopInfoBar(
            welcomeScreen: true,
          ),
          SizedBox(height: 20),
          Text(
            "Welcome to TestCompany survey",
            style: TextStyle(fontSize: 31, fontFamily: 'Nunito'),
          ),
          SizedBox(height: 20),
          Text(
            "Please rate the questions",
            style: TextStyle(fontSize: 29, fontFamily: 'Nunito'),
          ),
          SizedBox(height: 20),
          CardInstructions(),
          SizedBox(height: 15),
          StandardButton(text: "Start", callback: () => Provider.of<CardState>(context, listen: false).nextCard()),
          TextButton(onPressed: () => firestoreService.getQuestions(), child: Text("Get Questions!")),
        ],
      ),
    );
  }
}
