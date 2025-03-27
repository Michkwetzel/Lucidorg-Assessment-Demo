import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String loadingText;

  const LoadingScreen(this.loadingText, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/logo.jpg',
              width: 180,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              loadingText,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
