import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front_survey_questions/helperClasses/question.dart';

class QuestionList {
  List<Question> questions;

  QuestionList({required this.questions});

  // Convert Firestore document containing multiple questions to QuestionList
  factory QuestionList.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    List<Question> questionsList = [];

    if (data != null) {
      data.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          questionsList.add(Question.fromMap(value));
        }
      });
    }
    return QuestionList(questions: questionsList);
  }

  // Convert QuestionList to Firestore document
  Map<String, dynamic> toFirestore() {
    Map<String, dynamic> questions = {};
    for (var i = 0; i < this.questions.length; i++) {
      questions['question_$i'] = this.questions[i].toFirestore();
    }
    return questions;
  }
}
