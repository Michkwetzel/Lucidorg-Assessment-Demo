import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/constants.dart';
import 'package:provider/provider.dart';

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
