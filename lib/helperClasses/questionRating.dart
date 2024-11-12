import 'package:front_survey_questions/helperClasses/questionBase.dart';

class QuestionRating extends QuestionBase {
  final String textBody;

  QuestionRating({
    required this.textBody,
    required super.textHeading,
    super.textExtra,
    required super.type,
    required super.index,
  });
}
