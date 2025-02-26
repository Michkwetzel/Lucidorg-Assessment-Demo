import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/surveyDataProvider.dart';

class StartedProvider extends ChangeNotifier {
  bool canSendStartRequest = true;

  bool get getCanSendStartRequest => canSendStartRequest;

  void disableStartingAgain() {
    canSendStartRequest = false;
    notifyListeners();
  }

  Future<void> checkStartedinDB(String lastestSurveyDocName, String surveyToken, String companyUID) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var docRef = await firestore.collection('surveyData/$companyUID/$lastestSurveyDocName').doc(surveyToken).get();
    if (docRef.exists) {
      var data = docRef.data();
      bool Started = data?['started'] ?? false;
      if (Started == true) {
        print('Already Started'); 
        canSendStartRequest = false;
      }
    }
  }
}
