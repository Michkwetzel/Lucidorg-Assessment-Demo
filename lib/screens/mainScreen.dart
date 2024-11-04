import 'package:flutter/material.dart';
import 'package:front_survey_questions/constants.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      MainComponentLayout(),
      Align(
        alignment: Alignment.bottomLeft,
        child: BackButton(),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: NextButton(),
      )
    ]);
  }
}

class MainComponentLayout extends StatelessWidget {
  const MainComponentLayout({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopComponent(),
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
    return Column();
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
  const TopComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text("What is the state of purpose of Test Company", style: kH1TextStyle)),
          SizedBox(width: 8),
          CloseIcon(),
        ],
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
        height: 60,
        child: MaterialButton(
          onPressed: () {
            //TODO Your onPressed logic
          },
          color: Colors.white,
          elevation: 4,
          minWidth: 0,
          height: 65,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF3F94FF),
            size: 24,
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
        height: 60,
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
              const Text(
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
