import 'package:flutter/material.dart';

class RadioButtonState extends ChangeNotifier {
  int _selectedIndex = -1;
  bool _errorDisplay = false;

  bool get errorDisplay => _errorDisplay;
  int get selectedIndex => _selectedIndex;

  void noAnswerSelected() {
    _errorDisplay = true;
    notifyListeners();
  }

  void onRadioButtonSelected(int index) {
    _selectedIndex = index;
    _errorDisplay = false;

    notifyListeners();
  }

  void resetSelection() {
    _selectedIndex = -1;
    notifyListeners();
  }
}
