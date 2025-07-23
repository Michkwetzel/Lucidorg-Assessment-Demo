import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/constants.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/helperClasses/questionMultipleChoice.dart';
import 'package:lucid_org/helperClasses/questionRating.dart';
import 'package:lucid_org/services/httpService.dart';
import 'package:logging/logging.dart';

class GoogleFunctionService {
  final SurveyDataProvider surveyDataProvider;
  final QuestionsProvider questionsProvider;

  Logger logger = Logger('GoogleFunctionService');

  GoogleFunctionService({required this.questionsProvider, required this.surveyDataProvider});

  Future<void> surveyStarted() async {
    // Survey Already started. No Need to do call to back end.
    if (surveyDataProvider.surveyStarted) {
      logger.info('Already started');
      return;
    }

    try {
      Map<String, String> request = {'orgId': surveyDataProvider.orgId!, 'assessmentId': surveyDataProvider.assessmentID!, 'docId': surveyDataProvider.docId!};

      final response = await HttpService.postRequest(
          path: kSurveyStartedPath, // Your existing constant
          request: request);

      if (response['success']) {
        surveyDataProvider.setSurveyStartedTrue();
        logger.info('Survey Started for company: ${surveyDataProvider.orgId}, docId: ${surveyDataProvider.docId}');
      } else {
        throw Exception(response['error'] ?? 'Failed to start survey');
      }
    } catch (e) {
      logger.severe('Error starting survey: $e');
      rethrow;
    }
  }

  Future<void> saveResults(List<int> results) async {
    try {
      Map<String, dynamic> request = {'orgId': surveyDataProvider.orgId!, 'assessmentId': surveyDataProvider.assessmentID!, 'docId': surveyDataProvider.docId!, 'results': results};

      final response = await HttpService.postRequest(
          path: kSaveResultsPath, // Add this constant to your constants file
          request: request);

      if (response['success']) {
        logger.info('Results saved successfully for docId: ${surveyDataProvider.docId}');
      } else {
        throw Exception(response['error'] ?? 'Failed to save results');
      }
    } catch (e) {
      logger.severe('Error saving results: $e');
      rethrow;
    }
  }

  Future<void> getQuestions() async {
    try {
      final response = await HttpService.getRequest(path: kGetQuestionsPath);
      if (response['success']) {
        Map<String, dynamic> multipleChoiceQuestions = response['data']['multipleChoice'];
        int count = 0;

        multipleChoiceQuestions.forEach((key, value) {
          count++;
          questionsProvider.addQuestion(Questionmultiplechoice(
            textHeading: value['textHeading'] ?? 'Default Text',
            textExtra: value['textExtra'],
            index: value['index'],
            type: QuestionType.multipleChoice,
          ));
        });

        print("$count Multiple choice Questions loaded into QuestionsProvider.");
        questionsProvider.sortQuestions();
        print("getQuestions from FireStore successful");
      }
    } on Exception catch (e) {
      questionsProvider.setQuestions([
        QuestionRating(
          textHeading: "This is akward",
          textBody: 'There was an error getting the question. Please refresh the browser',
          index: 0,
          type: QuestionType.error,
        )
      ]);
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

  Future<bool> checkDataDocStatus() async {
    try {
      logger.info("Checking dataDoc status.");

      Map<String, dynamic> request = {'orgId': surveyDataProvider.orgId!, 'assessmentId': surveyDataProvider.assessmentID!, 'docId': surveyDataProvider.docId!};

      final response = await HttpService.postRequest(
          path: kCheckDataDocStatusPath, // Add this constant to your constants file
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

  Future<String> getCompanyName() async {
    try {
      Map<String, dynamic> request = {'orgId': surveyDataProvider.orgId!};

      final response = await HttpService.postRequest(
          path: kGetCompanyNamePath, // Add this constant to your constants file
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
