import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LessonPage extends StatelessWidget {
  const LessonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text('Lesson'),
      ),
    );
  }
}