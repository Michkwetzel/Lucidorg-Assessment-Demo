import 'package:flutter/foundation.dart';

class SurveyInfoProvider extends ChangeNotifier {
  bool alreadyAnswered;

  SurveyInfoProvider({required this.alreadyAnswered});

  void inValid() {
    alreadyAnswered = true;
    notifyListeners();
  }
}
