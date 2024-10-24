import 'package:flutter/material.dart';
import 'package:front_survey_questions/widgets/mainScreenWidgets.dart';

class mainScreen extends StatefulWidget {
  const mainScreen({super.key});

  @override
  State<mainScreen> createState() => _mainScreenState();
}

class _mainScreenState extends State<mainScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(50.0),
        child: Row(
          children: [
            LeftContainerMainScreen(),
            SizedBox(width: 42,),
            RightContainerMainScreen(),
          ],
        ));
  }
}
