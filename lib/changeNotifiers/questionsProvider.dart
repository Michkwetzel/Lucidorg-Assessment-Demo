import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/radioButtonsState.dart';
import 'package:front_survey_questions/changeNotifiers/ratingBarState.dart';
import 'package:front_survey_questions/enums.dart';
import 'package:front_survey_questions/helperClasses/questionBase.dart';
import 'package:front_survey_questions/helperClasses/questionMultipleChoice.dart';
import 'package:front_survey_questions/helperClasses/questionRating.dart';
import 'package:logging/logging.dart';
import 'package:front_survey_questions/components/components.dart';

class QuestionsProvider extends ChangeNotifier {
  final Logger log = Logger('QuestionsProvider');
  Ratingbarstate ratingBarState;
  RadioButtonState radioButtonState;

  QuestionsProvider({required this.ratingBarState, required this.radioButtonState});

  // Private fields
  List<QuestionBase> _questions = [];
  String _textHeading = '';
  int _currentIndex = -1; //Start at -1 because on first start click needs to load index = 0
  double _ratingInitialState = 3;
  int _radioInitialState = -1;
  Widget _currentQuestionCard = const Placeholder();
  bool _showExtraText = false;

  // Getters
  Widget get currentQuestionCard => _currentQuestionCard;
  String get textHeading => _textHeading;
  double get ratingInitialState => _ratingInitialState;
  int get radioInitialState => _radioInitialState;
  int get questionLength => _questions.length;
  int get currentIndex => _currentIndex;
  bool get canGoBack => _currentIndex > 0;
  bool get canGoForward => _currentIndex < _questions.length - 1;
  QuestionBase get currentQuestion => _questions[_currentIndex];
  QuestionType get currentQuestionType => currentQuestion.type;
  bool get hasExtraText => currentQuestion.textExtra != null;
  String get extraText => currentQuestion.textExtra ?? '';
  List<QuestionBase> get questions => List.unmodifiable(_questions);

  //Setters
  void setTopText(String text) {
    _textHeading = text;
    notifyListeners();
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

  void printQuestions() {
    for (QuestionBase question in _questions) {
      log.info(question.info());
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
        _textHeading = currentQuestion.textHeading;
        _currentQuestionCard = MultipleChoiceQuestionCard(
          options: currentQuestion.options,
        );
        if (currentQuestion.answered) {
          _radioInitialState = currentQuestion.result.toInt();
          radioButtonState.onRadioButtonSelected(currentQuestion.result.toInt());
        } else {
          _radioInitialState = -1;
          radioButtonState.onRadioButtonSelected(-1);
        }
      } else if (currentQuestion is QuestionRating) {
        _textHeading = currentQuestion.textHeading;
        _currentQuestionCard = RatingQuestionCard(questionBody: currentQuestion.textBody, hasExtraText: hasExtraText, extraText: extraText);
        if (currentQuestion.answered) {
          print(currentQuestion.result.toInt());
          _ratingInitialState = currentQuestion.result;
          ratingBarState.setRating(currentQuestion.result);
          print(_ratingInitialState);
        } else {
          _ratingInitialState = 3;
          ratingBarState.setRating(3);
        }
      } else {
        throw UnsupportedError('Unknown question type: ${currentQuestion.runtimeType}');
      }
      notifyListeners();
    } on Exception catch (e) {
      log.severe('Error setting question card: $e');
    }
  }

  void saveResult(double result) {
    // If result -1 then it is first card.
    if (result == -1) {
      return;
    }
    QuestionBase currentQuestion = _questions[_currentIndex];
    log.info('Saving result ListIndex: $_currentIndex, Q${currentQuestion.index} Result: $result');

    currentQuestion.result = result;
    currentQuestion.answered = true;
  }

  void nextQuestion(double result) {
    if (!canGoForward) {
      log.warning('Cannot go to next question: already at last question');
      return;
    }
    saveResult(result);
    _currentIndex++;
    setCurrentQuestionCard(_currentIndex);
    log.info('Displayd next Card - ListIndex $_currentIndex, Q${currentQuestion.index}, answered: ${currentQuestion.answered}, Result ${currentQuestion.result}');
  }

  void previousQuestion() {
    if (!canGoBack) {
      log.warning('Cannot go to previous question: already at first question');
      return;
    }

    _currentIndex--;
    ratingBarState.resetRating();
    setCurrentQuestionCard(_currentIndex);
    log.info('Displayd next Card - Q$_currentIndex, Asnwered: ${currentQuestion.answered}, Result ${currentQuestion.result}');
  }

  void reset() {
    //_questions.clear();
    _textHeading = '';
    _currentIndex = -1;
    _currentQuestionCard = const Placeholder();
    //notifyListeners();
  }
}
