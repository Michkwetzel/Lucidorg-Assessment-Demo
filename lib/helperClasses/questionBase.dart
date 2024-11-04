import 'package:front_survey_questions/enums.dart';

///Base Question Class 
///MultipleChoice and Rating inherit from this class.
///Note textExtra can be null
class QuestionBase {
  final String text;
  final String? textExtra;
  final QuestionType type;
  final int index;

  QuestionBase({
    required this.text,
    this.textExtra,
    required this.type,
    required this.index,
  });

  @override
  String toString() {
    return "q$index, Text: $text, TextExtra: $textExtra, Type: $type";
  }
}
