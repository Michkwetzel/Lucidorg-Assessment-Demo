import 'package:lucid_org/helperClasses/questionBase.dart';

class Questionmultiplechoice extends QuestionBase {
  final List<dynamic> options;

  Questionmultiplechoice({
    required super.textHeading,
    super.textExtra,
    required super.type,
    required super.index,
    this.options = const [
      'Strongly agree',
      'Agree',
      'Slightly agree',
      'Neither agree nor disagree',
      'Slightly disagree',
      'Disagree',
      'Strongly disagree',
    ],
  });

  @override
  String toString() {
    return "q$index, Text: $textHeading, TextExtra: $textExtra, Type: $type, Options: $options";
  }
}
