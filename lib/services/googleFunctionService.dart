import 'package:front_survey_questions/constants.dart';
import 'package:front_survey_questions/services/httpService.dart';
import 'package:logging/logging.dart';

class GoogleFunctionService {
  String? surveyToken;
  String? companyUID;
  Logger logger = Logger('GoogleFunctionService');

  GoogleFunctionService({required this.surveyToken, required this.companyUID});

  Future<void> surveyStarted(String? latestDocname) async {
    //Send companyUID, LastestSurveyDocName and surveyToken to back end so that it can change data
    if (surveyToken == 'test') {
      logger.info('Test Survey');
      return;
    }
    Map<String, String> request = {'latestSurveyDocName': latestDocname!, 'companyUID': companyUID!, 'surveyUID': surveyToken!};
    String path = kSurveyStartedPath;

    await HttpService.postRequest(path: path, request: request);
    logger.info('Survey Started for company: $companyUID, surveyToken: $surveyToken');
  }

  Future<void> saveResults(String? latestDocname, String? emailType, List<int> results) async {
    //Send companyUID, LastestSurveyDocName and surveyToken to back end so that it can change data

    Map<String, dynamic> request = {'latestSurveyDocName': latestDocname, 'emailType': emailType, 'companyUID': companyUID!, 'surveyUID': surveyToken!, 'results': results};
    String path = ksaveResultsPath;

    await HttpService.postRequest(path: path, request: request);
    logger.info('Saved results to back end for company: $companyUID, surveyToken: $surveyToken');
  }

  Future<void> pushTestResults(String? latestDocname) async {
    //Send companyUID, LastestSurveyDocName and surveyToken to back end so that it can change data
    String emailType = 'employee';
    List<int> results = [5, 3, 2, 5, 3, 3, 1, 3, 5, 4, 5, 5, 5, 2, 1, 1, 2, 2, 4, 2, 5, 1, 1, 1, 5, 6, 4, 6, 2, 6, 5, 4, 3, 2, 4, 3];
    String companyUID = 'RhBs9nhOWigeGY8wVUEU';
    String surveyUID = 'Ld8rUlNmsxi7gyn2A5xw';
    Map<String, dynamic> request = {'latestSurveyDocName': '2025-02-20T13-09-06', 'surveyUID': surveyUID, 'emailType': emailType, 'companyUID': companyUID, 'results': results};
    String path = 'http://127.0.0.1:5001/efficiency-1st/us-central1/pushTestResults';

    await HttpService.postRequest(path: path, request: request);
    logger.info('pushing test result $companyUID');
  }
}
