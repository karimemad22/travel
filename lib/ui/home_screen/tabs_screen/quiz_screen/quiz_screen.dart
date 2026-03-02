import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  static const String routeName = 'quiz';

  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: const Center(
        child: Text('Quiz Screen'),
      ),
    );
  }
}
