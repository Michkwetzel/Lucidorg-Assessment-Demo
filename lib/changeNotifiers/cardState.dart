import 'package:flutter/material.dart';
import 'package:front_survey_questions/screens/questionScreen.dart';
import 'package:front_survey_questions/screens/welcomeScreen.dart';

class CardState extends ChangeNotifier {
  final List _cardsList = [
    WelcomeScreen(),
    QuestionScreen(),
  ];
  int _index = 0;

  List get questionList => _cardsList;
  int get index => _index;

  void nextCard() {
    _index++;
    notifyListeners();
  }

  void previousCard() {
    if (_index != 0) {
      _index--;
    } else {
      return;
    }
    notifyListeners();
  }

  Widget currentCard() {
    return _cardsList[_index];
  }
}
