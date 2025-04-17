import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/surveyDataProvider.dart';

class StartedProvider extends ChangeNotifier {
  final SurveyDataProvider surveyDataProvider;


  StartedProvider({required this.surveyDataProvider});

  Future<void> checkStartedinDB() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    var docRef = await firestore.collection('surveyData/${surveyDataProvider.companyUID}/${surveyDataProvider.latestDocname}').doc(surveyDataProvider.surveyUID).get();
    if (docRef.exists) {
      var data = docRef.data();
      bool Started = data?['started'] ?? false;
      if (Started == true) {
        print('Already Started');
      }
    }
  }
}
