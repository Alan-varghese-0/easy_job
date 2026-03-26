import 'package:easy_job/models/student.dart';
import 'package:easy_job/student/addnewstudent.dart';
import 'package:easy_job/topics/lesson_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Studentlist extends StatefulWidget {
  const Studentlist({super.key});

  @override
  State<Studentlist> createState() => _StudentlistState();
}

class _StudentlistState extends State<Studentlist> {
  final box = Hive.box<Student>('studentbox');

  LessonType getType(String type) {
    switch (type) {
      case "uiux":
        return LessonType.uiux;
      case "extra":
        return LessonType.extra;
      default:
        return LessonType.flutter;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Students"),
        backgroundColor: Colors.black,
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (_, Box<Student> box, __) {
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (_, i) {
              final student = box.getAt(i)!;

              return ListTile(
                title: Text(
                  student.name,
                  style: const TextStyle(color: Colors.white),
                ),

                subtitle: Text(
                  student.roadmapType,
                  style: const TextStyle(color: Colors.grey),
                ),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LessonScreen(
                        student: student,
                        type: getType(student.roadmapType),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Addnewstudent()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
