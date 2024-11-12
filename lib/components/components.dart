import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/changeNotifiers/radioButtonsState.dart';
import 'package:front_survey_questions/changeNotifiers/ratingBarState.dart';
import 'package:front_survey_questions/constants.dart';
import 'package:front_survey_questions/helperClasses/questionMultipleChoice.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final log = Logger("Components");

class RatingQuestionCard extends StatelessWidget {
  final String questionBody;
  const RatingQuestionCard({super.key, required this.questionBody});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: MediaQuery.of(context).size.width > 600 ? EdgeInsets.symmetric(vertical: 36) : EdgeInsets.symmetric(horizontal: 36, vertical: 36),
          child: Text(
            questionBody,
            style: kRatingQTextStyle,
          ),
        ),
        CustomRatingBar(key: Provider.of<Ratingbarstate>(context).ratingBarKey),
      ],
    );
  }
}

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({super.key});

  ///Note here. I manually updated the Rating Bar class specific for this project.
  ///If things change will have to change in the rating_bar.dart class
  ///Dirty I know. but fake it till you make it. Will put in to do for future.
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBar.builder(
          itemSize: 70,
          initialRating: Provider.of<QuestionsProvider>(context).ratingInitialState,
          itemCount: 5,
          itemBuilder: (context, index) {
            return RatingButton(
              index: index + 1,
            );
          },
          onRatingUpdate: (rating) {
            Provider.of<Ratingbarstate>(context, listen: false).setRating(rating);
          },
        ),
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

class RatingButton extends StatelessWidget {
  final int index;
  const RatingButton({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.20), // Shadow color with opacity
              blurRadius: 4, // Blur radius for a softer shadow
            ),
          ],
          color: Color(0xFFFFBB40),
          borderRadius: BorderRadius.circular(12),
        ),
        height: 55,
        width: 60,
        child: Center(
          child: Text(
            index.toString(),
            style: TextStyle(color: Color(0xFF000000), fontFamily: 'Noto Sans', fontSize: 17),
          ),
        ),
      ),
    );
  }
}

class MultipleChoiceQuestionCard extends StatelessWidget {
  final List<dynamic> options;
  final List<RadioButtonCard> radioButtonCards;

  MultipleChoiceQuestionCard({super.key, required this.options}) : radioButtonCards = [] {
    int counter = 1;
    for (String option in options) {
      radioButtonCards.add(RadioButtonCard(text: option, radioButtonIndex: counter));
      counter++;
    }
  }

  @override
  Widget build(BuildContext context) {
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
}

class RadioButtonCard extends StatelessWidget {
  final String text;
  final String? textExtra;
  final int radioButtonIndex;

  const RadioButtonCard({super.key, required this.text, this.textExtra, required this.radioButtonIndex});

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 24, left: 32, right: 32);

    if (MediaQuery.of(context).size.width > 600) {
      padding = const EdgeInsets.only(bottom: 24);
    }

    return Padding(
      padding: padding,
      child: MaterialButton(
        padding: EdgeInsets.all(16),
        elevation: 0,
        onPressed: () => Provider.of<RadioButtonState>(context, listen: false).onRadioButtonSelected(radioButtonIndex),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Color(0xFFCACACA)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Consumer<RadioButtonState>(
                builder: (context, radioButtonCardState, child) {
                  if (radioButtonCardState.selectedIndex == radioButtonIndex) {
                    return Icon(Icons.radio_button_checked);
                  } else {
                    return Icon(Icons.radio_button_off, color: Color(0xFF767575));
                  }
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: kBodyTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      value: 0.8,
      backgroundColor: Color(0xffDADADA),
      color: Color(0xff1FB707),
    );
  }
}

class TopComponent extends StatelessWidget {
  final String text;
  final bool showCloseIcon;
  const TopComponent({super.key, required this.text, required this.showCloseIcon});

  @override
  Widget build(BuildContext context) {
    bool desktop = false;

    if (MediaQuery.of(context).size.width > 400) {
      desktop = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                child: Text(
              text,
              style: kH2TextStyle,
            )),
            if (!desktop && showCloseIcon) CloseIcon(),
            if (!desktop && showCloseIcon) SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class CloseIcon extends StatelessWidget {
  const CloseIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.close,
      size: 24,
      color: Color(0xff585858),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomBackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    void previousQuestion() {
      QuestionsProvider q = Provider.of<QuestionsProvider>(context, listen: false);

      log.info('Previous Button Clicked');
      Provider.of<QuestionsProvider>(context, listen: false).previousQuestion();
      log.info('Loading result for Q${q.currentIndex} - Result ${q.currentQuestion.result}');
    }

    return Padding(
      padding: MediaQuery.of(context).size.width > 600 ? const EdgeInsets.symmetric(vertical: 32) : const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox(
        width: 60 * 0.9,
        height: 55 * 0.9,
        child: MaterialButton(
          onPressed: () => previousQuestion(),
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF3F94FF),
            size: 16 * 0.9,
          ),
        ),
      ),
    );
  }
}

class CustomNextButton extends StatelessWidget {
  const CustomNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    void nextQuestion() {
      log.info('Next Button Clicked');
      QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
      if (questionsProvider.currentQuestion is Questionmultiplechoice) {
        double result = Provider.of<RadioButtonState>(context, listen: false).selectedIndex.toDouble();
        questionsProvider.nextQuestion(result);
      } else {
        double result = Provider.of<Ratingbarstate>(context, listen: false).saveRating();
        questionsProvider.nextQuestion(result);
      }
      Provider.of<QuestionsProvider>(context, listen: false).printQuestions();
    }

    //TODO: Set correct widhts for Floating Buttons.
    return Padding(
      padding: MediaQuery.of(context).size.width > 600 ? const EdgeInsets.symmetric(vertical: 32) : const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox(
        width: 120 * 0.9,
        height: 55 * 0.9,
        child: MaterialButton(
          onPressed: () => nextQuestion(),
          color: Color(0xFF3F94FF),
          elevation: 4,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Next",
                style: TextStyle(color: Colors.white, fontFamily: 'Noto Sans', fontSize: 22 * 0.9),
              ),
              const Icon(Icons.navigate_next_rounded, color: Colors.white, size: 24 * 0.9)
            ],
          ),
        ),
      ),
    );
  }
}

class CustomStartButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomStartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: MaterialButton(
        onPressed: onPressed,
        color: Color(0xFFFFFFFF),
        elevation: 4,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  textAlign: TextAlign.center,
                  "Start",
                  style: TextStyle(color: Colors.black, fontFamily: 'Noto Sans', fontSize: 22),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
