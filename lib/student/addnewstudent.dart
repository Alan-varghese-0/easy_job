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

  final namecontroller = TextEditingController();
  final batchcontroller = TextEditingController();
  final timecontroller = TextEditingController();
  final coursecontroller = TextEditingController();

  String selectedRoadmap = "flutter";

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
          roadmapType: selectedRoadmap,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    namecontroller.dispose();
    batchcontroller.dispose();
    timecontroller.dispose();
    coursecontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text("Add Student"),
        backgroundColor: Colors.black,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField("Name", namecontroller),
              const SizedBox(height: 20),

              buildField("Batch", batchcontroller),
              const SizedBox(height: 20),

              buildField("Course", coursecontroller),
              const SizedBox(height: 20),

              buildField("Class Time", timecontroller),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                value: selectedRoadmap,
                dropdownColor: Colors.black,
                style: const TextStyle(color: Colors.white),
                items: const [
                  DropdownMenuItem(value: "flutter", child: Text("Flutter")),
                  DropdownMenuItem(value: "uiux", child: Text("UI/UX")),
                  DropdownMenuItem(value: "extra", child: Text("Extra Skills")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedRoadmap = value!;
                  });
                },
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: saveStudent,
                child: const Text("Save Student"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? "Enter $label" : null,
    );
  }
}
