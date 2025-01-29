import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/exceptions.dart';
import 'package:front_survey_questions/helperClasses/questionMultipleChoice.dart';
import 'package:front_survey_questions/helperClasses/questionRating.dart';
import 'package:logging/logging.dart';
import 'package:front_survey_questions/enums.dart';

///Service class interacting with firestore
class FirestoreService {
  final log = Logger("FireStoreService");
  final QuestionsProvider questions;
  final String? surveyToken;
  final String? companyUID;
  DocumentReference<Map<String, dynamic>>? resultsDocRef;
  String? latestSurveyDocName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirestoreService({required this.questions, required this.surveyToken, required this.companyUID});

  ///Method that reads latest version question doc from firestore
  ///Creates Question object for each q in doc map
  ///Adds Questions to QuestionProvider
  Future<void> getQuestions(String companyName) async {
    const String collection = 'surveyBuild';
    const String docID = 'v.2024-12-28';

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
        String? newHeading = value['textHeading'].replaceAll('Test Company', companyName);
        questions.addQuestion(QuestionRating(
          textHeading: newHeading ?? 'Default Text',
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
        String? newHeading = value['textHeading'].replaceAll('Test Company', companyName);
        questions.addQuestion(Questionmultiplechoice(
          textHeading: newHeading ?? 'Default Text',
          textExtra: value['textExtra'],
          options: value['options'],
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

  Future<void> saveResults(List<int> results) async {
    // Turn result list into Map with qNUmbers
    Map<String, int> resultsMap = {};
    for (int i = 0; i < results.length; i++) {
      int qNumber = i + 1;
      resultsMap['q$qNumber'] = results[i];
    }

    resultsDocRef?.update({'results': resultsMap, 'finished': true});
  }

  Future<String?> checkTokens() async {
    if (surveyToken == 'test') {
      print("not here");
      return null;
    }
    if (surveyToken == null || companyUID == null) {
      //Check if token exists. if not. error
      throw MissingTokenException();
    }
    // Now check if tokens are valid. firstly companyUID exists.
    final docCompanyUIDSnapshot = await _firestore.collection('surveyData').doc(companyUID).get();
    if (!docCompanyUIDSnapshot.exists) {
      throw CompanyNotFoundException();
    }

    await getCurrentSurveyDocName(docCompanyUIDSnapshot);

    resultsDocRef = _firestore.collection('surveyData/$companyUID/$latestSurveyDocName/results/data').doc(surveyToken); //Get the results document where results should be saved in
    final docSurveyResultSnapshot = await resultsDocRef?.get();
    if (docSurveyResultSnapshot == null || !docSurveyResultSnapshot.exists) {
      throw InvalidSurveyTokenException();
    }

    //Lastly if all good up to here. Then tokens are correct. Now check if alraedy started.

    if (docSurveyResultSnapshot.data()?['finished'] == true) {
      throw SurveyAlreadyCompletedException();
    }

    return latestSurveyDocName;
  }

  Future<void> getCurrentSurveyDocName(var docCompanyUIDSnapshot) async {
    //Get the current assessment. It will be the latest doc.
    try {
      latestSurveyDocName = docCompanyUIDSnapshot.data()?['latestSurvey']; //Get latest survey
      if (latestSurveyDocName == null) {
        throw NoActiveSurveyException();
      }
    } on Exception catch (e) {
      if (e is SurveyException) {
        rethrow;
      }
      log.severe('Error setting up Survey $e');
      throw SurveyException('An unexpected error occurred while setting up the survey', 'Setup Error');
    }
  }

  Future<String?> getCompanyName() async {
    final docsnapshot = await _firestore.collection('surveyData').doc(companyUID).get();
    final Map<String, dynamic> companyInfo = docsnapshot.data()!['companyInfo'];
    final companyName = companyInfo['companyName'];
    print(companyName);
    return companyName;
  }

  void addQuestiontoDB() {
    //Used to add questions to DB

    Map<String, Map<String, dynamic>> ratingQuestions = {
      'q0': {
        'index': 0,
        'textHeading': 'Everyone in []...',
        'textBody': 'knows and understands the company\'s purpose, mission, vision and values.',
        'textExtra': 'Purpose defines why a company exists, while mission defines what the company does, vision defines where it wants to go and values define how it operates.',
      },
      'q1': {
        'index': 1,
        'textHeading': 'Everyone in []...',
        'textBody': 'knows the growth path over the next 2 years including budgets, goals and milestones.',
        'textExtra':
            'Growth path defines where the company should be in the next 2 years as well as milestones, budgets and focus areas. This allows employees to understand why the company is making decisions to achieve long term growth.'
      },
      'q2': {
        'index': 2,
        'textHeading': 'Everyone in []...',
        'textBody': 'knows the department structure, whom to go to for questions and whom to work with cross-functionally to solve problems.',
        'textExtra': 'Cross-functional work defines how different departments work together to achieve company goals.'
      },
      'q3': {
        'index': 3,
        'textHeading': 'Everyone in []...',
        'textBody': 'tracks collaborative KPIs, surfaces them, drives action from them and everyone understands which departments are involved with each KPI.',
        'textExtra':
            'Collaborative KPI\'s clearly define how every department affects a KPI. When employees understand how their work impacts a specific metric, each role feels more ownership in the success of a company.',
      },
      'q4': {
        'index': 4,
        'textHeading': 'Everyone in []...',
        'textBody': 'has cross-functional team leaders assigned to ensuring departments and people are all working towards the same goals.',
      },
      'q5': {
        'index': 5,
        'textHeading': '[]...',
        'textBody': 'fosters a culture of open communication and collaboration, contributing to employee engagement and productivity.',
      },
      'q6': {
        'index': 6,
        'textHeading': '[]]...',
        'textBody': 'provides learning and development opportunities for employees to advance and develop their skills within the organization.',
      },
      'q7': {
        'index': 7,
        'textHeading': '[]...',
        'textBody': 'provides an outline of all departmental roles and responsibilities across the company and trains all new hires, team leads, and leaders on roles & responsibilities.',
      },
      'q8': {
        'index': 8,
        'textHeading': '[]...',
        'textBody': 'has communication channels in place for employees to share ideas and concerns.',
      },
      'q9': {
        'index': 9,
        'textHeading': '[]...',
        'textBody': 'sets aside budget, time, and leadership to drive engagement across the entire company.',
      },
      'q10': {
        'index': 10,
        'textHeading': '[] and it\'s leadership team...',
        'textBody': 'Efficiently distributes information to create a culture of cross-collaborative decision-making.',
        'textExtra': 'Cross-collaborative decision-making defines how different people from different departments work together to achieve the companies goals.',
      },
      'q11': {
        'index': 11,
        'textHeading': '[] and it\'s leadership team...',
        'textBody': 'Includes cross-functional teams to drive the decision and implementation of technology systems and usage across the company.',
      },
      'q12': {
        'index': 12,
        'textHeading': '[] and it\'s leadership team...',
        'textBody': 'Provides understanbily  defined processes and technology to support employee productivity and engagement.',
      },
      'q13': {
        'index': 13,
        'textHeading': '[] and it\'s leadership team...',
        'textBody': 'Has a forward-looking tech strategy in place to support current operations and support scale without creating tech-debt.',
      },
      'q14': {
        'index': 14,
        'textHeading': '[] and it\'s leadership team...',
        'textBody': 'Runs and organizes meetings efficiently with clear agendas, goals and outcomes.',
      },
      'q15': {
        'index': 15,
        'textHeading': '[]...',
        'textBody': 'Has the right leaders, in the right roles that drive a culture of  leadership development with all staff.',
        'textExtra': 'Leadership is a function of motivating people to learn and develop into leaders themselves, while at the same time supporting employee success and learning.'
      },
      'q16': {
        'index': 16,
        'textHeading': '[]...',
        'textBody': 'Drives a culture of reverse accountability (staff holding leaders accountable) and provides a system for anonymous structured feedback.',
      },
      'q17': {
        'index': 17,
        'textHeading': '[]...',
        'textBody': 'Has continuous cross-functional leadership training for all executives, department leads and anyone leading people in the organization.',
      },
      'q18': {
        'index': 18,
        'textHeading': '[]...',
        'textBody': 'Has moved away from a hierarchical management structure to an autonomous leadership and department structure where management time is reduced and decisions are driven by data.',
      },
      'q19': {
        'index': 19,
        'textHeading': '[]...',
        'textBody': 'Has a culture of accountable, autonomous leadership with an understanding of the difference of management and leadership.',
      },
      'q20': {
        'index': 20,
        'textHeading': '[]...',
        'textBody': 'Is committed to creating a healthy, motivational, and learning-oriented workplace.',
      },
      'q21': {
        'index': 21,
        'textHeading': '[]...',
        'textBody': 'Is committed to customer satisfaction and understands that employee satisfaction directly affects customer success.',
      },
      'q22': {
        'index': 22,
        'textHeading': '[]...',
        'textBody': 'Is innovative and prepared to be able to adapt to market changes quickly.',
      },
      'q23': {
        'index': 23,
        'textHeading': '[]...',
        'textBody': 'Is readily prepared to scale efficiently with little organizational friction.',
      },
      'q24': {
        'index': 24,
        'textHeading': '[]...',
        'textBody': 'has systems in place to support and reward employees who uphold company values and take action against employees who don\'t support the values.',
      },
    };

    Map<String, Map<String, dynamic>> multipleChoiceQuestions = {
      'q25': {
        'index': 25,
        'textHeading': 'What is the state of purpose at []?',
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
      'q26': {
        'index': 26,
        'textHeading': 'What is the current state of []\'s growth strategy?',
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
      'q27': {
        'index': 27,
        'textHeading': 'How aligned is []\'s org structure?',
        'options': [
          'The organizational structure is unclear to most, causing role confusion',
          'Basic organizational structure exists and is communicated, but many are unsure who to approach',
          'Some understand the organizational structure, but ambiguity remains for others',
          'Most know the organizational structure, but some areas still cause confusion',
          'The majority understand the organizational structure, aiding communication',
          'Everyone knows the organizational structure and whom to approach',
        ],
      },
      'q28': {
        'index': 28,
        'textHeading': 'How collaborative & aligned are []\'s processes?',
        'options': [
          'The company has few defined collaborative processes.',
          'Basic collaborating processes are in place but are misaligned.',
          'Some departments follow collaborating processes, but overall alignment is lacking.',
          'The majority of collaborative processes are defined and cater to employees\' needs.',
          'Collaborative processes are defined and aligned, being used and continually tuning.',
          'Collaborating processes are optimized and refined for peak efficiency.',
        ],
      },
      'q29': {
        'index': 29,
        'textHeading': 'Does [] track collaborative KPI\'s?',
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
      'q30': {
        'index': 30,
        'textHeading': 'Describe the alignment of []\'s tech stack.',
        'options': [
          'The company lacks a clear long/mid-term aligned technology strategy, leading to many fragmented efforts.',
          'There\'s a technology strategy in place, but it\'s isolated and not universally understood or integrated.',
          'Some departments are guided by a technology strategy primarily laid out by IT, but there\'s a noticeable disconnect across the organization.',
          'Many departments, not just IT, participate in formulating a unified technology approach, but pockets of disengagement remain.',
          'A significant part of the company actively collaborates on and supports the evolving technology strategy, enhancing system engagement.',
          'The company\'s technology strategy is distinctly articulated, and garners universal support and active engagement.',
        ],
      },
      'q31': {
        'index': 31,
        'textHeading': 'Does [] have cross-functional communication.',
        'options': [
          'The company has minimal cross-functional collaborative communication.',
          'Initial attempts at cross-functional communication exist but lack consistency.',
          'Some teams engage in cross-functional collaboration, but there are still noticeable gaps and silos.',
          'A broader base of teams are now adopting collaborative communication, improving alignment.',
          'Collaborative communication is well-established, leading to more cohesive interdepartmental relations.',
          'The entire company operates under a clear strategy that champions seamless cross-functional collaborative communication.',
        ],
        'textExtra': 'Cross-functional communication defines how different departments work together to achieve company goals.',
      },
      'q32': {
        'index': 32,
        'textHeading': 'Describe the state of autonomy & purpouse led leadership at [].',
        'options': [
          'Leadership decision-making is centralized with almost no autonomy.',
          'Limited autonomy is present, but the majority of decisions are by top leaders.',
          'A balance exists: some leaders make autonomous decisions while others consult occasionally.',
          'Growing autonomy in decision-making, guided by KPIs with occasional cross-functional input exists.',
          'Decision-making is largely autonomous, frequently influenced by KPIs and regular cross-functional discussions.',
          'Leadership decisions are fully autonomous, driven by perfectly aligned KPIs and continuous cross-functional collaboration.',
        ],
      },
      'q33': {
        'index': 33,
        'textHeading': 'Describe the community at [].',
        'options': [
          'The organization lacks a sense of community, resulting in detachment among members.',
          'There are some efforts towards community-building, but they are sporadic and lack widespread adoption.',
          'Some individuals and departments have taken the initiative in community engagement, yet many remain unengaged.',
          'A more cohesive sense of community is evident, with many benefiting from these connections, backed by leadership.',
          'A significant majority of the organization operates under an evolving community, with clear leadership endorsement.',
          'The organization is united under a robust, budgeted community strategy, endorsed by both the leadership and members.',
        ],
        'textExtra': 'Community defines how a company\'s employees, leadership (and sometimes clients) work together. '
      },
      'q34': {
        'index': 34,
        'textHeading': 'Describe how meetings take place at [].',
        'options': [
          'The company is swamped with meetings and unprepared participants.',
          'There\'s an initiative to refine meetings, but clarity on agendas and results is still lacking.',
          'Some meetings exhibit clear objectives, but participant readiness is inconsistent.',
          'A significant number of meetings now have well-defined agendas and expected outcomes.',
          'Most meetings are structured, goal-driven, and participants come well-prepared.',
          'The company conducts few, but exceptionally effective meetings, marked by precise agendas, desired outcomes, and full participant readiness.',
        ],
      },
      'q35': {
        'index': 35,
        'textHeading': 'Describe the state of cross-functional accountability at [].',
        'options': [
          'Neither staff nor leaders have a mechanism to hold each other accountable and delivery dates are often missed.',
          'There is accountability in some teams and from certain leaders, but little cross-collaborative accountability.',
          'There is accountability within departments, but no cross-functional accountability, which creates confusion and a lack of cross-team commitment.',
          'The company’s leaders and staff can hold each other accountable for actions and delivery.',
          'The company promotes accountability in both directions and allows staff to hold leadership accountable as well as the other way around.',
          'The company promotes 360-degree feedback, has a defined process for anonymous accountability, and acts upon those suggestions.',
        ],
        'textExtra': 'Cross-functional accountability is when different people in different departments can hold others accountable for their workstreams and deliverables.'
      },
    };

    _firestore.collection('surveyBuild').doc('v.2024-12-28').set({
      'rating': ratingQuestions,
      'multipleChoice': multipleChoiceQuestions,
    });
  }
}
