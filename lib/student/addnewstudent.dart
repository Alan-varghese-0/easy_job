import 'package:easy_job/models/student.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Addnewstudent extends StatefulWidget {
  const Addnewstudent({super.key});

  @override
  State<Addnewstudent> createState() => _AddnewstudentState();
}

class _AddnewstudentState extends State<Addnewstudent> {
  final _formKey = GlobalKey<FormState>();
  final batchcontroller = TextEditingController();
  final namecontroller = TextEditingController();
  final timecontroller = TextEditingController();
  final coursecontroller = TextEditingController();

  void saveStudent() {
    if (_formKey.currentState!.validate()) {
      Hive.box<Student>("studentbox").add(
        Student(
          name: namecontroller.text,
          batch: batchcontroller.text,
          classTime: timecontroller.text,
          course: coursecontroller.text,
          presentDates: [],
          completedLessons: [],
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    batchcontroller.dispose();
    namecontroller.dispose();
    timecontroller.dispose();
    coursecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                style: const TextStyle(color: Colors.white),
                controller: namecontroller,
                decoration: InputDecoration(
                  labelText: "Name",
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter name";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                style: const TextStyle(color: Colors.white),

                controller: batchcontroller,
                decoration: InputDecoration(
                  labelText: "Batch",
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter batch";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                style: const TextStyle(color: Colors.white),

                controller: coursecontroller,
                decoration: InputDecoration(
                  labelText: "Course",
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter course";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              TextFormField(
                style: const TextStyle(color: Colors.white),

                controller: timecontroller,
                decoration: InputDecoration(
                  labelText: "Class Time",
                  labelStyle: const TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.white),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter class time";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveStudent,
                child: Text(
                  "save student",
                  style: TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
