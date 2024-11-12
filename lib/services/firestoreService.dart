import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
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
    const String docID = 'v.2024-11-12';

    final ref = _firestore.collection(collection).doc(docID);

    log.info("Calling getQuestion to read questions from fireStore. ref: $ref");
    try {
      final docSnapshot = await ref.get();

      if (!docSnapshot.exists) {
        throw Exception("Document does not exist");
      }

      //Load Star Questions
      int count = 0;
      Map<String, dynamic> ratingQuestions = docSnapshot.data()!['rating'];
      ratingQuestions.forEach((key, value) {
        count++;
        questions.addQuestion(QuestionRating(
          textHeading: value['textHeading'] ?? 'Default Text',
          textBody: value['textBody'] ?? 'Default Text',
          textExtra: value['textExtra'],
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
          textHeading: value['textHeading'] ?? 'Default Text',
          textExtra: value['textExtra'],
          options: value['options'],
          index: value['index'],
          type: QuestionType.multipleChoice,
        ));
      });
      log.info("$count Multiple choice Questions loaded into QuestionsProvider.");
      questions.sortQuestions();
      questions.printQuestions();
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

    Map<String, Map<String, dynamic>> ratingQuestions = {
      'q1': {
        'index': 1,
        'textHeading': 'Everyone in Test Company ...',
        'textBody': 'knows and understands the company\'s purpose, mission, vision and values.',
        'textExtra': 'Purpose defines why a company exists, while mission defines what the company does, vision defines where it wants to go and values define how it operates.',
      },
      'q2': {
        'index': 2,
        'textHeading': 'Everyone in Test Company ...',
        'textBody': 'knows the growth path over the next 2 years including budgets, goals and milestones.',
        'textExtra':
            'Growth path defines where the company should be in the next 2 years as well as milestones, budgets and focus areas. This allows employees to understand why the company is making decisions to achieve long term growth.'
      },
      'q3': {
        'index': 3,
        'textHeading': 'Everyone in Test Company ...',
        'textBody': 'knows the department structure, whom to go to for questions and whom to work with cross-functionally to solve problems.',
        'textExtra': 'Cross-functional work defines how different departments work together to achieve company goals.'
      },
      'q4': {
        'index': 4,
        'textHeading': 'Everyone in Test Company ...',
        'textBody': 'tracks collaborative KPIs, surfaces them, drives action from them and everyone understands which departments are involved with each KPI.',
        'textExtra':
            'Collaborative KPI\'s clearly define how every department affects a KPI. When employees understand how their work impacts a specific metric, each role feels more ownership in the success of a company.',
      },
      'q5': {
        'index': 5,
        'textHeading': 'Everyone in Test Company ...',
        'textBody': 'has cross-functional team leaders assigned to ensuring departments and people are all working towards the same goals.',
      },
      'q6': {
        'index': 6,
        'textHeading': 'Test Company ...',
        'textBody': 'fosters a culture of open communication and collaboration, contributing to employee engagement and productivity.',
      },
      'q7': {
        'index': 7,
        'textHeading': 'Test Company ...',
        'textBody': 'provides learning and development opportunities for employees to advance and develop their skills within the organization.',
      },
      'q8': {
        'index': 8,
        'textHeading': 'Test Company ...',
        'textBody': 'provides an outline of all departmental roles and responsibilities across the company and trains all new hires, team leads, and leaders on roles & responsibilities.',
      },
      'q9': {
        'index': 9,
        'textHeading': 'Test Company ...',
        'textBody': 'has communication channels in place for employees to share ideas and concerns.',
      },
      'q10': {
        'index': 10,
        'textHeading': 'Test Company ...',
        'textBody': 'sets aside budget, time, and leadership to drive engagement across the entire company.',
      },
      'q11': {
        'index': 11,
        'textHeading': 'Test Company and it\'s leadership team ...',
        'textBody': 'Efficiently distributes information to create a culture of cross-collaborative decision-making.',
        'textExtra': 'Cross-collaborative decision-making defines how different people from different departments work together to achieve the companies goals.',
      },
      'q12': {
        'index': 12,
        'textHeading': 'Test Company and it\'s leadership team ...',
        'textBody': 'Includes cross-functional teams to drive the decision and implementation of technology systems and usage across the company.',
      },
      'q13': {
        'index': 13,
        'textHeading': 'Test Company and it\'s leadership team ...',
        'textBody': 'Provides clearly defined processes and technology to support employee productivity and engagement.',
      },
      'q14': {
        'index': 14,
        'textHeading': 'Test Company and it\'s leadership team ...',
        'textBody': 'Has a forward-looking tech strategy in place to support current operations and support scale without creating tech-debt.',
      },
      'q15': {
        'index': 15,
        'textHeading': 'Test Company and it\'s leadership team ...',
        'textBody': 'Runs and organizes meetings efficiently with clear agendas, goals and outcomes.',
      },
      'q16': {
        'index': 16,
        'textHeading': 'Test Company ...',
        'textBody': 'Has the right leaders, in the right roles that drive a culture of  leadership development with all staff.',
        'textExtra': 'Leadership is a function of motivating people to learn and develop into leaders themselves, while at the same time supporting employee success and learning.'
      },
      'q17': {
        'index': 17,
        'textHeading': 'Test Company ...',
        'textBody': 'Drives a culture of reverse accountability (staff holding leaders accountable) and provides a system for anonymous structured feedback.',
      },
      'q18': {
        'index': 18,
        'textHeading': 'Test Company ...',
        'textBody': 'Has continuous cross-functional leadership training for all executives, department leads and anyone leading people in the organization.',
      },
      'q19': {
        'index': 19,
        'textHeading': 'Test Company ...',
        'textBody': 'Has moved away from a hierarchical management structure to an autonomous leadership and department structure where management time is reduced and decisions are driven by data.',
      },
      'q20': {
        'index': 20,
        'textHeading': 'Test Company ...',
        'textBody': 'Has a culture of accountable, autonomous leadership with an understanding of the difference of management and leadership.',
      },
      'q21': {
        'index': 21,
        'textHeading': 'Test Company ...',
        'textBody': 'Is committed to creating a healthy, motivational, and learning-oriented workplace.',
      },
      'q22': {
        'index': 22,
        'textHeading': 'Test Company ...',
        'textBody': 'Is committed to customer satisfaction and understands that employee satisfaction directly affects customer success.',
      },
      'q23': {
        'index': 23,
        'textHeading': 'Test Company ...',
        'textBody': 'Is innovative and prepared to be able to adapt to market changes quickly.',
      },
      'q24': {
        'index': 24,
        'textHeading': 'Test Company ...',
        'textBody': 'Is readily prepared to scale efficiently with little organizational friction.',
      },
      'q25': {
        'index': 25,
        'textHeading': 'Test Company ...',
        'textBody': 'has systems in place to support and reward employees who uphold company values and take action against employees who don\'t support the values.',
      },
    };

    Map<String, Map<String, dynamic>> multipleChoiceQuestions = {
      'q26': {
        'index': 26,
        'textHeading': 'What is the state of purpose at Test Company?',
        'options': [
          'The company has a mission and vision but lacks a clear purpose.',
          'The company has a defined purpose, but it\'s not well-communicated or understood by many.',
          'While a company purpose exists, only a few teams and individuals resonate with it.',
          'Some people and teams align with the company\'s purpose; others remain detached.',
          'A majority of people and teams actively incorporate the company\'s purpose in their daily operations.',
          'The company\'s purpose is deeply ingrained and consistently aligned throughout the entire organization.',
        ],
        'textExtra': 'Purpose defines why a company exists, while mission defines what the company does, vision defines where it wants to go and values define how it operates.',
      },
      'q27': {
        'index': 27,
        'textHeading': 'What is the current state of Test Company\'s growth strategy?',
        'options': [
          'The company lacks a clear growth strategy, leading to disjointed and inconsistent efforts.',
          'A foundational growth strategy is in place but remains vague to many.',
          'A growth strategy exists but isn\'t uniformly understood or communicated across the company.',
          'Some people and departments are aligned with the growth strategy, while others are still out of the loop.',
          'Most people and departments actively align and operate based on the company\'s growth strategy.',
          'The entire company, from top to bottom, is fully aligned to and actively supports the growth strategy.',
        ],
        'textExtra': 'The growth path defines where the company should be in the next 2 years and milestones, budgets, and focus areas.',
      },
      'q28': {
        'index': 28,
        'textHeading': 'How aligned is Test Company\'s org structure?',
        'options': [
          'The organizational structure is unclear to most, causing role confusion',
          'Basic organizational structure exists and is communicated, but many are unsure who to approach',
          'Some understand the organizational structure, but ambiguity remains for others',
          'Most know the organizational structure, but some areas still cause confusion',
          'The majority understand the organizational structure, aiding communication',
          'Everyone knows the organizational structure and whom to approach',
        ],
      },
      'q29': {
        'index': 29,
        'textHeading': 'How collaborative & aligned are Test Company\'s processes?',
        'options': [
          'The company has few defined collaborative processes.',
          'Basic collaborating processes are in place but are misaligned.',
          'Some departments follow collaborating processes, but overall alignment is lacking.',
          'The majority of collaborative processes are defined and cater to employees\' needs.',
          'Collaborative processes are defined and aligned, being used and continually tuning.',
          'Collaborating processes are optimized and refined for peak efficiency.',
        ],
      },
      'q30': {
        'index': 30,
        'textHeading': 'Does Test Company track collaborative KPI\'s?',
        'options': [
          'The company lacks collaborative KPIs, leading to unstructured decisions.',
          'Preliminary KPIs have been introduced, but their adoption is not standardized.',
          'Some KPIs exist, but they aren' 't used or updated consistently throughout the organization.',
          'Some people and departments are aligned with collaborative KPIs, while others continue to operate in silos.',
          'A large part of the organization utilizes collaborative KPIs, driving more structured decision-making.',
          'Every individual and department fully adopts and integrates collaborative KPIs, ensuring seamless collaboration across the company.',
        ],
        'textExtra':
            'Collaborative KPIs clearly define how every department affects a KPI. When employees understand how their work impacts a specific metric, each role feels more ownership in the success of a company.',
      },
    };
    _firestore.collection('surveyBuild').doc('v.2024-11-12').set({
      'rating': ratingQuestions,
      'multipleChoice': multipleChoiceQuestions,
    });
  }
}
