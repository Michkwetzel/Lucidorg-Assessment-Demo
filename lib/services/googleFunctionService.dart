import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/constants.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/services/httpService.dart';
import 'package:logging/logging.dart';

class GoogleFunctionService {
  final SurveyDataProvider surveyDataProvider;
  Logger logger = Logger('GoogleFunctionService');

  GoogleFunctionService({required this.surveyDataProvider});

  Future<void> surveyStarted() async {
    //Send companyUID, LastestSurveyDocName and surveyToken to back end so that it can change data
    if (surveyDataProvider.surveyStarted) {
      logger.info('Already started');
      return;
    }
    Map<String, String> request = {'latestSurveyDocName': surveyDataProvider.latestDocname!, 'companyUID': surveyDataProvider.companyUID!, 'surveyUID': surveyDataProvider.surveyUID!};
    String path = kSurveyStartedPath;

    await HttpService.postRequest(path: path, request: request);
    surveyDataProvider.setSurveyStartedTrue();
    logger.info('Survey Started for company: ${surveyDataProvider.companyUID}, surveyToken: ${surveyDataProvider.surveyUID}');
  }

  Future<void> saveResults(List<int> results) async {
    //Send companyUID, LastestSurveyDocName and surveyToken to back end
    Map<String, dynamic> request = {};
    String path = '';

    if (surveyDataProvider.product == Product.hr) {
      request = {
        'jobSearchUID': surveyDataProvider.jobSearchUID,
        'companyUID': surveyDataProvider.companyUID!,
        'surveyUID': surveyDataProvider.surveyUID!,
        'results': results,
      };
      path = ksaveResultsPath_HR;
    } else {
      request = {
        'latestSurveyDocName': surveyDataProvider.latestDocname,
        'emailType': surveyDataProvider.emailType,
        'companyUID': surveyDataProvider.companyUID!,
        'surveyUID': surveyDataProvider.surveyUID!,
        'results': results
      };
      path = ksaveResultsPath;
    }

    await HttpService.postRequest(path: path, request: request);
    logger.info('Saved results to back end for company: ${surveyDataProvider.companyUID}, surveyToken: ${surveyDataProvider.surveyUID}, product: ${surveyDataProvider.product}');
  }

  Future<void> addNewQuestionsCall() async {
    await HttpService.postRequest(path: kupdateNewSurveyQuestionsPath, request: {'product': 'HR'});
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
