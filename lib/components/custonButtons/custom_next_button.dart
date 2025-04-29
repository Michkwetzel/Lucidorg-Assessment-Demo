import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/changeNotifiers/radioButtonsState.dart';
import 'package:lucid_org/changeNotifiers/ratingBarState.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/helperClasses/questionMultipleChoice.dart';
import 'package:lucid_org/screens/finalScreen.dart';
import 'package:lucid_org/services/googleFunctionService.dart';
import 'package:provider/provider.dart';

class CustomNextButton extends StatelessWidget {
  const CustomNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    void nextQuestion() async {
      double result;
      QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
      SurveyDataProvider surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);
      GoogleFunctionService googleFunctionService = Provider.of<GoogleFunctionService>(context, listen: false);

      // Go to first question
      if (questionsProvider.currentIndex == -1) {
        questionsProvider.nextQuestion();
        return;
      }

      // Get selected answer
      if (questionsProvider.currentQuestion is Questionmultiplechoice) {
        result = Provider.of<RadioButtonState>(context, listen: false).selectedIndex.toDouble();
        if (result == -1) {
          //No answer selected
          Provider.of<RadioButtonState>(context, listen: false).noAnswerSelected();
          return;
        }
      } else {
        //No answer selected
        result = Provider.of<Ratingbarstate>(context, listen: false).getRating();
        if (result == -1) {
          Provider.of<Ratingbarstate>(context, listen: false).noAnswerSelected();
          return;
        }
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
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  backgroundColor: Colors.transparent,
                  child: Center(
                    child: const CircularProgressIndicator(
                      color: Colors.blue,
                    ),
                  ),
                );
              });
          await Provider.of<GoogleFunctionService>(context, listen: false).saveResults(results).then(
            (_) {
              Navigator.pop(context);
            },
          );
        }
        try {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const FinalScreen(),
            ),
          );
        } catch (e) {
          print('Navigation error: $e');
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
            Consumer<QuestionsProvider>(
              builder: (context, questionsProvider, child) {
                String buttonText = "Next";
                if (!questionsProvider.canGoForward) {
                  buttonText = "Submit";
                }
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
