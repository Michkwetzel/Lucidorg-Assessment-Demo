import 'package:flutter/material.dart';
import 'package:lucid_org/components/custonButtons/info_button.dart';
import 'package:lucid_org/constants.dart';
import 'package:lucid_org/enums.dart';

class TopComponent extends StatelessWidget {
  final String text;
  final String textExtra;
  final bool hasExtraText;
  final QuestionType questionType;
  const TopComponent({super.key, required this.text, required this.hasExtraText, required this.textExtra, required this.questionType});

  @override
  Widget build(BuildContext context) {
    return Row(
      //mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            text,
            style: kH3TextStyle,
            textAlign: TextAlign.left,
          ),
        ),
        if (hasExtraText && questionType == QuestionType.multipleChoice) InfoButton(),
      ],
    );
  }
}
