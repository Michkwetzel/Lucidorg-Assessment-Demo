import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/ratingBarState.dart';
import 'package:lucid_org/components/custonButtons/info_button.dart';
import 'package:lucid_org/components/questionLayout/ratingQuestion/custom_rating_bar.dart';
import 'package:lucid_org/constants.dart';
import 'package:provider/provider.dart';

class RatingQuestionCard extends StatelessWidget {
  final String questionBody;
  final bool hasExtraText;
  final String extraText;
  const RatingQuestionCard({super.key, required this.questionBody, required this.hasExtraText, required this.extraText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: MediaQuery.of(context).size.width > 600 ? EdgeInsets.symmetric(vertical: 36) : EdgeInsets.symmetric(horizontal: 36, vertical: 36),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  questionBody,
                  style: kRatingQTextStyle,
                ),
              ),
              if (hasExtraText) InfoButton()
            ],
          ),
        ),
        const CustomRatingBar(),
      ],
    );
  }
}
