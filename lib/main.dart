/// Angel Badillo Hernandez / @It-IsLegend27
///
/// Project 1: Quizzler w/ FastApi
///
/// Class: CMPS-4443-101: MOB
///
/// Description: This is a simple quiz app. The quiz is true/false style.
/// The "QuizControl" relies on a python FASTAPI. An instance of the QuizControl
/// is controls progression of the quiz, and retrieves data for via get requests
/// to the API and decoding the response.
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'quiz_control.dart';

QuizControl quizControl = QuizControl();

void main() => runApp(const Quizzler());

class Quizzler extends StatelessWidget {
  const Quizzler({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Quizzical",
      debugShowCheckedModeBanner: false,
      home: QuizPage(title: "Quizzical"),
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key, required this.title});

  final String title;

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  List<Icon> scoreKeeper = [
    const Icon(Icons.arrow_forward_ios, color: Colors.white)
  ]; // Keeps track of the user's answers

  String currentQuestion = '';

  /// Get a question and assign it to currentQuestion
  void setQuestionText() async {
    String temp = await quizControl.getQuestionText();
    setState(() {
      currentQuestion = temp;
    });
  }

  /// Check the user's answer, then check if the quiz if over.
  /// If it is over, add the appropriate icon to the scoreKeeper, then
  /// display the Alert. Once closed, reset the scoreKeeper.
  /// If the quiz is not over, add the appropriate icon to the scoreKeeper,
  /// then move to the next question.
  void checkAnswer(bool userPickedAnswer) async {
    bool correctAnswer = await quizControl.getCorrectAnswer();

    if (userPickedAnswer == correctAnswer) {
      setState(() {
        scoreKeeper.add(const Icon(
          Icons.check,
          color: Colors.green,
        ));
      });
    } else {
      setState(() {
        scoreKeeper.add(const Icon(
          Icons.close,
          color: Colors.red,
        ));
      });
    }
  }

  /// Proceed quiz to the next question
  void nextQuestion() async {
    if (quizControl.isFinished()) {
      setState(() {
        Alert(
          style: const AlertStyle(
            isCloseButton: false,
            isOverlayTapDismiss: false,
          ),
          context: context,
          image: Image.asset('images/party.gif'),
          title: "Finished!",
          desc: "Press OK to restart the quiz!",
          buttons: [
            DialogButton(
              onPressed: () {
                Navigator.pop(context);
                quizControl.reset();
                scoreKeeper = [
                  // Marks the starting point
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  )
                ];
              },
              width: 120,
              child: const Text(
                "OK",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ],
        ).show();
      });
    } else {
      setState(() {
        quizControl.nextQuestion();
        setQuestionText();
      });
    }
  }

  @override
  void initState() {
    setQuestionText();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setQuestionText(); // Set question text before we use it
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: const Center(
            child: Text(
          'Quizzical',
          style: TextStyle(
            fontFamily: 'Bangers',
            fontSize: 50.0,
          ),
        )),
      ),
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      currentQuestion,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    child: const Text(
                      'True',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    onPressed: () {
                      checkAnswer(true);
                      nextQuestion();
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red)),
                    child: const Text(
                      'False',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      checkAnswer(false);
                      nextQuestion();
                    },
                  ),
                ),
              ),
              const Divider(color: Colors.white, thickness: 1),
              Container(
                color: Colors.grey[900],
                child: Row(
                  children: scoreKeeper,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
