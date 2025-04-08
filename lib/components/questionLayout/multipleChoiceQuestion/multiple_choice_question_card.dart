import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/radioButtonsState.dart';
import 'package:front_survey_questions/components/questionLayout/multipleChoiceQuestion/radio_button_card.dart';
import 'package:front_survey_questions/constants.dart';
import 'package:provider/provider.dart';

class MultipleChoiceQuestionCard extends StatelessWidget {
  final List<dynamic> options;
  final List<RadioButtonCard> radioButtonCards;
  final String textHeading;

  MultipleChoiceQuestionCard({super.key, required this.options, required this.textHeading}) : radioButtonCards = [] {
    int counter = 1;
    for (String option in options) {
      radioButtonCards.add(RadioButtonCard(text: option, radioButtonIndex: counter));
      counter++;
    }
  }

  Expanded expandedListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: radioButtonCards.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: 24,
            );
          } else if (index <= radioButtonCards.length) {
            return radioButtonCards[index - 1];
          } else {
            return SizedBox(
              height: 80,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<RadioButtonState>(context).errorDisplay) {
      return Column(
        children: [
          SizedBox(
            height: 24,
          ),
          Text(
            textHeading,
            style: kRatingQTextStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Icon(Icons.dangerous, color: Colors.red[300]!, size: 20, grade: 0.5), SizedBox(width: 4), Text("Please select an answer", style: TextStyle(color: Colors.red[300]!))],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: radioButtonCards.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return SizedBox(
                    height: 4,
                  );
                } else if (index <= radioButtonCards.length) {
                  return radioButtonCards[index - 1];
                } else {
                  return SizedBox(
                    height: 80,
                  );
                }
              },
            ),
          )
        ],
      );
    }
    return Column(
      children: [
        SizedBox(
          height: 24,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            textHeading,
            style: kRatingQTextStyle,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: radioButtonCards.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) {
                return SizedBox(
                  height: 24,
                );
              } else if (index <= radioButtonCards.length) {
                return radioButtonCards[index - 1];
              } else {
                return SizedBox(
                  height: 80,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
