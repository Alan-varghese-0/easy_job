import 'package:easy_job/topics/lesson.dart';
import 'package:flutter/material.dart';
import '../models/student.dart';

class LessonScreen extends StatefulWidget {
  final Student student;

  const LessonScreen({super.key, required this.student});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  Widget build(BuildContext context) {
    // ✅ Separate unchecked & checked lessons
    final List<String> uncheckedLessons = lessons
        .where((lesson) => !widget.student.completedLessons.contains(lesson))
        .toList();

    final List<String> checkedLessons = lessons
        .where((lesson) => widget.student.completedLessons.contains(lesson))
        .toList();

    // ✅ Unchecked first, checked at bottom
    final List<String> orderedLessons = [
      ...uncheckedLessons,
      ...checkedLessons,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Lessons – ${widget.student.name}"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: orderedLessons.length,
        itemBuilder: (context, index) {
          final String lesson = orderedLessons[index];
          final bool isChecked = widget.student.completedLessons.contains(
            lesson,
          );

          return CheckboxListTile(
            title: Text(
              lesson,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: isChecked ? FontWeight.normal : FontWeight.bold,
              ),
            ),
            value: isChecked,
            onChanged: (bool? value) {
              setState(() {
                if (value == true) {
                  widget.student.completedLessons.add(lesson);
                } else {
                  widget.student.completedLessons.remove(lesson);
                }
                widget.student.save(); // ✅ Persist to Hive
              });
            },
          );
        },
      ),
    );
  }
}
