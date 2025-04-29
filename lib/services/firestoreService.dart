import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/helperClasses/questionMultipleChoice.dart';
import 'package:lucid_org/helperClasses/questionRating.dart';
import 'package:logging/logging.dart';
import 'package:lucid_org/enums.dart';

///Service class interacting with firestore
class FirestoreService {
  final log = Logger("FireStoreService");
  final QuestionsProvider questions;
  final SurveyDataProvider surveyDataProvider;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService({required this.questions, required this.surveyDataProvider});

  ///Method that reads latest version question doc from firestore
  ///Creates Question object for each q in doc map
  ///Adds Questions to QuestionProvider
  Future<void> getQuestions() async {
    String collection = 'surveyBuild';
    String docID = 'v.2025-03-26';

    // Check if HR
    if (surveyDataProvider.product == Product.hr) {
      collection = 'surveyBuild_HR';
      docID = 'v.2025-04-16';
    }

    final ref = _firestore.collection(collection).doc(docID);

    log.info("Calling getQuestion to read questions from fireStore. ref: $collection, $docID");
    try {
      final docSnapshot = await ref.get();

      if (!docSnapshot.exists) {
        throw Exception("Document does not exist");
      }

      //Load Multiple Questions
      int count = 0;
      Map<String, dynamic> multipleChoiceQuestions = docSnapshot.data()!['multipleChoice'];
      multipleChoiceQuestions.forEach((key, value) {
        count++;
        questions.addQuestion(Questionmultiplechoice(
          textHeading: value['textHeading'] ?? 'Default Text',
          textExtra: value['textExtra'],
          index: value['index'],
          type: QuestionType.multipleChoice,
        ));
      });
      log.info("$count Multiple choice Questions loaded into QuestionsProvider.");
      questions.sortQuestions();
      log.info("getQuestions from FireStore successful");
    } catch (e, stackTrace) {
      questions.setQuestions([
        QuestionRating(
          textHeading: "This is akward",
          textBody: 'There was an error getting the question. Please refresh the browser',
          index: 0,
          type: QuestionType.error,
        )
      ]);
      log.severe("Failed to get Questions from Firestore: $e. Stacktrace: $stackTrace");
    }
  }

  void addQuestiontoDB() {
    //Used to add questions to DB

    Map<String, Map<String, dynamic>> multipleChoiceQuestions = {
      'q0': {
        'index': 0,
        'textHeading': "Understands the companies vision for growth over the next 2-3 years",
      },
      'q1': {
        'index': 1,
        'textHeading': "Understands the company's strategy to achieve that vision",
      },
      'q2': {
        'index': 2,
        'textHeading': "Has a general understanding of where the company plans to invest its resources (people, time, money), to execute the strategy",
      },
      'q3': {
        'index': 3,
        'textHeading': "Understands where to find the information and support necessary to do their job",
      },
      'q4': {
        'index': 4,
        'textHeading': "Understands the organizational structure",
      },
      'q5': {
        'index': 5,
        'textHeading': "Believes the company structure supports collaboration between teams",
      },
      'q6': {
        'index': 6,
        'textHeading': "Understands how their work impacts the company's execution of its strategy",
      },
      'q7': {
        'index': 7,
        'textHeading': "Understands which company metrics define success for their team",
      },
      'q8': {
        'index': 8,
        'textHeading': "Understands how their work impacts other teams success metrics",
      },
      'q9': {
        'index': 9,
        'textHeading': "Understands the processes for communicating with other teams",
      },
      'q10': {
        'index': 10,
        'textHeading': "Believes communication between teams is clear and effective",
      },
      'q11': {
        'index': 11,
        'textHeading': "Believes that company-wide communication practices support collaboration between teams",
      },
      'q12': {
        'index': 12,
        'textHeading': "Follows through on commitments without shifting blame",
      },
      'q13': {
        'index': 13,
        'textHeading': "Takes responsibility for how their work impacts other teams and their performance",
      },
      'q14': {
        'index': 14,
        'textHeading': "Works collaboratively across teams to achieve company goals",
      },
      'q15': {
        'index': 15,
        'textHeading': "Feels encouraged to openly communicate across the organization",
      },
      'q16': {
        'index': 16,
        'textHeading': "Actively participates in building a positive workplace culture",
      },
      'q17': {
        'index': 17,
        'textHeading': "Feels a sense of belonging within the organization",
      },
      'q18': {
        'index': 18,
        'textHeading': "Understands the processes necessary to collaborate effectively with other teams",
      },
      'q19': {
        'index': 19,
        'textHeading': "Believes that cross-team collaboration processes are designed to support user needs",
      },
      'q20': {
        'index': 20,
        'textHeading': "Believes the company culture encourages improvement of processes to enhance collaboration",
      },
      'q21': {
        'index': 21,
        'textHeading': "Has access to the necessary technology to perform their job effectively",
      },
      'q22': {
        'index': 22,
        'textHeading': "Believes the integration of technology reduces duplicative work and inefficiencies",
      },
      'q23': {
        'index': 23,
        'textHeading': "Believes technology decisions in the company are made with user needs in mind",
      },
      'q24': {
        'index': 24,
        'textHeading': "Believes meetings have clear objectives and outcomes",
      },
      'q25': {
        'index': 25,
        'textHeading': "Believes meetings respect team members' time",
      },
      'q26': {
        'index': 26,
        'textHeading': "Has the opportunity to openly ask questions and provide input in meetings",
      },
      'q27': {
        'index': 27,
        'textHeading': "Feels empowered to take ownership of their role and responsibilities without unnecessary approvals",
      },
      'q28': {
        'index': 28,
        'textHeading': "Has opportunities to develop leadership skills and grow within the organization",
      },
      'q29': {
        'index': 29,
        'textHeading': "Experiences a supportive and autonomous work environment without micromanagement",
      },
      'q30': {
        'index': 30,
        'textHeading': "Understands how their work contributes to the company's purpose",
      },
      'q31': {
        'index': 31,
        'textHeading': "Believes leadership demonstrates the company's purpose in their decisions and actions",
      },
      'q32': {
        'index': 32,
        'textHeading': "Identifies with the organization's purpose",
      },
      'q33': {
        'index': 33,
        'textHeading': "Is actively engaged and committed to the companies success",
      },
      'q34': {
        'index': 34,
        'textHeading': "Feels valued and recognized for their contributions",
      },
      'q35': {
        'index': 35,
        'textHeading': "Works in a way that minimizes wasted time and effort",
      },
      'q36': {
        'index': 36,
        'textHeading': "Believes their workload is manageable, allowing them to be productive without feeling overwhelmed",
      },
    };
  }
}
