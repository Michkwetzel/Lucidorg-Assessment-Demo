import 'package:flutter/material.dart';
import 'componentsOld.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({super.key});

  @override
  State<QuestionScreen> createState() => _QuestionscreenState();
}

class _QuestionscreenState extends State<QuestionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Align(
        alignment: Alignment.topCenter,
        child: MainContainer(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LinearProgressIndicator(
                value: 0,
              ),
              SizedBox(height: 10),
              TopInfoBar(
                welcomeScreen: false,
              ),
              SizedBox(height: 20),
              Text(
                "Everybody in Test Company...",
                style: TextStyle(fontSize: 30, fontFamily: 'Nunito'),
              ),
              SizedBox(height: 20),
              Text(
                "... knows and understands the company's purpose. mission, vision and values",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontFamily: 'Nunito'),
              ),
              SizedBox(
                height: 20,
              ),
              
              SizedBox(
                height: 20,
              ),
              StandardButton(text: "Next", callback: () {})
            ],
          ),
        ),
      ),
    );
  }
}
