import 'package:easy_job/models/student.dart';
import 'package:easy_job/student/addnewstudent.dart';
import 'package:easy_job/topics/lesson_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Studentlist extends StatefulWidget {
  const Studentlist({super.key});

  @override
  State<Studentlist> createState() => _StudentlistState();
}

class _StudentlistState extends State<Studentlist> {
  final box = Hive.box<Student>('studentbox');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          "Student List",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<Student> box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text(
                      "No students added yet",
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: box.length,
                  itemBuilder: (context, index) {
                    final student = box.getAt(index)!;
                    return Dismissible(
                      key: ValueKey(student.key),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (_) async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Delete student?"),
                            content: const Text("This cannot be undone."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text("Delete"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          box.deleteAt(index);
                        }
                      },

                      child: ListTile(
                        title: Text(
                          student.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        subtitle: Text(
                          "Batch: ${student.batch} | Course: ${student.classTime}",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              opaque: true,
                              pageBuilder: (_, __, ___) => LessonScreen(
                                student: student, // ✅ PASS STUDENT
                              ),
                              transitionsBuilder: (_, animation, __, child) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black, // text + icon
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      opaque: true,
                      pageBuilder: (_, __, ___) => const Addnewstudent(),
                      transitionsBuilder: (_, animation, __, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text(
                  'Add Student',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
