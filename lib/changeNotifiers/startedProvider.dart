import 'package:flutter/material.dart';

class StartedProvider extends ChangeNotifier {
  bool canSendStartRequest = true;

  bool get getCanSendStartRequest => canSendStartRequest;

  void disableStartingAgain() {
    canSendStartRequest = false;
    notifyListeners();
  }
}
