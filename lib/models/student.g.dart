// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 0;

  @override
  Student read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Student(
      name: fields[0] as String,
      batch: fields[1] as String,
      classTime: fields[2] as String,
      course: fields[3] as String,
      presentDates: (fields[4] as List).cast<String>(),
      completedLessons: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(6)
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
      ..write(obj.completedLessons);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
