import 'package:flutter/material.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/services/googleFunctionService.dart';

// This class ensures All config data is uploaded at start and available for the rest of the app
class SurveyDataProvider extends ChangeNotifier {
  String? orgId;
  String? assessmentID;
  Product? product;
  String? docId;
  String? companyName;
  bool surveyStarted;

  SurveyDataProvider({this.orgId, this.assessmentID, this.docId, this.surveyStarted = false});

  Future<bool> init() async {
    print("Init");
    try {
      if (orgId == null || assessmentID == null || docId == null) {
        throw MissingTokenException();
      } else if (orgId == 'test') {
        product = Product.test;
        return true;
      }

      await checkDataDocStatus();
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

  Future<void> checkDataDocStatus() async {
    bool surveyStartedStatus = await GoogleFunctionService.checkDataDocStatus(orgId!, assessmentID!, docId!);
    surveyStarted = surveyStartedStatus;
  }

  Future<void> getCompanyName() async {
    companyName = await GoogleFunctionService.getCompanyName(orgId!);
    print(companyName);
  }

  void printAllAttributes() {
    print('orgId: $orgId');
    print('assessmentID: $assessmentID');
    print('docId: $docId');
    print('product: $product');
    print('companyName: $companyName');
    print('surveyStarted: $surveyStarted');
  }

  void setSurveyStartedTrue() {
    surveyStarted = true;
  }

  Future<void> startSurvey() async {
    bool success = await GoogleFunctionService.surveyStarted(orgId!, assessmentID!, docId!, surveyStarted);
    if (success) {
      setSurveyStartedTrue();
    }
  }
}
