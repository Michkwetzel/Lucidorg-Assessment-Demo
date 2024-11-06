import 'package:flutter/material.dart';
import 'package:front_survey_questions/components/components.dart';

class Mainscreen extends StatelessWidget {
  final Widget? welcomeScreenLayout;
  final bool welcomeScreen;
  const Mainscreen({super.key, this.welcomeScreenLayout, required this.welcomeScreen});

  Widget returnWelcomeScreen(BuildContext context) {
    if (welcomeScreen) {
      return Stack(
        children: [
          welcomeScreenLayout!,
          //assets/logo/efficiency-1stLogo.png
          Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: MediaQuery.of(context).size.width > 600 ? const EdgeInsets.symmetric(vertical: 38) : const EdgeInsets.symmetric(horizontal: 24, vertical: 38),
                child: Image.asset(
                  'assets/logo/efficiency-1stLogo.png',
                  width: 150,
                ),
              )),
          Align(
            alignment: Alignment.bottomRight,
            child: CustomTextButton(
              buttonText: "Start",
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Mainscreen(
                            welcomeScreen: false,
                          ))),
            ),
          )
        ],
      );
    }
    return Stack(
      children: [
        MainComponentLayout(),
        Align(
          alignment: Alignment.bottomLeft,
          child: CustomBackButton(),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: CustomTextButton(buttonText: "Next", onPressed: () {}),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool desktop = false;
    if (MediaQuery.of(context).size.width > 600) {
      desktop = true;
    }

    return Center(
      child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 600), child: returnWelcomeScreen(context)),
    );
  }
}

class MainComponentLayout extends StatelessWidget {
  const MainComponentLayout({
    super.key,
  });

  // Widget returnUserInputSection(BuildContext context){

  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TopComponent(
          text: 'Everybody in Test Company...',
          showCloseIcon: true,
        ),
        CustomProgressBar(),
        //returnUserInputSection(context)
      ],
    );
  }
}
