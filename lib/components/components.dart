import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:front_survey_questions/constants.dart';

class RatingQuestionCard extends StatelessWidget {
  final String questionSecondText;
  const RatingQuestionCard({super.key, required this.questionSecondText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 36, vertical: 36),
          child: Text(
            questionSecondText,
            style: kRatingQTextStyle,
          ),
        ),
        CustomRatingBar(),
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
          initialRating: 3,
          itemCount: 5,
          itemBuilder: (context, index) {
            switch (index) {
              case 0:
                return RatingButton(
                  index: 1,
                );
              case 1:
                return RatingButton(
                  index: 2,
                );
              case 2:
                return RatingButton(
                  index: 3,
                );
              case 3:
                return RatingButton(
                  index: 4,
                );
              case 4:
                return RatingButton(
                  index: 5,
                );
            }
            return Container();
          },
          onRatingUpdate: (rating) {
            print(rating);
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
  final List<String> options;
  final List<RadioButtonCard> radioButtonCards;

  MultipleChoiceQuestionCard({super.key, required this.options}) : radioButtonCards = options.map((optionText) => RadioButtonCard(text: optionText)).toList();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: radioButtonCards.length,
        itemBuilder: (context, index) {
          if (index != radioButtonCards.length - 1) {
            return radioButtonCards[index];
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

  const RadioButtonCard({super.key, required this.text, this.textExtra});

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
        onPressed: () {},
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Color(0xFFCACACA))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(
                Icons.radio_button_off,
                color: Color(0xFF767575),
              ),
            ),
            SizedBox(
              width: 8,
            ),
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
              style: kH1TextStyle,
              textAlign: TextAlign.center,
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
  const CustomBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).size.width > 600 ? const EdgeInsets.symmetric(vertical: 32) : const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox(
        width: 60,
        height: 55,
        child: MaterialButton(
          onPressed: () {
            //TODO Your onPressed logic
          },
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF3F94FF),
            size: 16,
          ),
        ),
      ),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const CustomTextButton({super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).size.width > 600 ? const EdgeInsets.symmetric(vertical: 32) : const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox(
        width: 120,
        height: 55,
        child: MaterialButton(
          onPressed: onPressed  ,
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
                buttonText,
                style: TextStyle(color: Colors.white, fontFamily: 'Noto Sans', fontSize: 22),
              ),
              const Icon(Icons.navigate_next_rounded, color: Colors.white, size: 24)
            ],
          ),
        ),
      ),
    );
  }
}
