import 'package:lucid_org/enums.dart';
import 'package:logging/logging.dart';

final log = Logger("Results");

// Used to store Results. Injected as provider so global instance available
class Results {
  List<Map<String, dynamic>> _resultsList = [];

  List<Map<String, dynamic>> get resultsList => _resultsList;

  void addResult({required QuestionType quesionType, required int questionIndex, required int questionResult}) {
    log.info('Saving result: QIndex: $questionIndex, QType: $quesionType, QResult: $questionResult');
    Map<String, dynamic> resultData = {
      'index': questionIndex,
      'Qtype': quesionType,
      'Qresult': questionResult,
    };

    _resultsList.add(resultData);
    log.info('Results: $_resultsList');
  }

  void updateResult({required QuestionType quesionType, required int questionIndex, required int questionResult}) {
    log.info('Updating result: QIndex: $questionIndex, QType: $quesionType, QResult: $questionResult');
    Map<String, dynamic> resultData = {
      'index': questionIndex,
      'Qtype': quesionType,
      'Qresult': questionResult,
    };

    _resultsList[questionIndex] = resultData;
    log.info('Updated Results: $_resultsList');
  }

  Map<String, dynamic> getResultAtIndex(int index) {
    try {
      if (index < 0 || index >= _resultsList.length) {
        log.severe('Index $index is out of bounds for result list of length ${_resultsList.length}');
        throw RangeError('Index $index is out of bounds for result list.');
      }
      return _resultsList[index];
    } catch (e) {
      log.severe('Error retrieving result at index $index: $e');
      return {};
    }
  }
}
