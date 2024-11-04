import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/helperClasses/questionBase.dart';
import 'package:front_survey_questions/helperClasses/questionMultipleChoice.dart';
import 'package:front_survey_questions/helperClasses/questionRating.dart';
import 'package:logging/logging.dart';
import 'package:front_survey_questions/enums.dart';

///Service class interacting with firestore
class FirestoreService {
  final log = Logger("FireStoreService");
  final QuestionsProvider questions;
  FirestoreService({required this.questions});

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Method that reads latest version question doc from firestore
  ///Creates Question object for each q in doc map
  ///Adds Questions to QuestionProvider
  Future<void> getQuestions() async {
    const String collection = 'surveyBuild';
    const String docID = 'v.2024-10-21';

    final ref = _firestore.collection(collection).doc(docID);

    log.info("Calling getQuestion to read questions from fireStore. ref: $ref");
    try {
      final docSnapshot = await ref.get();

      if (!docSnapshot.exists) {
        throw Exception("Document does not exist");
      }

      //Load Star Questions
      int count = 0;
      Map<String, dynamic> starQuestions = docSnapshot.data()!['stars'];
      starQuestions.forEach((key, value) {
        count++;
        questions.addQuestion(QuestionRating(
          text: value['text'] ?? 'Default Text',
          textExtra: value['textInfo'],
          index: value['index'],
          type: QuestionType.rating,
        ));
      });
      log.info("$count Star Questions loaded into QuestionsProvider.");

      //Load Multiple Choice Questions
      count = 0;
      Map<String, dynamic> multipleChoiceQuestions = docSnapshot.data()!['multipleChoice'];
      multipleChoiceQuestions.forEach((key, value) {
        count++;
        questions.addQuestion(Questionmultiplechoice(
          text: value['text'] ?? 'Default Text',
          textExtra: value['textInfo'],
          type: QuestionType.multipleChoice,
          index: value['index'],
          options: value['options'],
        ));
        log.info("$count Multiple choice Questions loaded into QuestionsProvider.");
        log.info("getQuestions from FireStore successful");
        questions.printQuestions();
      });
    } catch (e, stackTrace) {
      questions.setQuestions([
        QuestionRating(
          text: 'There was an error getting the question. Please refresh the browser',
          index: 0,
          type: QuestionType.error,
        )
      ]);
      log.severe("Failed to get Questions from Firestore: $e. Stacktrace: $stackTrace");
    }
  }
}
