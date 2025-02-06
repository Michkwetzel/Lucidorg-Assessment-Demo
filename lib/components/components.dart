import 'package:flutter/material.dart';
import 'package:front_survey_questions/changeNotifiers/questionsProvider.dart';
import 'package:front_survey_questions/changeNotifiers/radioButtonsState.dart';
import 'package:front_survey_questions/changeNotifiers/ratingBarState.dart';
import 'package:front_survey_questions/changeNotifiers/surveyDataProvider.dart';
import 'package:front_survey_questions/constants.dart';
import 'package:front_survey_questions/enums.dart';
import 'package:front_survey_questions/helperClasses/questionMultipleChoice.dart';
import 'package:front_survey_questions/screens/finalScreen.dart';
import 'package:front_survey_questions/services/firestoreService.dart';
import 'package:front_survey_questions/services/googleFunctionService.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

final log = Logger("Components");

class RatingQuestionCard extends StatelessWidget {
  final String questionBody;
  final bool hasExtraText;
  final String extraText;
  const RatingQuestionCard({super.key, required this.questionBody, required this.hasExtraText, required this.extraText});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: MediaQuery.of(context).size.width > 600 ? EdgeInsets.symmetric(vertical: 36) : EdgeInsets.symmetric(horizontal: 36, vertical: 36),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  questionBody,
                  style: kRatingQTextStyle,
                ),
              ),
              if (hasExtraText) InfoButton()
            ],
          ),
        ),
        CustomRatingBar(key: Provider.of<Ratingbarstate>(context).ratingBarKey),
      ],
    );
  }
}

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({super.key});

  @override
  Widget build(BuildContext context) {
    bool errorDisplay = Provider.of<Ratingbarstate>(context).errorDisplay;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Consumer<Ratingbarstate>(builder: (context, rantingBarState, child) {
          final List<int> indexList = [1, 2, 3, 4, 5];
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: indexList.map((index) {
              return RatingButton(
                index: index,
                selected: index == rantingBarState.selectedRating,
                errorDisplay: errorDisplay,
              );
            }).toList(),
          );
        }),
        if (errorDisplay)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 2),
            child: SizedBox(
              width: 335,
              child:
                  Row(children: [Icon(Icons.dangerous, color: Colors.red[300]!, size: 20, grade: 0.5), SizedBox(width: 4), Text("Please select an answer", style: TextStyle(color: Colors.red[300]!))]),
            ),
          ),
        if (!errorDisplay) SizedBox(height: 15),
        SizedBox(
          width: 335,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Disagree',
                style: kRatingBarHintTextStyle,
              ),
              Text(
                'Agree',
                style: kRatingBarHintTextStyle,
              ),
            ],
          ),
        )
      ],
    );
  }
}

class RatingButton extends StatelessWidget {
  final int index;
  final bool selected;
  final bool errorDisplay;
  const RatingButton({super.key, required this.index, this.selected = true, this.errorDisplay = false});

  BoxDecoration getDecoration() {
    if (errorDisplay) {
      // No selection made red error
      return BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red[300]!, width: 1));
    } else if (selected) {
      // Box Selected
      return BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 4)], color: Color(0xFFFFBB40), borderRadius: BorderRadius.circular(12));
    } else {
      // Not selected
      return BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 4)], color: Color(0xFFFFFFFF), borderRadius: BorderRadius.circular(12));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: GestureDetector(
        onTap: () {
          Provider.of<Ratingbarstate>(context, listen: false).setRating(index.toDouble());
        },
        child: Container(
          decoration: getDecoration(),
          height: 55,
          width: 56,
          child: Center(
            child: Text(
              index.toString(),
              style: TextStyle(color: Color(0xFF000000), fontFamily: 'Noto Sans', fontSize: 17),
            ),
          ),
        ),
      ),
    );
  }
}

class InfoButton extends StatelessWidget {
  const InfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return Padding(
                  padding: EdgeInsets.all(32),
                  child: Consumer<QuestionsProvider>(
                    builder: (context, questionsProvider, child) {
                      return Container(
                        constraints: BoxConstraints(maxWidth: 488),
                        child: Row(
                          children: [
                            Flexible(
                              child: Text(
                                questionsProvider.extraText,
                                style: kBottomModalSheetTextStyle,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              });
        },
        icon: Icon(
          Icons.info_outline,
          color: Color(0xFFA39C91),
          weight: 1.33,
          size: 23,
        ));
  }
}

class MultipleChoiceQuestionCard extends StatelessWidget {
  final List<dynamic> options;
  final List<RadioButtonCard> radioButtonCards;

  MultipleChoiceQuestionCard({super.key, required this.options}) : radioButtonCards = [] {
    int counter = 1;
    for (String option in options) {
      radioButtonCards.add(RadioButtonCard(text: option, radioButtonIndex: counter));
      counter++;
    }
  }

  Expanded expandedListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: radioButtonCards.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: 24,
            );
          } else if (index <= radioButtonCards.length) {
            return radioButtonCards[index - 1];
          } else {
            return SizedBox(
              height: 80,
            );
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (Provider.of<RadioButtonState>(context).errorDisplay) {
      return Expanded(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Icon(Icons.dangerous, color: Colors.red[300]!, size: 20, grade: 0.5), SizedBox(width: 4), Text("Please select an answer", style: TextStyle(color: Colors.red[300]!))]),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: radioButtonCards.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return SizedBox(
                      height: 12,
                    );
                  } else if (index <= radioButtonCards.length) {
                    return radioButtonCards[index - 1];
                  } else {
                    return SizedBox(
                      height: 80,
                    );
                  }
                },
              ),
            )
          ],
        ),
      );
    }
    return Flexible(
      child: ListView.builder(
        itemCount: radioButtonCards.length + 2,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: 24,
            );
          } else if (index <= radioButtonCards.length) {
            return radioButtonCards[index - 1];
          } else {
            return SizedBox(
              height: 80,
            );
          }
        },
      ),
    );
  }
}

class RadioButtonCard extends StatelessWidget {
  final String text;
  final String? textExtra;
  final int radioButtonIndex;

  const RadioButtonCard({super.key, required this.text, this.textExtra, required this.radioButtonIndex});

  @override
  Widget build(BuildContext context) {
    EdgeInsetsGeometry padding = const EdgeInsets.only(bottom: 24, left: 32, right: 32);

    if (MediaQuery.of(context).size.width > 600) {
      padding = const EdgeInsets.only(bottom: 24);
    }

    return Padding(
      padding: padding,
      child: MaterialButton(
        padding: EdgeInsets.all(16),
        elevation: 0,
        onPressed: () => Provider.of<RadioButtonState>(context, listen: false).onRadioButtonSelected(radioButtonIndex),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Provider.of<RadioButtonState>(context).errorDisplay ? Colors.red[300]! : Color(0xFFCACACA)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Consumer<RadioButtonState>(
                builder: (context, radioButtonCardState, child) {
                  if (radioButtonCardState.selectedIndex == radioButtonIndex) {
                    return Icon(Icons.radio_button_checked);
                  } else {
                    return Icon(Icons.radio_button_off, color: Color(0xFF767575));
                  }
                },
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: kBodyTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<QuestionsProvider>(
      builder: (context, questionsProvider, child) {
        return LinearProgressIndicator(
          value: questionsProvider.currentIndex / questionsProvider.questionLength,
          backgroundColor: Color(0xffDADADA),
          color: Color(0xff1FB707),
        );
      },
    );
  }
}

class TopComponent extends StatelessWidget {
  final String text;
  final String textExtra;
  final bool hasExtraText;
  final QuestionType questionType;
  const TopComponent({super.key, required this.text, required this.hasExtraText, required this.textExtra, required this.questionType});

  @override
  Widget build(BuildContext context) {
    bool desktop = false;

    if (MediaQuery.of(context).size.width > 400) {
      desktop = true;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: desktop ? 500 : 300),
        child: Row(
          //mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: hasExtraText && questionType == QuestionType.multipleChoice ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: Text(
                text,
                style: kH2TextStyle,
              ),
            ),
            if (hasExtraText && questionType == QuestionType.multipleChoice) InfoButton(),
            if (hasExtraText && questionType == QuestionType.multipleChoice) SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}

class CloseIcon extends StatelessWidget {
  const CloseIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.close,
      size: 24,
      color: Color(0xff585858),
    );
  }
}

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomBackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    void previousQuestion() {
      log.info('Previous Button Clicked');

      QuestionsProvider q = Provider.of<QuestionsProvider>(context, listen: false);
      if (!Provider.of<QuestionsProvider>(context, listen: false).canGoBack) {
        Provider.of<QuestionsProvider>(context, listen: false).reset();
        Navigator.pop(context);
      } else {
        Provider.of<QuestionsProvider>(context, listen: false).previousQuestion();
        log.info('Loading result for Q${q.currentIndex} - Result ${q.currentQuestion.result}');
      }
    }

    return Padding(
      padding: MediaQuery.of(context).size.width > 600 ? const EdgeInsets.symmetric(vertical: 32) : const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: SizedBox(
        width: 60 * 0.9,
        height: 55 * 0.9,
        child: MaterialButton(
          onPressed: () => previousQuestion(),
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF3F94FF),
            size: 16 * 0.9,
          ),
        ),
      ),
    );
  }
}

class CustomNextButton extends StatelessWidget {
  const CustomNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    void nextQuestion() async {
      log.info('Next Button Clicked');
      double result;
      QuestionsProvider questionsProvider = Provider.of<QuestionsProvider>(context, listen: false);
      SurveyDataProvider surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);

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
        questionsProvider.nextQuestion();
      } else {
        //Submit results
        if (Provider.of<FirestoreService>(context, listen: false).surveyToken == 'test') {
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
        } else {
          final results = questionsProvider.getResults();
          await Provider.of<GoogleFunctionService>(context, listen: false).saveResults(surveyDataProvider.latestDocname, surveyDataProvider.emailType, results);
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
      child: Container(
        //constraints: BoxConstraints(maxWidth: 150, maxHeight: 50),
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
      ),
    );
  }
}

class CustomStartButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CustomStartButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: MaterialButton(
        onPressed: onPressed,
        color: Color(0xFF3F94FF),
        elevation: 4,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              textAlign: TextAlign.center,
              "Start",
              style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255), fontFamily: 'Noto Sans', fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
