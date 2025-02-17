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

    emailType = 'ceo';
    results = [4, 4, 3, 3, 3, 3, 2, 3, 1, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 6, 6, 6, 6, 6, 5, 5, 4, 4, 4, 4];

    Map<String, dynamic> request = {'latestSurveyDocName': latestDocname, 'emailType': emailType, 'companyUID': companyUID!, 'surveyUID': surveyToken!, 'results': results};
    String path = ksaveResultsPath;

    await HttpService.postRequest(path: path, request: request);
    logger.info('Saved results to back end for company: $companyUID, surveyToken: $surveyToken');
  }

  Future<void> pushTestResults(String? latestDocname) async {
    //Send companyUID, LastestSurveyDocName and surveyToken to back end so that it can change data
    String emailType = 'employee';
    List<int> results = [5, 5, 3, 5, 3, 3, 5, 5, 4, 5, 5, 5, 5, 5, 5, 3, 3, 5, 3, 5, 4, 4, 5, 5, 4, 6, 5, 6, 4, 6, 6, 6, 6, 6, 4, 4];
    String companyUID = 'testCompany';
    String surveyUID = 'rKMeKf4trPJ3Sopjysy6';
    Map<String, dynamic> request = {'latestSurveyDocName': latestDocname, 'surveyUID': surveyUID, 'emailType': emailType, 'companyUID': companyUID, 'results': results};
    String path = 'http://127.0.0.1:5001/efficiency-1st/us-central1/pushTestResults';

    await HttpService.postRequest(path: path, request: request);
    logger.info('pushing test result $companyUID');
  }
}
