import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/components/components.dart';
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
          // margin: EdgeInsets.all(24),
          // padding: EdgeInsets.all(24),
          // decoration: BoxDecoration(
          //   color: Colors.white,
          //   borderRadius: BorderRadius.circular(16),
          //   boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 2)],
          // ),
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
              text: questionsProvider.textHeading,
              hasExtraText: questionsProvider.hasExtraText,
              textExtra: questionsProvider.extraText,
              questionType: questionsProvider.currentQuestionType,
            );
          },
        ),
        CustomProgressBar(),
        Consumer<QuestionsProvider>(
          builder: (context, questionsProvider, child) {
            return questionsProvider.currentQuestionCard;
          },
        )
      ],
    );
  }
}
