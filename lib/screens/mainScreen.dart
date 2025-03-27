import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/components/custonButtons/custom_back_button.dart';
import 'package:front_survey_questions/components/custonButtons/custom_next_button.dart';
import 'package:front_survey_questions/components/questionLayout/custom_progress_bar.dart';
import 'package:front_survey_questions/components/questionLayout/top_component.dart';
import 'package:provider/provider.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          constraints: BoxConstraints(maxWidth: 550),
          child: Stack(
            children: [
              MainComponentLayout(),
              Align(
                alignment: Alignment.bottomLeft,
                child: CustomBackButton(
                  onPressed: () {},
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: CustomNextButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MainComponentLayout extends StatelessWidget {
  const MainComponentLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<QuestionsProvider>(
          builder: (context, questionsProvider, child) {
            return TopComponent(
              hasExtraText: questionsProvider.hasExtraText,
              textExtra: questionsProvider.extraText,
              questionType: questionsProvider.currentQuestionType,
            );
          },
        ),
        CustomProgressBar(),
        Flexible(
          child: Consumer<QuestionsProvider>(
            builder: (context, questionsProvider, child) {
              return questionsProvider.currentQuestionCard;
            },
          ),
        )
      ],
    );
  }
}
