import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Sample questions and answers
  final List<Map<String, Object>> _questions = [
    {
      'question': 'What is the capital of France?',
      'answers': ['Berlin', 'Madrid', 'Paris', 'Rome'],
      'correct_answer': 'Paris',
    },
    {
      'question': 'What is the largest planet in our Solar System?',
      'answers': ['Earth', 'Jupiter', 'Saturn', 'Mars'],
      'correct_answer': 'Jupiter',
    },
    {
      'question': 'Who developed the theory of relativity?',
      'answers': ['Newton', 'Einstein', 'Tesla', 'Galileo'],
      'correct_answer': 'Einstein',
    },
  ];

  int _currentQuestionIndex = 0;
  int _score = 0;

  // Function to check the answer and move to the next question
  void _answerQuestion(String selectedAnswer) {
    if (selectedAnswer == _questions[_currentQuestionIndex]['correct_answer']) {
      _score++;
    }

    setState(() {
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
      } else {
        // Show score when quiz is finished
        _showResultDialog();
      }
    });
  }

  // Function to show the result dialog
  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Quiz Finished!'),
        content: Text('Your score is: $_score/${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _score = 0;
                _currentQuestionIndex = 0;
              });
              Navigator.of(ctx).pop();
            },
            child: Text('Retry'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz Page')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              _questions[_currentQuestionIndex]['question'] as String,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            // List of possible answers as buttons
            ...(_questions[_currentQuestionIndex]['answers'] as List<String>)
                .map((answer) {
              return ElevatedButton(
                onPressed: () => _answerQuestion(answer),
                child: Text(answer),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

