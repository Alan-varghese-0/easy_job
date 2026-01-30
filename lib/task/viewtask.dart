import 'package:easy_job/task/addtask.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Viewtask extends StatelessWidget {
  const Viewtask({super.key});

  @override
  Widget build(BuildContext context) {
    final Box box = Hive.box('taskbox');

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text(
          "Tasks",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
        ),
      ),

      // 🔁 AUTO UPDATE UI WHEN HIVE CHANGES
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text(
                "No tasks yet",
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final Map task = box.getAt(index) as Map;

              return Dismissible(
                key: ValueKey(box.keyAt(index)),
                direction: DismissDirection.endToStart,

                // 🔴 RED DELETE BACKGROUND
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),

                // ✅ DELETE CONFIRMED
                onDismissed: (_) {
                  box.deleteAt(index);
                },

                child: CheckboxListTile(
                  value: task["completed"] ?? false,
                  onChanged: (value) {
                    task["completed"] = value;
                    box.putAt(index, task);
                  },

                  title: Text(
                    task["title"] ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),

                  subtitle: Text(
                    task["description"] ?? "",
                    style: const TextStyle(color: Colors.grey, fontSize: 16),
                  ),

                  activeColor: Colors.green,
                  checkColor: Colors.black,
                ),
              );
            },
          );
        },
      ),

      // ➕ ADD TASK BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.black,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (_) => const SafeArea(child: Addtask()),
          );
        },
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
