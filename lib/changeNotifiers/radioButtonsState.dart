import 'package:flutter/material.dart';

class RadioButtonState extends ChangeNotifier {
  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  void onRadioButtonSelected(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void resetSelection() {
    _selectedIndex = -1;
    notifyListeners();
  }
}
