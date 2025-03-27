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
    print(results);

    Map<String, dynamic> request = {'latestSurveyDocName': latestDocname, 'emailType': emailType, 'companyUID': companyUID!, 'surveyUID': surveyToken!, 'results': results};
    String path = ksaveResultsPath;

    await HttpService.postRequest(path: path, request: request);
    logger.info('Saved results to back end for company: $companyUID, surveyToken: $surveyToken');
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
    logger.info('pushing test result $companyUID');
  }
}
