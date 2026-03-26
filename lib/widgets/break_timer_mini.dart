import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class BreakTimerMini extends StatefulWidget {
  const BreakTimerMini({super.key});

  @override
  State<BreakTimerMini> createState() => _BreakTimerMiniState();
}

class _BreakTimerMiniState extends State<BreakTimerMini>
    with WidgetsBindingObserver {
  late Box breakBox;
  Timer? _timer;

  Duration totalBreak = const Duration(minutes: 5);
  Duration currentTime = const Duration(minutes: 5);

  bool isRunning = false;
  bool isCountingUp = false;

  DateTime lastUsedDate = DateTime.now();

  // ─────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    breakBox = Hive.box('breakTime');

    final savedMinutes = breakBox.get('totalBreakMinutes');
    if (savedMinutes != null) {
      totalBreak = Duration(minutes: savedMinutes);
      currentTime = totalBreak;
    }

    final savedDate = breakBox.get('lastUsedDate');
    if (savedDate != null) {
      lastUsedDate = DateTime.parse(savedDate);
    }
  }

  // ─────────────────────────────────────────────
  // LIFECYCLE HANDLING (THIS IS THE MAGIC)
  // ─────────────────────────────────────────────

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && isRunning) {
      _restoreElapsedTime();
    }
  }

  void _restoreElapsedTime() {
    final saved = breakBox.get('lastStartTime');
    if (saved == null) return;

    final startTime = DateTime.parse(saved);
    final elapsedSeconds = DateTime.now().difference(startTime).inSeconds;

    if (elapsedSeconds <= 0) return;

    setState(() {
      if (!isCountingUp) {
        final remaining = currentTime.inSeconds - elapsedSeconds;
        if (remaining > 0) {
          currentTime = Duration(seconds: remaining);
        } else {
          isCountingUp = true;
          currentTime = Duration(seconds: remaining.abs());
        }
      } else {
        currentTime += Duration(seconds: elapsedSeconds);
      }
    });

    breakBox.put('lastStartTime', DateTime.now().toIso8601String());
  }

  // ─────────────────────────────────────────────
  // TIMER CONTROLS
  // ─────────────────────────────────────────────

  void toggleTimer() {
    if (isRunning) {
      _pause();
    } else {
      _start();
    }
  }

  void _start() {
    _checkNewDay();
    isRunning = true;

    breakBox.put('lastStartTime', DateTime.now().toIso8601String());

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _tick();
    });
  }

  void _pause() {
    _timer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void _tick() {
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
  }

  // ─────────────────────────────────────────────
  // DAILY RESET
  // ─────────────────────────────────────────────

  void _checkNewDay() {
    final today = DateTime.now();
    if (!_isSameDay(today, lastUsedDate)) {
      currentTime = totalBreak;
      isCountingUp = false;
      lastUsedDate = today;

      breakBox.put('lastUsedDate', today.toIso8601String());
    }
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  // ─────────────────────────────────────────────
  // FORMAT
  // ─────────────────────────────────────────────

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  // ─────────────────────────────────────────────
  // PICK BREAK DURATION
  // ─────────────────────────────────────────────

  void _openDurationPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      builder: (_) {
        return ListView.builder(
          itemCount: 61,
          itemBuilder: (_, i) => ListTile(
            title: Text(
              '$i minutes',
              style: const TextStyle(color: Colors.white, fontSize: 22),
            ),
            onTap: () {
              setState(() {
                totalBreak = Duration(minutes: i);
                currentTime = totalBreak;
                isCountingUp = false;
              });

              breakBox.put('totalBreakMinutes', i);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleTimer,
      onLongPress: _openDurationPicker,
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade800),
          boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 10)],
        ),
        child: MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.noScaling),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isRunning ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 40,
              ),
              const SizedBox(width: 12),
              Text(
                _format(currentTime),
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'RobotoMono',
                  color: isCountingUp ? Colors.red : Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
