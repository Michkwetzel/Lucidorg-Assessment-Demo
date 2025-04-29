import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:provider/provider.dart';

class CustomBackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomBackButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    void previousQuestion() {
      QuestionsProvider q = Provider.of<QuestionsProvider>(context, listen: false);
      if (!Provider.of<QuestionsProvider>(context, listen: false).canGoBack) {
        Provider.of<QuestionsProvider>(context, listen: false).reset();
        Navigator.pop(context);
      } else {
        Provider.of<QuestionsProvider>(context, listen: false).previousQuestion();
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
