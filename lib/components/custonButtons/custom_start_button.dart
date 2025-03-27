import 'package:flutter/material.dart';

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
