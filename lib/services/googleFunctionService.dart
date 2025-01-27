import 'package:front_survey_questions/services/httpService.dart';

class GoogleFunctionService {
  String? surveyToken;
  String? companyUID;

  GoogleFunctionService({required this.surveyToken, required this.companyUID});

  Future<void> surveyStarted(String? latestDocname) async {
    //Send companyUID, LastestSurveyDocName and surveyToken to back end so that it can change data
    Map<String, String> request = {'latestSurveyDocName': latestDocname!, 'companyUID': companyUID!, 'surveyUID': surveyToken!};
    String path = 'http://127.0.0.1:5001/efficiency-1st/us-central1/surveyStarted';

    await HttpService.postRequest(path: path, request: request);
  }

  Future<void> saveResults(String? latestDocname, List<int> results) async {
    //Send companyUID, LastestSurveyDocName and surveyToken to back end so that it can change data
    Map<String, dynamic> request = {'latestDocname': latestDocname!, 'companyUID': companyUID!, 'surveyToken': surveyToken!, 'results': results};
    String path = 'http://127.0.0.1:5001/efficiency-1st/us-central1/saveResults';

    await HttpService.postRequest(path: path, request: request);
  }
}
