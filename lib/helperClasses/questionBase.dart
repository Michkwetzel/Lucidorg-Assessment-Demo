import 'package:lucid_org/enums.dart';

///Base Question Class
///MultipleChoice and Rating inherit from this class.
///Note textExtra can be null
class QuestionBase {
  final String textHeading;
  final String? textExtra;
  final QuestionType type;
  final int index;
  double result;
  bool answered;

  QuestionBase({
    required this.textHeading,
    this.textExtra,
    required this.type,
    required this.index,
    this.result = -1,
    this.answered = false,
  });

  @override
  String toString() {
    return "q$index, Text: $textHeading, TextExtra: $textExtra, Type: $type, Result: $result, Answered: $answered";
  }

  String info() {
    return "q${index}, QuestionType: $type, Result: $result, Answered: $answered";
  }
}
