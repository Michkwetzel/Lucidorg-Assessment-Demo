import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/constants.dart';
import 'package:provider/provider.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Selector<QuestionsProvider, ({double progress, String progressText})>(
      selector: (context, provider) => (
        progress: (provider.currentIndex + 1) / provider.questionLength,
        progressText: "${provider.currentIndex + 1} / ${provider.questionLength}",
      ),
      builder: (context, data, child) {
        return Row(children: [
          Expanded(
            child: LinearProgressIndicator(
              value: data.progress,
              backgroundColor: Color(0xffDADADA),
              color: Color(0xff1FB707),
            ),
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            data.progressText,
            style: kRatingBarHintTextStyle,
          ),
        ]);
      },
    );
  }
}
