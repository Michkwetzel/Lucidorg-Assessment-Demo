import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/components/custonButtons/custom_back_button.dart';
import 'package:lucid_org/components/custonButtons/custom_next_button.dart';
import 'package:lucid_org/components/questionLayout/custom_progress_bar.dart';
import 'package:lucid_org/components/questionLayout/top_component.dart';
import 'package:lucid_org/enums.dart';
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
          constraints: BoxConstraints(maxWidth: 575),
          child: Stack(
            children: [
              MainComponentLayout(),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: CustomBackButton(
                    onPressed: () {},
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: CustomNextButton(),
                ),
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
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 50),
          Selector<QuestionsProvider, ({String textHeading, bool hasExtraText, String extraText, QuestionType questionType})>(
            selector: (context, provider) => (
              textHeading: provider.textHeading,
              hasExtraText: provider.hasExtraText,
              extraText: provider.extraText,
              questionType: provider.currentQuestionType,
            ),
            builder: (context, data, child) {
              return TopComponent(
                text: data.textHeading,
                hasExtraText: data.hasExtraText,
                textExtra: data.extraText,
                questionType: data.questionType,
              );
            },
          ),
          SizedBox(height: 24),
          CustomProgressBar(),
          SizedBox(height: 15),
          Flexible(
            child: Selector<QuestionsProvider, Widget>(
              selector: (context, provider) => provider.currentQuestionCard,
              builder: (context, currentQuestionCard, child) {
                return currentQuestionCard;
              },
            ),
          )
        ],
      ),
    );
  }
}
