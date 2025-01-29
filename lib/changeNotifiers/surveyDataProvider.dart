import 'package:flutter/material.dart';

class SurveyDataProvider extends ChangeNotifier {
  String? latestDocname = '';
  String? surveyUID = '';
  String? comapnyUID = '';

  String? getLatestDocname() {
    return latestDocname;
  }

  String? getSurveyUID() {
    return surveyUID;
  }

  String? getCompanyUID() {
    return comapnyUID;
  }

  List<String> getAllInfo() {
    return [latestDocname!, surveyUID!, comapnyUID!];
  }

  void updateLatestDocname(String? newDocname) {
    latestDocname = newDocname;
    notifyListeners();
  }

  void updateSurveyUID(String? newSurveyUID) {
    surveyUID = newSurveyUID;
    notifyListeners();
  }

  void updateCompanyUID(String? newCompanyUID) {
    comapnyUID = newCompanyUID;
    notifyListeners();
  }
}
