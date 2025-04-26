import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: QuizApp(),
  ));
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  List<Map<String, dynamic>> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 10; // 10 seconds per question
  Timer? _timer;
  bool _isAnswered = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    try {
      String data = await rootBundle.loadString('assets/questions.json');
      List<dynamic> jsonData = json.decode(data);
      setState(() {
        _questions = jsonData.map((q) => Map<String, dynamic>.from(q)).toList();
      });
      _startTimer();
    } catch (e) {
      print("Error loading questions: $e");
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 10; // Reset time for each question

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
        _nextQuestion();
      }
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (_isAnswered) return;

    setState(() {
      _isAnswered = true;
      if (selectedAnswer == _questions[_currentQuestionIndex]['answer']) {
        _score++;
      }
    });

    Future.delayed(Duration(seconds: 2), _nextQuestion);
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswered = false;
      });
      _startTimer();
    } else {
      _timer?.cancel();
      _showScoreDialog();
    }
  }

  void _showScoreDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Quiz Completed!"),
        content: Text("Your Score: $_score / ${_questions.length}"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentQuestionIndex = 0;
                _score = 0;
                _isAnswered = false;
              });
              _startTimer();
            },
            child: Text("Restart"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Quiz App with Timer")),
        body: _questions.isEmpty
            ? Center(child: CircularProgressIndicator())
            : Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Time Left: $_timeLeft sec",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  _questions[_currentQuestionIndex]['question'],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ...(_questions[_currentQuestionIndex]['options'] as List<dynamic>)
                    .map(
                      (option) => ElevatedButton(
                    onPressed: () => _checkAnswer(option.toString()),
                    child: Text(option.toString(), style: TextStyle(fontSize: 18)),
                  ),
                )
                    ,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
