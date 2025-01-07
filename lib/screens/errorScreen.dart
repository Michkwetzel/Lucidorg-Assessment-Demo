import 'package:flutter/material.dart';
import 'package:front_survey_questions/constants.dart';

class ErrorScreen extends StatelessWidget {
  final String errorText;

  const ErrorScreen(this.errorText, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/efficiency-1stLogo.png',
                width: 150,
              ),
              SizedBox(height: 32,),
              Container(
                constraints: BoxConstraints(maxWidth: 350),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 4)],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(errorText, style: kWelcomeScreenH2TextStyle, textAlign: TextAlign.center,),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
