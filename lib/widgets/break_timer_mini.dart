import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BreakTimerMini extends StatefulWidget {
  const BreakTimerMini({super.key});

  @override
  State<BreakTimerMini> createState() => _BreakTimerMiniState();
}

class _BreakTimerMiniState extends State<BreakTimerMini> {
  late Box breakbox;

  @override
  void initState() {
    super.initState();
    breakbox = Hive.box('breakTime');
    final savedMinutes = breakbox.get("totalBreakMinutes");
    if (savedMinutes != null) {
      totalBreak = Duration(minutes: savedMinutes);
      currentTime = totalBreak;
    }
  }

  Timer? _timer;

  Duration totalBreak = const Duration(minutes: 5);
  Duration currentTime = const Duration(minutes: 3);

  bool isRunning = false;
  bool isCountingUp = false;

  DateTime lastUsedDate = DateTime.now();

  void toggleTimer() {
    if (isRunning) {
      pause();
    } else {
      start();
    }
  }

  void start() {
    checkNewDay();
    isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (!isCountingUp) {
          if (currentTime.inSeconds > 0) {
            currentTime -= const Duration(seconds: 1);
          } else {
            isCountingUp = true;
            currentTime += const Duration(seconds: 1);
          }
        } else {
          currentTime += const Duration(seconds: 1);
        }
      });
    });
  }

  void pause() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void checkNewDay() {
    final today = DateTime.now();
    if (!isSameDay(today, lastUsedDate)) {
      currentTime = totalBreak;
      isCountingUp = false;
      lastUsedDate = today;
    }
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  String format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  void openDurationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (_) {
        return ListView.builder(
          itemCount: 61,
          itemBuilder: (_, i) => ListTile(
            title: Text(
              "$i minutes",
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
            onTap: () {
              setState(() {
                totalBreak = Duration(minutes: i);
                currentTime = totalBreak;
                isCountingUp = false;
              });
              breakbox.put("totalBreakMinutes", i);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleTimer,
      onLongPress: openDurationPicker,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade800),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
        ),
        height: 64,
        alignment: Alignment.center,
        child: MediaQuery(
          // 🔥 THIS PREVENTS SUB-PIXEL SCALING ARTIFACTS
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: Row(
            children: [
              Icon(
                isRunning ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
              SizedBox(width: 12),
              Text(
                format(currentTime),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono', // 👈 BEST for timers
                  color: isCountingUp ? Colors.red : Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
