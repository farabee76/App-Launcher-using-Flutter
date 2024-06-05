import 'package:flutter/material.dart';
import 'package:faiedapplauncher/questions.dart';
import 'dart:async';

class QuizDetailPage extends StatefulWidget {
  final int level;
  final String mode;

  QuizDetailPage({required this.level, required this.mode});

  @override
  _QuizDetailPageState createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends State<QuizDetailPage>
    with SingleTickerProviderStateMixin {
  List<Map<String, Object>> _questions = [];
  int _currentQuestionIndex = 0;
  int _totalScore = 0;
  bool _answered = false;
  bool _isTimedMode = false;
  late AnimationController _controller;
  late Animation<Offset> _animation;
  Timer? _timer;
  int _remainingTime = 15;
  final int _totalTime = 15; // total time for each question

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _controller = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
    if (widget.mode == 'Timed') {
      _isTimedMode = true;
      _startTimer();
    }
  }

  void _loadQuestions() {
    switch (widget.level) {
      case 1:
        _questions = level1Questions;
        break;
      case 2:
        _questions = level2Questions;
        break;
      case 3:
        _questions = level3Questions;
        break;
      case 4:
        _questions = level4Questions;
        break;
      default:
        _questions = [];
    }
  }

  void _answerQuestion(int score) {
    setState(() {
      _answered = true;
    });
    Future.delayed(Duration(milliseconds: 500), () {
      _totalScore += score;
      setState(() {
        _currentQuestionIndex++;
        _answered = false;
      });
      if (_currentQuestionIndex < _questions.length) {
        _controller.reset();
        _controller.forward();
        if (_isTimedMode) {
          _startTimer();
        }
      } else {
        _showResult();
      }
    });
  }

  void _startTimer() {
    _remainingTime = _totalTime;
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _timer!.cancel();
          _answerQuestion(
              0); // Automatically answer with 0 score when time is up
        }
      });
    });
  }

  void _showResult() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Quiz Completed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Your score is $_totalScore.'),
            SizedBox(height: 20),
            Text('Explanations:'),
            ..._questions.map((question) {
              return ListTile(
                title: Text(question['question'] as String),
                subtitle: Text(question['explanation'] as String),
              );
            }).toList(),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        actions: _isTimedMode
            ? [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: ClockTimer(
                      remainingTime: _remainingTime,
                      totalTime: _totalTime,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: _currentQuestionIndex < _questions.length
          ? SlideTransition(
              position: _animation,
              child: QuizQuestion(
                question:
                    _questions[_currentQuestionIndex]['question'] as String,
                answers: _questions[_currentQuestionIndex]['answers']
                    as List<Map<String, Object>>,
                answerQuestion: _answerQuestion,
                answered: _answered,
              ),
            )
          : Center(
              child: Text('No more questions.'),
            ),
    );
  }
}

class QuizQuestion extends StatelessWidget {
  final String question;
  final List<Map<String, Object>> answers;
  final Function answerQuestion;
  final bool answered;

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.answerQuestion,
    required this.answered,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            question,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 24),
          ...answers.map((answer) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: answered
                    ? (answer['score'] == 1 ? Colors.green : Colors.red)
                    : Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: ListTile(
                title: Text(
                  answer['text'] as String,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                onTap: answered ? null : () => answerQuestion(answer['score']),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

class ClockTimer extends StatelessWidget {
  final int remainingTime;
  final int totalTime;

  ClockTimer({required this.remainingTime, required this.totalTime});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CircularProgressIndicator(
          value: remainingTime / totalTime,
          strokeWidth: 8.0,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(remainingTime > 15
              ? Colors.green
              : remainingTime > 8
                  ? Colors.orange
                  : Colors.red),
        ),
        Text(
          '$remainingTime',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class CreateQuizPage extends StatefulWidget {
  @override
  _CreateQuizPageState createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, String>> _questions = [];
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _answerControllers =
      List.generate(4, (index) => TextEditingController());
  int _correctAnswerIndex = 0;

  void _addQuestion() {
    if (_formKey.currentState!.validate()) {
      final question = _questionController.text;
      final answers =
          _answerControllers.map((controller) => controller.text).toList();
      _questions.add({
        'question': question,
        'answers': answers.join('|'),
        'correctAnswer': answers[_correctAnswerIndex],
      });
      _questionController.clear();
      _answerControllers.forEach((controller) => controller.clear());
      setState(() {
        _correctAnswerIndex = 0;
      });
    }
  }

  void _submitQuiz() {
    // Here you would handle quiz submission, e.g., save to a database or share with others.
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Your Own Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Question'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a question';
                  }
                  return null;
                },
              ),
              ...List.generate(4, (index) {
                return ListTile(
                  title: TextFormField(
                    controller: _answerControllers[index],
                    decoration:
                        InputDecoration(labelText: 'Answer ${index + 1}'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an answer';
                      }
                      return null;
                    },
                  ),
                  leading: Radio<int>(
                    value: index,
                    groupValue: _correctAnswerIndex,
                    onChanged: (value) {
                      setState(() {
                        _correctAnswerIndex = value!;
                      });
                    },
                  ),
                );
              }),
              ElevatedButton(
                onPressed: _addQuestion,
                child: Text('Add Question'),
              ),
              SizedBox(height: 20),
              if (_questions.isNotEmpty)
                ElevatedButton(
                  onPressed: _submitQuiz,
                  child: Text('Submit Quiz'),
                ),
              if (_questions.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _questions.map((question) {
                    return ListTile(
                      title: Text(question['question']!),
                      subtitle:
                          Text('Correct Answer: ${question['correctAnswer']}'),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  final List<Map<String, dynamic>> leaderboard = [
    {'name': 'Faied', 'score': 90},
    {'name': 'Faruk', 'score': 85},
    {'name': 'Auvick', 'score': 80},
    // Add more sample data or fetch from a database
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: ListView.builder(
        itemCount: leaderboard.length,
        itemBuilder: (context, index) {
          final entry = leaderboard[index];
          return ListTile(
            title: Text(entry['name']),
            trailing: Text(entry['score'].toString()),
          );
        },
      ),
    );
  }
}

class QuizPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QuizApp'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 255, 209, 128),
                Color.fromARGB(255, 255, 209, 128),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                SizedBox(height: 32),
                QuizModeButton(
                  title: 'Timed Quiz',
                  description: 'Complete the quiz within a time limit.',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizDetailPage(level: 1, mode: 'Timed'),
                      ),
                    );
                  },
                ),
                QuizModeButton(
                  title: 'Practice Mode',
                  description: 'Practice without a time limit.',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            QuizDetailPage(level: 1, mode: 'Practice'),
                      ),
                    );
                  },
                ),
                QuizModeButton(
                  title: 'Create Your Own Quiz',
                  description: 'Create and share your own quizzes.',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CreateQuizPage(),
                      ),
                    );
                  },
                ),
                QuizModeButton(
                  title: 'Leaderboard',
                  description: 'View the top scores.',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LeaderboardPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuizModeButton extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  QuizModeButton(
      {required this.title,
      required this.description,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.arrow_forward),
        onTap: onPressed,
      ),
    );
  }
}
