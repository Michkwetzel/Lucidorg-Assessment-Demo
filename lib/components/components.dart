import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/cards.dart';
import 'package:front_survey_questions/constants.dart';
import 'package:provider/provider.dart';

class MainContainer extends StatelessWidget {
  final Widget child;

  const MainContainer({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(25),
      constraints: BoxConstraints(
        maxWidth: 700,
      ),
      decoration: kMainContainerBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: child,
      ),
    );
  }
}

class StandardButton extends StatelessWidget {
  final String text;
  final Function callback;

  const StandardButton({
    required this.callback,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => callback.call(),
      style: ButtonStyle(backgroundColor: WidgetStatePropertyAll(Color(0xff5E666B)), shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}

class TopInfoBar extends StatelessWidget {
  final bool welcomeScreen;

  const TopInfoBar({
    required this.welcomeScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFADD1FF), borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 15),
        child: welcomeScreen
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo/efficiency-1stLogo.png',
                    width: 120,
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(onPressed: () => Provider.of<Cards>(context, listen: false).previousCard(), icon: Icon(Icons.arrow_back)),
                      Text("back", style: TextStyle(fontSize: 17),),
                    ],
                  ),
                  Image.asset(
                    'assets/logo/efficiency-1stLogo.png',
                    width: 120,
                  ),
                ],
              ),
      ),
    );
  }
}

class CardInstructions extends StatelessWidget {
  const CardInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Wrap(
            alignment: WrapAlignment.start,
            spacing: 20, // Horizontal spacing between items
            runSpacing: 10,
            children: [
              NotAlligned(),
              Alligned(),
            ],
          ),
        ],
      ),
    );
  }
}

class NotAlligned extends StatelessWidget {
  const NotAlligned({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            child: Icon(
          Icons.star_rounded,
          color: Colors.amber,
        )),
        Flexible(
          child: Text(
            ' = not alligned',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ],
    );
  }
}

class Alligned extends StatelessWidget {
  const Alligned({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, color: Colors.amber),
        Icon(Icons.star_rounded, color: Colors.amber),
        Icon(Icons.star_rounded, color: Colors.amber),
        Icon(Icons.star_rounded, color: Colors.amber),
        Icon(Icons.star_rounded, color: Colors.amber),
        Flexible(child: Text(' = Most alligned', style: TextStyle(fontSize: 24)))
      ],
    );
  }
}
