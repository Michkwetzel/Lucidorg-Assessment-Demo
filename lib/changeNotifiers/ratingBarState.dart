import 'package:flutter/material.dart';

class Ratingbarstate extends ChangeNotifier {
  double _initialRating = -1;
  Key _ratingBarKey = UniqueKey(); // key to force rebuild
  double _selectedRating = -1;
  bool _errorDisplay = false;

  double get initialRating => _initialRating;
  double get selectedRating => _selectedRating;
  bool get errorDisplay => _errorDisplay;
  Key get ratingBarKey => _ratingBarKey;

  void noAnswerSelected(){
    _errorDisplay = true;
    notifyListeners();
  }

  void setRating(double rating) {
    _selectedRating = rating;
    _errorDisplay = false;
    notifyListeners();
  }

  void setInitalRating(double rating) {
    _initialRating = rating;
  }

  double getRating() {
    double selectedRating = _selectedRating;
    resetRating();
    return selectedRating;
  }

    void resetRating() {
    _ratingBarKey = UniqueKey();
    notifyListeners();
  }
}
