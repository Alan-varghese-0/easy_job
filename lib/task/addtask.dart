import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Addtask extends StatefulWidget {
  const Addtask({super.key});

  @override
  State<Addtask> createState() => _AddtaskState();
}

class _AddtaskState extends State<Addtask> {
  final Box taskbox = Hive.box('taskbox');
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;
  bool repeat = false;
  TextEditingController titleController = TextEditingController();
  TextEditingController discontroller = TextEditingController();

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 15),
      initialDate: selectedDate,
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  Future<void> _picktime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    discontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: height * 0.6,
        child: Column(
          children: [
            dragHandle(),
            Expanded(child: formContent()),
          ],
        ),
      ),
    );
  }

  Widget dragHandle() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget formContent() {
    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        TextField(
          controller: titleController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'Title',

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        SizedBox(height: 12),
        TextField(
          controller: discontroller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: 'description',

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
        SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.calendar_today, color: Colors.white),
          title: Text(
            "Date: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
            style: const TextStyle(color: Colors.white),
          ),
          onTap: _pickDate,
        ),
        SizedBox(height: 12),
        ListTile(
          leading: const Icon(Icons.access_time, color: Colors.white),
          title: Text(
            selectedTime == null
                ? "Select Time"
                : "Time: ${selectedTime!.hour}:${selectedTime!.minute}",
            style: const TextStyle(color: Colors.white),
          ),
          onTap: _picktime,
        ),
        SizedBox(height: 12),
        SwitchListTile(
          title: const Text(
            "Repeat Task",
            style: TextStyle(color: Colors.white),
          ),
          value: repeat,
          onChanged: (value) {
            setState(() {
              repeat = value;
            });
          },
          activeColor: Colors.green,
        ),
        SizedBox(height: 12),
        ElevatedButton(
          onPressed: () {
            if (titleController.text.trim().isEmpty) return;
            taskbox.add({
              "title": titleController.text,
              "description": discontroller.text,
              "date": selectedDate,
              "time": selectedTime != null
                  ? "${selectedTime!.hour}:${selectedTime!.minute}"
                  : null,
              "repeat": repeat,
              "completed": false,
            });
            Navigator.pop(context);
          },
          child: Text(
            "add Task",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 23,
            ),
          ),
        ),
      ],
    );
  }
}
