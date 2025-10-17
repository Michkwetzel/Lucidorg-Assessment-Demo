import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/services/firestoreService.dart';
import 'package:lucid_org/helperClasses/questionMultipleChoice.dart';
import 'package:logging/logging.dart';

class WelcomeScreenProvider extends ChangeNotifier {
  bool _isLoading = true;
  bool _error = false;
  String _errorText = '';
  String _loadingText = "Validating Assessment";

  final Logger _logger = Logger('WelcomeScreenProvider');

  bool get isLoading => _isLoading;
  bool get hasError => _error;
  String get errorText => _errorText;
  String get loadingText => _loadingText;

  Future<void> initialize(
    SurveyDataProvider surveyDataProvider,
    QuestionsProvider questionsProvider,
  ) async {
    _updateLoadingText("Loading Survey");

    try {
      // First Check tokens and get current Assessment DocName
      await surveyDataProvider.init();

      // Get Questions
      final questions = await Firestoreservice.getQuestions();
      if (questions.isNotEmpty) {
        // Properly cast the nested map structure
        Map<String, Map<String, dynamic>> multipleChoiceQuestions =
          questions.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value as Map)));

        int count = 0;

        multipleChoiceQuestions.forEach((key, value) {
          count++;
          questionsProvider.addQuestion(Questionmultiplechoice(
            textHeading: value['textHeading'] ?? 'Default Text',
            index: value['index'],
            type: QuestionType.multipleChoice,
          ));
        });

        _logger.info("$count Multiple choice Questions loaded into QuestionsProvider.");
        questionsProvider.sortQuestions();
        _logger.info("getQuestions successful");
      } else {
        throw SurveyException(
          'There was an error getting the questions. Please click the link again',
          'Configuration Error'
        );
      }

      // Done Loading
      _setLoading(false);
    } on SurveyException catch (e) {
      _handleError(e.message);
    } catch (e) {
      _logger.severe('Unexpected Error: $e');
      _handleError("Unexpected Error");
    }
  }

  void _updateLoadingText(String text) {
    _loadingText = text;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _handleError(String message) {
    _error = true;
    _errorText = message;
    _isLoading = false;
    notifyListeners();
  }

  void reset() {
    _isLoading = true;
    _error = false;
    _errorText = '';
    _loadingText = "Validating Assessment";
    notifyListeners();
  }
}
