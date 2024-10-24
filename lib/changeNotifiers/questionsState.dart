import 'package:flutter/material.dart';

class QuestionareState extends ChangeNotifier {
  int _questionSection = 0;

  int get questionare => _questionSection;

  void setQuestionare(int section) {
    _questionSection = section;
    notifyListeners();
  }
}