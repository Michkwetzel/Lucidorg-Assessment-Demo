import 'package:flutter/material.dart';

class Ratingbarstate extends ChangeNotifier {
  double _initialRating = 0;
  Key _ratingBarKey = UniqueKey(); // key to force rebuild
  double _selectedRating = 0;

  double get initialRating => _initialRating;
  double get selectedRating => _selectedRating;
  Key get ratingBarKey => _ratingBarKey;

  void setRating(double rating) {
    _selectedRating = rating;
    notifyListeners();
  }

  void resetRating() {
    _ratingBarKey = UniqueKey();
    notifyListeners();
  }

  void setInitalRating(double rating) {
    _initialRating = rating;
  }

  double saveRating() {
    double selectedRating = _selectedRating;
    resetRating();
    return selectedRating;
  }
}
