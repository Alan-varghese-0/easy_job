import 'dart:async';

import 'package:easy_job/student/studentlist.dart';
import 'package:easy_job/task/viewtask.dart';
import 'package:easy_job/widgets/break_timer_mini.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  late Timer timer;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        now = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.portrait) {
              return portraitClockui();
            } else {
              return landscapeClockui();
            }
          },
        ),
        Positioned(top: 30, left: 20, child: BreakTimerMini()),
        Positioned(
          bottom: 20,
          right: 20,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: true,
                  pageBuilder: (_, __, ___) => const Studentlist(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            child: Text(
              "students",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 20,
          child: TextButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  opaque: true,
                  pageBuilder: (_, __, ___) => const Viewtask(),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
              );
            },
            child: Text(
              "task",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget portraitClockui() {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${DateTime.now().hour.toString().padLeft(2, '0')}:"
                "${DateTime.now().minute.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                "${DateTime.now().second.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "${DateTime.now().day} /${(DateTime.now().month)}/${DateTime.now().year}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget landscapeClockui() {
  return Scaffold(
    backgroundColor: Colors.black,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${DateTime.now().hour.toString().padLeft(2, '0')}:"
                "${DateTime.now().minute.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 100,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                "${DateTime.now().second.toString().padLeft(2, '0')}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "${DateTime.now().day} /${(DateTime.now().month)}/${DateTime.now().year}",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}
