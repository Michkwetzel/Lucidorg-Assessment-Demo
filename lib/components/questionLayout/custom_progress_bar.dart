import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:provider/provider.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsProvider>(
      builder: (context, questionsProvider, child) {
        return LinearProgressIndicator(
          value: questionsProvider.currentIndex / questionsProvider.questionLength,
          backgroundColor: Color(0xffDADADA),
          color: Color(0xff1FB707),
        );
      },
    );
  }
}
