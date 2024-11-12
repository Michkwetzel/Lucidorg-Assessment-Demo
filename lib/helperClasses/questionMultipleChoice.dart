import 'package:front_survey_questions/helperClasses/questionBase.dart';

class Questionmultiplechoice extends QuestionBase {
  final List<dynamic> options;

  Questionmultiplechoice({
    required super.textHeading,
    super.textExtra,
    required super.type,
    required super.index,
    required this.options,
  });

  @override
  String toString() {
    return "q$index, Text: $textHeading, TextExtra: $textExtra, Type: $type, Options: $options";
  }
}
