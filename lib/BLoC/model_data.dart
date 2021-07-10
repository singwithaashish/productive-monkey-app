import 'package:hive/hive.dart';
part 'model_data.g.dart';

@HiveType(typeId: 0)
class ProjectBlueprint {
  @HiveField(0)
  String projectName = " ";

  @HiveField(1)
  int totalTasks = 0;

  @HiveField(2)
  int completedTasks = 0;

  @HiveField(3)
  DateTime dateCreated = DateTime.now();

  @HiveField(4)
  DateTime deadline = DateTime.now().add(Duration(days: 365));
  //if deadline not set, it'll expire in a year
  @HiveField(5)
  int priority = 0; //0 - low 3 - high

  @HiveField(6)
  List<String> allTasks = [];

  @HiveField(7)
  List<String> allTasksDone = [];

  @HiveField(8)
  String? projectDescription;

  @HiveField(9)
  int totalSecondsSpent = 0; //its in seconds
}

@HiveType(typeId: 1)
class RemindersBlueprint {
  @HiveField(0)
  String? whatToRemind;
  @HiveField(1)
  DateTime whenToRemind = DateTime.now();
  @HiveField(2)
  DateTime dateCreated = DateTime.now();
  @HiveField(3)
  bool done = false;
}

@HiveType(typeId: 2)
class NotesBlueprint {
  @HiveField(0)
  String? noteTitle;
  @HiveField(1)
  List<String>? notes;
  @HiveField(2)
  DateTime dateCreated = DateTime.now();

  @HiveField(3)
  bool done = false;
}

@HiveType(typeId: 3)
class NotificationsBlueprint {
  @HiveField(0)
  String notificationTitle = "Alert";
  @HiveField(1)
  DateTime timeOfAlert = DateTime.now();
  @HiveField(2)
  bool done = false;
}

@HiveType(typeId: 4)
class Misc {
  @HiveField(0)
  int totalTasksDone = 0;
  @HiveField(1)
  String username = "awesome user";
  @HiveField(2)
  bool darkMode = false;
  @HiveField(3)
  int totalTasksCancelled = 0;
  @HiveField(4)
  int avatarIndex = 0;
}

@HiveType(typeId: 5)
class Tasks {
  @HiveField(0)
  String title = " ";

  @HiveField(1)
  String? description;

  @HiveField(2)
  DateTime timeCreated = DateTime.now();

  @HiveField(3)
  DateTime? deadLine;
  @HiveField(4)
  bool done = false;

  @HiveField(5)
  int totalSecondsSpent = 0;
}

@HiveType(typeId: 6)
class ProcrastinationReason {
  @HiveField(0)
  String reason = " ";
  @HiveField(1)
  int occurence = 0;
  @HiveField(2)
  DateTime dateCreated = DateTime.now();
  @HiveField(3)
  DateTime dateOfLastOccurence = DateTime.now();
}
