import 'package:flutter/material.dart';
import 'package:lucid_org/screens/welcomeScreen.dart';

class LogoSpinAnimation extends StatefulWidget {
  const LogoSpinAnimation({super.key});

  @override
  State<LogoSpinAnimation> createState() => _LogoSpinAnimationState();
}

class _LogoSpinAnimationState extends State<LogoSpinAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5), // Total animation duration
      vsync: this,
    )..repeat();

    // Create a custom curve for the spinning animation
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ).drive(
      Tween<double>(
        begin: 0,
        end: 1,
      ).chain(
        TweenSequence([
          TweenSequenceItem(
            tween: Tween<double>(begin: 0, end: 2) // Fast clockwise spin (2 rotations)
                .chain(CurveTween(curve: Curves.easeOut)),
            weight: 40,
          ),
          TweenSequenceItem(
            tween: Tween<double>(begin: 2, end: 1.5) // Slower counterclockwise (half rotation back)
                .chain(CurveTween(curve: Curves.easeInOut)),
            weight: 60,
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            barrierColor: Colors.transparent,
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.transparent,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: RotationTransition(
                      turns: _animation,
                      child: Image.asset(
                        'assets/logo/3transparent_logo.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: Text("data"));
  }
}
