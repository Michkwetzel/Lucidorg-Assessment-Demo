import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/constants.dart';
import 'package:provider/provider.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsProvider>(
      builder: (context, questionsProvider, child) {
        return Row(children: [
          Expanded(
            child: LinearProgressIndicator(
              value: (questionsProvider.currentIndex + 1) / questionsProvider.questionLength,
              backgroundColor: Color(0xffDADADA),
              color: Color(0xff1FB707),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            "${questionsProvider.currentIndex + 1} / ${questionsProvider.questionLength}",
            style: kRatingBarHintTextStyle,
          ),
        ]);
      },
    );
  }
}
