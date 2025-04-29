import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/ratingBarState.dart';
import 'package:lucid_org/components/questionLayout/ratingQuestion/rating_button.dart';
import 'package:lucid_org/constants.dart';
import 'package:provider/provider.dart';

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({super.key});

  @override
  Widget build(BuildContext context) {
    bool errorDisplay = Provider.of<Ratingbarstate>(context).errorDisplay;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<Ratingbarstate>(builder: (context, rantingBarState, child) {
          final List<int> indexList = [1, 2, 3, 4, 5];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indexList.map((index) {
              return RatingButton(
                index: index,
                selected: index == rantingBarState.selectedRating,
                errorDisplay: errorDisplay,
              );
            }).toList(),
          );
        }),
        if (errorDisplay)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 2),
            child: SizedBox(
              width: 335,
              child:
                  Row(children: [Icon(Icons.dangerous, color: Colors.red[300]!, size: 20, grade: 0.5), SizedBox(width: 4), Text("Please select an answer", style: TextStyle(color: Colors.red[300]!))]),
            ),
          ),
        if (!errorDisplay) SizedBox(height: 15),
        SizedBox(
          width: 335,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Disagree',
                style: kRatingBarHintTextStyle,
              ),
              Text(
                'Agree',
                style: kRatingBarHintTextStyle,
              ),
            ],
          ),
        )
      ],
    );
  }
}
