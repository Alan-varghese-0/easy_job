import 'package:hive/hive.dart';

part 'student.g.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String batch;
  @HiveField(2)
  String classTime;
  @HiveField(3)
  String course;
  @HiveField(4)
  List<String> presentDates;
  @HiveField(5)
  List<String> completedLessons = [];
  Student({
    required this.name,
    required this.batch,
    required this.classTime,
    required this.course,
    required this.presentDates,
    required this.completedLessons,
  });
}
