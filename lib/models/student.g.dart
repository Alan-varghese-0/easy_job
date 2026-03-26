// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 0;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Student(
      name: fields[0],
      batch: fields[1],
      classTime: fields[2],
      course: fields[3],
      presentDates: (fields[4] as List).cast<String>(),
      completedLessons: (fields[5] as List).cast<String>(),
      roadmapType: fields[6] ?? "flutter", // safe
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.batch)
      ..writeByte(2)
      ..write(obj.classTime)
      ..writeByte(3)
      ..write(obj.course)
      ..writeByte(4)
      ..write(obj.presentDates)
      ..writeByte(5)
      ..write(obj.completedLessons)
      ..writeByte(6)
      ..write(obj.roadmapType);
  }
}
