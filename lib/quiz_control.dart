/// Angel Badillo Hernandez / @It-IsLegend27
///
/// Project 1: Quizzler w/ FastApi
///
/// Class: CMPS-4443-101: MOB
///
/// Description: This package allows the user to make get requests from the
/// localhost:8888 API (api.py).
///
/// Functions:
///
/// [nextQuestion]
///
/// [getQuestionText]
///
/// [getCorrectAnswer]
///
/// [isFinished]
///
/// [reset]
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

const String _host = 'localhost:8080';

class QuizControl {
  QuizControl() {
    currentID = 0;
    _setNumQuestions();
  }

  late int currentID;

  late int numQuestions;

  void _setNumQuestions() async {
    numQuestions = await getNumQuestions();
  }

  Future<int> getNumQuestions() async {
    Uri url = Uri.http(_host, '/num_question');

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      int count = jsonResponse['amount'];
      return count;
    }
    return 0;
  }

  /// Increments id in the API.
  ///
  /// Makes a get request to localhost:8888/next to increment id.
  void nextQuestion() {
    currentID++;
  }

  /// Get a question from the API.
  ///
  /// Makes a get request to localhost:8888/question, decodes json-formatted
  /// response, the returns the question as a string.
  Future<String> getQuestionText() async {
    Uri url = Uri.http(_host, '/question/', {'id': currentID.toString()});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      String question = jsonResponse['question'];
      return question;
    }
    return '';
  }

  /// Get the answer corresponding to the question from the API.
  ///
  /// Makes a get request to localhost:8888/answer, decodes json-formatted
  /// response, the returns the correct answer.
  Future<bool> getCorrectAnswer() async {
    Uri url = Uri.http(_host, '/answer/', {'id': currentID.toString()});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      bool answer = jsonResponse['answer'];
      return answer;
    }
    return false;
  }

  /// Check if at end of quiz
  bool isFinished() {
    return currentID == numQuestions-1;
  }

  /// Reset id to 0.
  ///
  /// Makes a get request to localhost:8888/reset to reset the id to 0.
  void reset() {
    currentID = 0;
  }
}
