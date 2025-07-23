import 'package:cloud_firestore/cloud_firestore.dart';
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
  GoogleFunctionService googleFunctionService;

  SurveyDataProvider({this.orgId, this.assessmentID, this.docId, this.surveyStarted = false, required this.googleFunctionService});

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
    bool surveyStartedStatus = await googleFunctionService.checkDataDocStatus();
    surveyStarted = surveyStartedStatus;
  }

  Future<void> getCompanyName() async {
    companyName = await googleFunctionService.getCompanyName();
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
}
