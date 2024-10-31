import 'package:flutter/foundation.dart';
import 'package:front_survey_questions/helperClasses/questionBase.dart';
import 'package:logging/logging.dart';
import 'package:front_survey_questions/enums.dart';

class QuestionsProvider extends ChangeNotifier {
  final log = Logger('QuestionsProvider');
  List<QuestionBase> _questions = [];

  List<QuestionBase> getQuestions() {
    return _questions;
  }

  void setQuestions(List<QuestionBase> questions) {
    _questions = questions;
  }

  void addQuestion(QuestionBase question) {
    _questions.add(question);
  }

  void sortQuestions() {
    _questions.sort((a, b) => a.index.compareTo(b.index));
    log.info('QuestionProvider sorted');
  }

  QuestionBase getQuestion(int index) {
    if (index >= 0 && index < _questions.length) {
      return _questions[index];
    } else {
      log.severe("getQuestion failed to return a question at index $index");
      return QuestionBase(text: '', textExtra: '', type: QuestionType.stars, index: 0);
    }
  }

  void printQuestions({int upTo = 5}){
    for (QuestionBase question in _questions){
      log.info(question.toString());
    }
  }
}
