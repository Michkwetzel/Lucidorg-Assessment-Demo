import 'package:front_survey_questions/helperClasses/questionBase.dart';

class QuestionRating extends QuestionBase {
  final String textHeading;
  QuestionRating({
    required this.textHeading,
    required super.text,
    super.textExtra,
    required super.type,
    required super.index,
  });
}
