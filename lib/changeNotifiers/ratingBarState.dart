import 'package:flutter/material.dart';

class Ratingbarstate extends ChangeNotifier {
  double _initialRating = -1;
  double _selectedRating = -1;
  bool _errorDisplay = false;
  bool _shouldReset = false;

  double get initialRating => _initialRating;
  double get selectedRating => _selectedRating;
  bool get errorDisplay => _errorDisplay;
  bool get shouldReset => _shouldReset;

  void noAnswerSelected(){
    _errorDisplay = true;
    notifyListeners();
  }

  void setRating(double rating) {
    _selectedRating = rating;
    _errorDisplay = false;
    _shouldReset = false;
    notifyListeners();
  }

  void setInitalRating(double rating) {
    _initialRating = rating;
    _selectedRating = rating;
  }

  double getRating() {
    double selectedRating = _selectedRating;
    resetRating();
    return selectedRating;
  }

  void resetRating() {
    _selectedRating = -1;
    _initialRating = -1;
    _shouldReset = true;
    notifyListeners();
  }
}
