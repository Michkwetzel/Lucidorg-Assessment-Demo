import 'package:flutter/material.dart';
import 'package:front_survey_questions/constants.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 700),
        child: Stack(children: [
          MainComponentLayout(),
          Align(
            alignment: Alignment.bottomLeft,
            child: BackButton(),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: NextButton(),
          )
        ]),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TopComponent(text: 'Everybody in Test Company...',),
        CustomProgressBar(),
        UserInputSection(),
      ],
    );
  }
}

class UserInputSection extends StatelessWidget {
  const UserInputSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView(
        children: [
          RatingQuestionLayout(text: 'knows and understands the company\'s purpose, mission, vision and values'),
          // RadioButtonCard(
          //   text: 'The company has a mission and vision but lacks a clear purpose',
          // ),
          // RadioButtonCard(
          //   text: 'While a company purpose exists, only a few teams and individuals resonate with it',
          // ),
          // RadioButtonCard(
          //   text: 'The company has a defined purpose, but it\`s not well-communicated or understood by many',
          // ),
          // RadioButtonCard(
          //   text: 'Some people and teams align with the company\'s purpose; others remain detached',
          // ),
          // RadioButtonCard(
          //   text: 'A majority of people and teams actively incorporate the company\'s purpose in their daily operations',
          // ),
          // RadioButtonCard(
          //   text: 'The company\'s purpose is deeply ingrained and consistently aligned throughout the entire organization.',
          // ),
          // SizedBox(
          //   height: 80,
          // )
        ],
      ),
    );
  }
}

class RatingQuestionLayout extends StatelessWidget {
  final String text;
  const RatingQuestionLayout({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 36, vertical: 36),
          child: Text(
            text,
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

class RadioButtonCard extends StatelessWidget {
  final String text;
  final String? textExtra;

  const RadioButtonCard({super.key, required this.text, this.textExtra});

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 24, left: 32, right: 32);

    if (MediaQuery.of(context).size.width > 700) {
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
  const TopComponent({super.key, required this.text});

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
            Expanded(child: Text(text, style: kH1TextStyle)),
            SizedBox(width: 8),
            if (!desktop) CloseIcon(),
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

class BackButton extends StatelessWidget {
  const BackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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

class NextButton extends StatelessWidget {
  const NextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox(
        width: 120,
        height: 55,
        child: MaterialButton(
          onPressed: () {
            //TODO Your onPressed logic
          },
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
