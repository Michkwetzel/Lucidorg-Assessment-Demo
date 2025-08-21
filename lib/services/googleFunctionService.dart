import 'package:lucid_org/constants.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/services/httpService.dart';
import 'package:logging/logging.dart';

class GoogleFunctionService {
  static Logger logger = Logger('GoogleFunctionService');

  static Future<bool> surveyStarted(String orgId, String assessmentId, String docId, bool alreadyStarted) async {
    // Survey Already started. No Need to do call to back end.
    if (alreadyStarted) {
      logger.info('Already started');
      return true;
    }

    try {
      Map<String, String> request = {'orgId': orgId, 'assessmentId': assessmentId, 'docId': docId};

      final response = await HttpService.postRequest(
          path: kSurveyStartedPath,
          request: request);

      if (response['success']) {
        logger.info('Survey Started for company: $orgId, docId: $docId');
        return true;
      } else {
        throw Exception(response['error'] ?? 'Failed to start survey');
      }
    } catch (e) {
      logger.severe('Error starting survey: $e');
      rethrow;
    }
  }

  static Future<void> saveResults(String orgId, String assessmentId, String docId, List<int> results) async {
    try {
      Map<String, dynamic> request = {'orgId': orgId, 'assessmentId': assessmentId, 'docId': docId, 'results': results};

      final response = await HttpService.postRequest(
          path: kSaveResultsPath,
          request: request);

      if (response['success']) {
        logger.info('Results saved successfully for docId: $docId');
      } else {
        throw Exception(response['error'] ?? 'Failed to save results');
      }
    } catch (e) {
      logger.severe('Error saving results: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getQuestions() async {
    try {
      final response = await HttpService.getRequest(path: kGetQuestionsPath);
      if (response['success']) {
        Map<String, dynamic> multipleChoiceQuestions = response['data'];
        print("Questions loaded successfully from backend.");
        return {'success': true, 'questions': multipleChoiceQuestions};
      } else {
        return {'success': false, 'error': 'Failed to load questions'};
      }
    } on Exception catch (e) {
      logger.severe('Error getting questions: $e');
      return {'success': false, 'error': e.toString()};
    }
  }

  Future<void> pushTestResults() async {
    //Send companyUID, LastestSurveyDocName and surveyToken to back end so that it can change data
    String emailType = 'cSuite';
    List<int> results = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
    String companyUID = 'RhBs9nhOWigeGY8wVUEU';
    String surveyUID = 'Ld8rUlNmsxi7gyn2A5xw';
    Map<String, dynamic> request = {'latestSurveyDocName': '2025-03-27T08-54-57', 'surveyUID': surveyUID, 'emailType': emailType, 'companyUID': companyUID, 'results': results};
    String path = 'http://127.0.0.1:5001/efficiency-1st/us-central1/pushTestResults';

    await HttpService.postRequest(path: path, request: request);
    print('pushing test result $companyUID');
  }

  // Add these methods to your GoogleFunctionService class

  static Future<bool> checkDataDocStatus(String orgId, String assessmentId, String docId) async {
    try {
      logger.info("Checking dataDoc status.");

      Map<String, dynamic> request = {'orgId': orgId, 'assessmentId': assessmentId, 'docId': docId};

      final response = await HttpService.postRequest(
          path: kCheckDataDocStatusPath,
          request: request);

      if (response['success']) {
        logger.info('DataDoc status checked successfully');
        if (response['submitted'] == true) {
          throw SurveyAlreadyCompletedException();
        }
        if (response['started'] == true) {
          return true;
        } else {
          return false;
        }
      } else {
        throw Exception(response['error'] ?? 'Failed to check dataDoc status');
      }
    } catch (e) {
      logger.severe('Error checking dataDoc status: $e');
      rethrow;
    }
  }

  static Future<String> getCompanyName(String orgId) async {
    try {
      Map<String, dynamic> request = {'orgId': orgId};

      final response = await HttpService.postRequest(
          path: kGetCompanyNamePath,
          request: request);

      if (response['success']) {
        String companyName = response['companyName'] ?? "My Company";
        logger.info('Company name retrieved: $companyName');
        return companyName;
      } else {
        throw Exception(response['error'] ?? 'Failed to get company name');
      }
    } catch (e) {
      logger.severe('Error getting company name: $e');
      // Set default company name on error
      return "My Company";
    }
  }
}
