import 'package:flutter/material.dart';
import 'package:front_survey_questions/helperClasses/results.dart';
import 'package:front_survey_questions/helperClasses/questionBase.dart';
import 'package:front_survey_questions/helperClasses/questionMultipleChoice.dart';
import 'package:front_survey_questions/helperClasses/questionRating.dart';
import 'package:logging/logging.dart';
import 'package:front_survey_questions/components/components.dart';

class QuestionsProvider extends ChangeNotifier {
  final Logger log = Logger('QuestionsProvider');

  QuestionsProvider(this._results);

  // Dependant on results
  Results _results;

  // Private fields
  List<QuestionBase> _questions = [];
  String _topText = '';
  int _currentIndex = -1; //Start at -1 because on first start click needs to load index = 0
  Widget _currentQuestionCard = const Placeholder();

  // Getters
  Widget get currentQuestionCard => _currentQuestionCard;
  String get topText => _topText;
  int get questionLength => _questions.length;
  int get currentIndex => _currentIndex;
  bool get canGoBack => _currentIndex > 0;
  bool get canGoForward => _currentIndex < _questions.length - 1;
  QuestionBase get currentQuestion => _questions[_currentIndex];
  List<QuestionBase> get questions => List.unmodifiable(_questions);

  //Setters
  void setTopText(String text) {
    _topText = text;
    notifyListeners();
  }

  void updateResults(Results results) {
    _results = results;
  }

  void setQuestions(List<QuestionBase> questions) {
    if (questions.isEmpty) {
      log.warning('Attempting to set empty questions list');
      return;
    }
    _questions = questions;
    notifyListeners();
  }

  //Methods
  void addQuestion(QuestionBase question) {
    _questions.add(question);
  }

  void sortQuestions() {
    _questions.sort((a, b) => a.index.compareTo(b.index));
    log.info('QuestionProvider sorted');
  }

  QuestionBase? getQuestion(int index) {
    try {
      return _questions[index];
    } catch (e) {
      log.severe('Failed to get question at index $index: $e');
      return null;
    }
  }

  void printQuestions({int upTo = 5}) {
    for (QuestionBase question in _questions) {
      log.info(question.toString());
    }
  }

  // Method that returns card to be displayed by MainScreen based of currentIndex
  void setCurrentQuestionCard(int index) {
    if (index < 0 || index >= _questions.length) {
      log.severe('Invalid index: $index');
      return;
    }

    final currentQuestion = _questions[index];

    try {
      if (currentQuestion is Questionmultiplechoice) {
        _topText = currentQuestion.text;
        _currentQuestionCard = MultipleChoiceQuestionCard(options: currentQuestion.options);
      } else if (currentQuestion is QuestionRating) {
        _topText = currentQuestion.textHeading;
        _currentQuestionCard = RatingQuestionCard(questionSecondText: currentQuestion.text);
      } else {
        throw UnsupportedError('Unknown question type: ${currentQuestion.runtimeType}');
      }
      notifyListeners();
    } on Exception catch (e) {
      log.severe('Error setting question card: $e');
    }
  }

  void nextQuestion() {
    if (!canGoForward) {
      log.warning('Cannot go to next question: already at last question');
      return;
    }
    _currentIndex++;
    setCurrentQuestionCard(_currentIndex);
  }

  void previousQuestion() {
    if (!canGoBack) {
      log.warning('Cannot go to previous question: already at first question');
      return;
    }
    _currentIndex--;
    setCurrentQuestionCard(_currentIndex);
  }

  void reset() {
    _questions.clear();
    _topText = '';
    _currentIndex = -1;
    _currentQuestionCard = const Placeholder();
    notifyListeners();
  }
}
