// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProjectBlueprintAdapter extends TypeAdapter<ProjectBlueprint> {
  @override
  final int typeId = 0;

  @override
  ProjectBlueprint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectBlueprint()
      ..projectName = fields[0] as String
      ..totalTasks = fields[1] as int
      ..completedTasks = fields[2] as int
      ..dateCreated = fields[3] as DateTime
      ..deadline = fields[4] as DateTime
      ..priority = fields[5] as int
      ..allTasks = (fields[6] as List).cast<String>()
      ..allTasksDone = (fields[7] as List).cast<String>()
      ..projectDescription = fields[8] as String?
      ..totalSecondsSpent = fields[9] as int;
  }

  @override
  void write(BinaryWriter writer, ProjectBlueprint obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.projectName)
      ..writeByte(1)
      ..write(obj.totalTasks)
      ..writeByte(2)
      ..write(obj.completedTasks)
      ..writeByte(3)
      ..write(obj.dateCreated)
      ..writeByte(4)
      ..write(obj.deadline)
      ..writeByte(5)
      ..write(obj.priority)
      ..writeByte(6)
      ..write(obj.allTasks)
      ..writeByte(7)
      ..write(obj.allTasksDone)
      ..writeByte(8)
      ..write(obj.projectDescription)
      ..writeByte(9)
      ..write(obj.totalSecondsSpent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectBlueprintAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RemindersBlueprintAdapter extends TypeAdapter<RemindersBlueprint> {
  @override
  final int typeId = 1;

  @override
  RemindersBlueprint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RemindersBlueprint()
      ..whatToRemind = fields[0] as String?
      ..whenToRemind = fields[1] as DateTime
      ..dateCreated = fields[2] as DateTime
      ..done = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, RemindersBlueprint obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.whatToRemind)
      ..writeByte(1)
      ..write(obj.whenToRemind)
      ..writeByte(2)
      ..write(obj.dateCreated)
      ..writeByte(3)
      ..write(obj.done);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemindersBlueprintAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotesBlueprintAdapter extends TypeAdapter<NotesBlueprint> {
  @override
  final int typeId = 2;

  @override
  NotesBlueprint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotesBlueprint()
      ..noteTitle = fields[0] as String?
      ..notes = (fields[1] as List?)?.cast<String>()
      ..dateCreated = fields[2] as DateTime
      ..done = fields[3] as bool;
  }

  @override
  void write(BinaryWriter writer, NotesBlueprint obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.noteTitle)
      ..writeByte(1)
      ..write(obj.notes)
      ..writeByte(2)
      ..write(obj.dateCreated)
      ..writeByte(3)
      ..write(obj.done);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesBlueprintAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class NotificationsBlueprintAdapter
    extends TypeAdapter<NotificationsBlueprint> {
  @override
  final int typeId = 3;

  @override
  NotificationsBlueprint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationsBlueprint()
      ..notificationTitle = fields[0] as String
      ..timeOfAlert = fields[1] as DateTime
      ..done = fields[2] as bool;
  }

  @override
  void write(BinaryWriter writer, NotificationsBlueprint obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.notificationTitle)
      ..writeByte(1)
      ..write(obj.timeOfAlert)
      ..writeByte(2)
      ..write(obj.done);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsBlueprintAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class MiscAdapter extends TypeAdapter<Misc> {
  @override
  final int typeId = 4;

  @override
  Misc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Misc()
      ..totalTasksDone = fields[0] as int
      ..username = fields[1] as String
      ..darkMode = fields[2] as bool
      ..totalTasksCancelled = fields[3] as int
      ..avatarIndex = fields[4] as int;
  }

  @override
  void write(BinaryWriter writer, Misc obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.totalTasksDone)
      ..writeByte(1)
      ..write(obj.username)
      ..writeByte(2)
      ..write(obj.darkMode)
      ..writeByte(3)
      ..write(obj.totalTasksCancelled)
      ..writeByte(4)
      ..write(obj.avatarIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MiscAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TasksAdapter extends TypeAdapter<Tasks> {
  @override
  final int typeId = 5;

  @override
  Tasks read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Tasks()
      ..title = fields[0] as String
      ..description = fields[1] as String?
      ..timeCreated = fields[2] as DateTime
      ..deadLine = fields[3] as DateTime?
      ..done = fields[4] as bool
      ..totalSecondsSpent = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, Tasks obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.timeCreated)
      ..writeByte(3)
      ..write(obj.deadLine)
      ..writeByte(4)
      ..write(obj.done)
      ..writeByte(5)
      ..write(obj.totalSecondsSpent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TasksAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
