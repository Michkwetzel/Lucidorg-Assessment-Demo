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
}
