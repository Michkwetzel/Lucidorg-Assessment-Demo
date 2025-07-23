import 'package:flutter/material.dart';
import 'package:lucid_org/changeNotifiers/surveyDataProvider.dart';
import 'package:lucid_org/changeNotifiers/questionsProvider.dart';
import 'package:lucid_org/components/custonButtons/custom_start_button.dart';
import 'package:lucid_org/constants.dart';
import 'package:lucid_org/enums.dart';
import 'package:lucid_org/exceptions.dart';
import 'package:lucid_org/screens/errorScreen.dart';
import 'package:lucid_org/screens/loading_screen.dart';
import 'package:lucid_org/screens/mainScreen.dart';
import 'package:lucid_org/services/googleFunctionService.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

Logger log = Logger('WelcomeScreen');

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = true;
  bool _error = false;
  String _errorText = '';
  String _loadingText = "Validating Assessment";
  Logger logger = Logger('WelcomeScreen');

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  // Combined initialization method
  Future<void> _initializeScreen() async {
    if (mounted) {
      setState(() {
        _loadingText = "Loading Survey";
      });
    }
    try {
      final surveyDataProvider = Provider.of<SurveyDataProvider>(context, listen: false);
      final googleFunctionService = Provider.of<GoogleFunctionService>(context, listen: false);

      // First Check tokens and get current Assssment DocName
      await surveyDataProvider.init();

      // Get Questions
      await googleFunctionService.getQuestions();

      // Done Loading
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } on SurveyException catch (e) {
      _handleError(e.message);
    } catch (e) {
      logger.severe('Unexpected Error: $e');
      _handleError("Unexpected Error");
    }
  }

  void _handleError(String message) {
    if (mounted) {
      setState(() {
        _error = true;
        _errorText = message;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? LoadingScreen(_loadingText)
        : _error
            ? ErrorScreen(
                _errorText,
              )
            : const WelcomeScreenComponentLayout();
  }
}

class WelcomeScreenComponentLayout extends StatelessWidget {
  const WelcomeScreenComponentLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: 1),
              Image.asset(
                'assets/logo/logo.jpg',
                width: 300,
              ),
              Container(
                constraints: BoxConstraints(maxWidth: 350),
                decoration: BoxDecoration(
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.20), blurRadius: 4)],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Welcome to the Assessment', style: kWelcomeScreenH1TextStyle),
                      SizedBox(height: 8),
                      Text('Answers are saved anonymously. If you exit before finishing, your result will not be saved', style: kWelcomeScreenH2TextStyle),
                      SizedBox(height: 24),
                      CustomStartButton(
                        onPressed: () async {
                          log.info('Start Button pressed');
                          await onSurveyStarted(context);
                        },
                      ),
                      // For updating data
                      // CustomStartButton(
                      //   onPressed: () async {
                      //     Provider.of<FirestoreService>(context, listen: false).addQuestiontoDB();
                      //   },
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onSurveyStarted(BuildContext context) async {
    Provider.of<QuestionsProvider>(context, listen: false).nextQuestion();
    Product? product = Provider.of<SurveyDataProvider>(context, listen: false).product;
    if (product == Product.test) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => Mainscreen()));
    } else {
      showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent,
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
        },
      );
      await Provider.of<GoogleFunctionService>(context, listen: false).surveyStarted().then(
        (value) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        },
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) => Mainscreen()));
    }
  }
}

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
