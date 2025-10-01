import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lucid_org/exceptions.dart';

class Firestoreservice {
  static late final FirebaseFirestore _instance;

  static void initialize() {
    _instance = FirebaseFirestore.instanceFor(
      app: Firebase.app(),
      databaseId: 'platform-v2',
    );
    _instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
  }

  static FirebaseFirestore get instance => _instance;

  static Future<Map<String, dynamic>> getAssessmentData(String docId) async {
    final docRef = await _instance.collection('assessment_status').doc(docId).get();
    if (docRef.exists && docRef.data() != null) {
      return docRef.data()!;
    } else {
      throw InvalidSurveyTokenException();
    }
  }

  static Future<Map<String, dynamic>> getQuestions() async {
    final docRef = await _instance.collection('questions').doc('v.2025-08-22').get();
    if (docRef.exists && docRef.data() != null) {
      return docRef.data()!;
    } else {
      throw SurveyException("We made a mistake. Please click on the link in the email again", "Our deepest apologies");
    }
  }
}
