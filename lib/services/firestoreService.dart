import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front_survey_questions/helperClasses/questionList.dart';

///Singleton, Eager initialized firestoreService class.
///Instance is static and created on code compile.
///One instance used throughout app
///
///Service class with methods that interact with firestore
class FirestoreService {
  FirestoreService._();
  //Create instance
  static final FirestoreService _instance = FirestoreService._();
  //Instance getter
  static FirestoreService get instance => _instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getQuestionsWithConverter() async {
    final ref = _firestore.collection("surveyBuild").doc("v.2024-10-21").withConverter(
          fromFirestore: QuestionList.fromFirestore,
          toFirestore: (QuestionList questionList, _) => questionList.toFirestore(),
        );

    final docSnap = await ref.get();
    final questionList = docSnap.data();

    if (questionList != null) {
      // Now you have access to all your questions as Question objects
      for (var question in questionList.questions) {
        print('Question ${question.index}: ${question.text}');
      }
    } else {
      print("No such document.");
    }

  }
}
