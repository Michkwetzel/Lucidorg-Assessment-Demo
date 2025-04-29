import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/exceptions.dart';

// This class ensures All config data is uploaded at start and available for the rest of the app
class SurveyDataProvider extends ChangeNotifier {
  String? latestDocname;
  String? surveyUID;
  String? companyUID;
  String? emailType;
  String? jobSearchUID;
  Product? product;
  String? companyName;
  bool surveyStarted;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  SurveyDataProvider({this.surveyUID, this.companyUID, this.jobSearchUID, this.surveyStarted = false});

  Future<bool> checkTokensandLoadData() async {
    print("Check Tokens and Load Data Started");
    print("Tokens: SurveyUID: $surveyUID, CompanyUID: $companyUID, JobSearchUID: $jobSearchUID");
    try {
      if (surveyUID == 'test') {
        // Set product to Test and finish
        product = Product.test;
        return true;
      } else if (surveyUID == null || companyUID == null) {
        throw MissingTokenException();
      } else if (jobSearchUID != null) {
        // HR Survey
        await checkHRTokens();
      } else {
        // ORG survey
        await checkORGTokensAndLoadData();
      }
      await getCompanyName();
      printAllAttributes();
      return true;
    } on Exception catch (e) {
      if (e is SurveyException) {
        rethrow;
      }
      return false;
    }
  }

  Future<void> checkORGTokensAndLoadData() async {
    print("Loading ORG");
    product = Product.org;
    // Get latestSurveyDocname which will be the current survey
    final companyDocSnapshot = await firestore.collection('surveyData').doc(companyUID).get();
    String? latestDocname = companyDocSnapshot.data()?['latestSurvey'];
    if (latestDocname == null) {
      throw NoActiveSurveyException();
    } else {
      // Set latest Doc name
      this.latestDocname = latestDocname;
    }
    // Get results doc and check tokens
    final resultsDocSnapshot = firestore.collection('surveyData/$companyUID/$latestDocname').doc(surveyUID);
    final docSnapshot = await resultsDocSnapshot.get();
    if (!docSnapshot.exists) {
      throw InvalidSurveyTokenException();
    }
    // Check if already finished
    if (docSnapshot.data()?['finished'] == true) {
      throw SurveyAlreadyCompletedException();
    }

    if (docSnapshot.data()?['started'] == true) {
      surveyStarted = true;
    }

    emailType = docSnapshot.data()?['emailType'];
    print("Loading ORG finished");
  }

  Future<void> checkHRTokens() async {
    print("Loading HR");
    product = Product.hr;
    final resultsDocSnapshot = firestore.collection('jobSearchData_HR/$companyUID/$jobSearchUID').doc(surveyUID);
    final docSnapshot = await resultsDocSnapshot.get();
    if (!docSnapshot.exists) {
      throw InvalidSurveyTokenException();
    }
    if (docSnapshot.data()?['finished'] == true) {
      throw SurveyAlreadyCompletedException();
    }
    print("Loading HR Finished");
  }

  Future<void> getCompanyName() async {
    final docsnapshot = await firestore.collection('surveyData').doc(companyUID).get();
    final Map<String, dynamic> companyInfo = docsnapshot.data()!['companyInfo'];
    companyName = companyInfo['companyName'] ?? "My Company";
    print(companyName);
  }

  void printAllAttributes() {
    print('latestDocname: $latestDocname');
    print('surveyUID: $surveyUID');
    print('companyUID: $companyUID');
    print('emailType: $emailType');
    print('jobSearchUID: $jobSearchUID');
    print('product: $product');
    print('companyName: $companyName');
    print('surveyStarted: $surveyStarted');
  }

  void setSurveyStartedTrue() {
    surveyStarted = true;
  }
}
