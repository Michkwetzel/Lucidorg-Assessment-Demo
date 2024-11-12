import 'package:flutter/material.dart';

class Ratingbarstate extends ChangeNotifier {
  double _initialRating = 3;
  Key _ratingBarKey = UniqueKey(); // key to force rebuild
  double _selectedRating = 3;

  double get initialRating => _initialRating;
  double get selectedRating => _selectedRating;
  Key get ratingBarKey => _ratingBarKey;

  void setRating(double rating) {
    _selectedRating = rating;
  }

  void resetRating() {
    _ratingBarKey = UniqueKey();
    notifyListeners();
  }

  double saveRating() {
    double selectedRating = _selectedRating;
    resetRating();
    return selectedRating;
  }
}
