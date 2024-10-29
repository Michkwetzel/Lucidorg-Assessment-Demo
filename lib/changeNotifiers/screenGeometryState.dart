import 'package:flutter/material.dart';

enum ScreenType { desktop, medium, mobile }

class ScreenGeometryState extends ChangeNotifier {
  ScreenType _screenType = ScreenType.desktop;

  ScreenType get screenType => _screenType;

  void setScreenType(ScreenType type) {
    _screenType = type;
    notifyListeners();
  }
}
