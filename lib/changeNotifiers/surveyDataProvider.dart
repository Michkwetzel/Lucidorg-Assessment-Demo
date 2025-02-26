import 'package:flutter/material.dart';

class SurveyDataProvider extends ChangeNotifier {
  String? latestDocname = '';
  String? surveyUID = '';
  String? comapnyUID = '';
  String? emailType = '';

  SurveyDataProvider({this.surveyUID, this.comapnyUID});

  String? getLatestDocname() {
    return latestDocname;
  }

  String? getSurveyUID() {
    return surveyUID;
  }

  String? getCompanyUID() {
    return comapnyUID;
  }

  String? getEmailType() {
    return emailType;
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

  void updateEmailType(String? newEmailType) {
    emailType = newEmailType;
    notifyListeners();
  }
}
