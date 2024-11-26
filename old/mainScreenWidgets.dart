import 'package:flutter/material.dart';
import 'package:front_survey_questions/constants.dart';

class CardInstructions extends StatelessWidget {
  const CardInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Rate the questions below',
            style: TextStyle(fontFamily: 'Nunito', fontSize: 30),
          ),
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
        Flexible(child: Icon(Icons.star_rounded)),
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
        Icon(Icons.star_rounded),
        Icon(Icons.star_rounded),
        Icon(Icons.star_rounded),
        Icon(Icons.star_rounded),
        Icon(Icons.star_rounded),
        Flexible(child: Text(' = Most alligned', style: TextStyle(fontSize: 24)))
      ],
    );
  }
}

class CardQuestion extends StatelessWidget {
  const CardQuestion({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 43),
      decoration: kCardQuestionBoxDecoration,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'knows and understands the company\'s purpose, mission, vision and values',
              style: kCardQuestionTextStyle,
            ),
            SizedBox(height: 15),
            
          ],
        ),
      ),
    );
  }
}

class LeftContainerMainScreen extends StatelessWidget {
  const LeftContainerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(color: Color(0xFFADD1FF), borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
                Text("back"),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Section 1/5"),
                Text(
                  "Everybody in Test Company",
                  style: TextStyle(fontSize: 33),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/efficiency-1stLogo.png',
                  width: 200,
                ),
              ],
            )
          ],
        ));
  }
}

class RightContainerMainScreen extends StatelessWidget {
  const RightContainerMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 750),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardInstructions(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CardQuestion(),
                      CardQuestion(),
                      CardQuestion(),
                      CardQuestion(),
                      CardQuestion(),
                      CardQuestion(),
                    ],
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
