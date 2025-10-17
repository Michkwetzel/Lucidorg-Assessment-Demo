import 'package:flutter/material.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/services/firestoreService.dart';
import 'package:lucid_org/services/googleFunctionService.dart';
import 'package:logging/logging.dart';

// This class ensures All config data is uploaded at start and available for the rest of the app
class SurveyDataProvider extends ChangeNotifier {
  static final Logger logger = Logger('SurveyDataProvider');

  String? orgId;
  String? assessmentID;
  Product? product;
  String? docId;
  String? companyName;
  bool surveyStarted;

  SurveyDataProvider({this.orgId, this.assessmentID, this.docId, this.surveyStarted = false});

  Future<bool> init() async {
    logger.info("Initializing SurveyDataProvider");
    try {
      if (orgId == 'test') {
        product = Product.test;
        return true;
      }

      final surveyData = await Firestoreservice.getAssessmentData(docId!);
      if (surveyData['submitted'] == true) {
        throw SurveyAlreadyCompletedException();
      }
      surveyStarted = surveyData['started'];
      companyName = surveyData['companyName'];

      logAllAttributes();
      return true;
    } on Exception catch (e) {
      if (e is SurveyException) {
        rethrow;
      }
      return false;
    }
  }

  void logAllAttributes() {
    logger.info('Survey data - orgId: $orgId, assessmentID: $assessmentID, docId: $docId, product: $product, companyName: $companyName, surveyStarted: $surveyStarted');
  }

  Future<void> startSurvey() async {
    if (!surveyStarted) {
      try {
        bool success = await GoogleFunctionService.surveyStarted(orgId!, assessmentID!, docId!, surveyStarted);
        if (success) {
          surveyStarted = true;
        }
      } catch (e) {
        // Log the error but don't stop the survey - user can still complete it
        logger.warning('Failed to mark survey as started, but continuing: $e');
      }
    }
  }
}
