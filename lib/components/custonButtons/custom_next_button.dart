import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/changeNotifiers/radioButtonsState.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/screens/finalScreen.dart';
import 'package:lucid_org/services/googleFunctionService.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

class CustomNextButton extends StatefulWidget {
  const CustomNextButton({super.key});

  @override
  State<CustomNextButton> createState() => _CustomNextButtonState();
}

class _CustomNextButtonState extends State<CustomNextButton> {
  static final Logger logger = Logger('CustomNextButton');

  @override
  Widget build(BuildContext context) {
    void nextQuestion() async {
      QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
      SurveyDataProvider surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);

      // Go to first question
      if (questionsProvider.currentIndex == -1) {
        questionsProvider.nextQuestion();
        return;
      }

      // Get selected answer (all questions are multiple choice now)
      double result = Provider.of<RadioButtonState>(context, listen: false).selectedIndex.toDouble();
      if (result == -1) {
        //No answer selected
        Provider.of<RadioButtonState>(context, listen: false).noAnswerSelected();
        return;
      }

      questionsProvider.saveResult(result);

      if (questionsProvider.currentIndex < questionsProvider.questionLength - 1) {
        // Go to Next Question.
        questionsProvider.nextQuestion();
      } else {
        // End of Survey. Submit results
        if (surveyDataProvider.product == Product.test) {
          // Test Survey. Dont submit anything
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FinalScreen(),
            ),
          );
        } else {
          final results = questionsProvider.getResults();

          // Create a ValueNotifier to track retry status
          final retryStatus = ValueNotifier<String>("Saving results");

          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: Column(
                    spacing: 12,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(
                        backgroundColor: Colors.transparent,
                        color: Colors.blue,
                      ),
                      ValueListenableBuilder<String>(
                        valueListenable: retryStatus,
                        builder: (context, status, child) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 4)],
                            ),
                            child: Text(
                              status,
                              style: Theme.of(context).textTheme.bodyLarge,
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          try {
            await GoogleFunctionService.saveResults(
              surveyDataProvider.orgId!,
              surveyDataProvider.assessmentID!,
              surveyDataProvider.docId!,
              results,
              onRetry: (attempt) {
                retryStatus.value = "Retrying... (Attempt $attempt)";
              },
            );

            // Check if widget is still mounted before using context
            if (!mounted) return;

            // Pop dialog
            Navigator.pop(context);

            // Navigate to final screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const FinalScreen(),
              ),
            );
          } catch (e) {
            logger.severe('Error saving results: $e');

            if (!mounted) return;

            // Pop loading dialog
            Navigator.pop(context);

            // Show error dialog
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Connection Error'),
                  content: const Text('Unable to save your results after multiple attempts. Please wait a few seconds and try submitting again by pressing the Submit button.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
          return;
        }
      }
      //Provider.of<QuestionsProvider>(context, listen: false).printQuestions();
    }

    // double result = Provider.of<Ratingbarstate>(context, listen: false).saveRating();
    // List<int> results = questionsProvider.getResults();

    //TODO: Set correct widhts for Floating Buttons.
    return Padding(
      padding: MediaQuery.of(context).size.width > 600 ? const EdgeInsets.symmetric(vertical: 32) : const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: MaterialButton(
        onPressed: () => nextQuestion(),
        color: Color(0xFF3F94FF),
        elevation: 4,
        padding: EdgeInsets.all(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Selector<QuestionsProvider, bool>(
              selector: (context, provider) => provider.canGoForward,
              builder: (context, canGoForward, child) {
                String buttonText = canGoForward ? "Next" : "Submit";
                return Text(
                  buttonText,
                  style: TextStyle(color: Colors.white, fontFamily: 'Noto Sans', fontSize: 22 * 0.9),
                );
              },
            ),
            const Icon(Icons.navigate_next_rounded, color: Colors.white, size: 24 * 0.9)
          ],
        ),
      ),
    );
  }
}
