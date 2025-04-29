import 'package:flutter/material.dart';
import 'package:lucid_org/components/custonButtons/info_button.dart';
import 'package:lucid_org/constants.dart';
import 'package:lucid_org/enums.dart';

class TopComponent extends StatelessWidget {
  final String text;
  final String textExtra;
  final bool hasExtraText;
  final QuestionType questionType;
  const TopComponent({super.key, this.text = 'Everyone in the company, including myself...', required this.hasExtraText, required this.textExtra, required this.questionType});

  @override
  Widget build(BuildContext context) {
    bool desktop = false;

    if (MediaQuery.of(context).size.width > 400) {
      desktop = true;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 24, left: 24, top: 40, bottom: 20),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: desktop ? 500 : 300),
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                text,
                style: kH3TextStyle,
              ),
            ),
            if (hasExtraText && questionType == QuestionType.multipleChoice) InfoButton(),
          ],
        ),
      ),
    );
  }
}
