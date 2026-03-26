import 'package:flutter/material.dart';
import 'lesson.dart';
import '../models/student.dart';

enum LessonType { flutter, uiux, extra }

class LessonScreen extends StatefulWidget {
  final Student student;
  final LessonType type;

  const LessonScreen({super.key, required this.student, required this.type});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  List<String> getLessons() {
    switch (widget.type) {
      case LessonType.flutter:
        return flutterRoadmap;
      case LessonType.uiux:
        return uiuxRoadmap;
      case LessonType.extra:
        return extraSkills;
    }
  }

  @override
  Widget build(BuildContext context) {
    final lessons = getLessons();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.student.name),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        children: lessons.map((lesson) {
          final isDone = widget.student.completedLessons.contains(lesson);

          return CheckboxListTile(
            value: isDone,
            onChanged: (value) {
              setState(() {
                if (value == true) {
                  widget.student.completedLessons.add(lesson);
                } else {
                  widget.student.completedLessons.remove(lesson);
                }
                widget.student.save();
              });
            },
            title: Text(
              lesson,
              style: TextStyle(
                color: isDone ? Colors.grey : Colors.white,
                decoration: isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
