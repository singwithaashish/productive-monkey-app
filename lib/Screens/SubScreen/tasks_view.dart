// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:hive/hive.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/Screens/home_screen.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';
// import 'package:hive/hive.dart';
// import 'package:get/get.dart';

import 'package:provider/provider.dart';

class TaskView extends StatefulWidget {
  const TaskView({Key? key}) : super(key: key);

  @override
  _TaskViewState createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final GlobalKey<AnimatedListState> tasksGlobalKey =
      new GlobalKey<AnimatedListState>();
  final Tween<Offset> _tween = Tween(begin: Offset(0, -10), end: Offset(0, 0));
  MaterialColor dismissibleBgColor = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Consumer<BLoC>(builder: (context, bl, child) {
      return ListView.builder(
          // clipBehavior: Clip.none,
          key: tasksGlobalKey,
          itemCount: bl.currentScreenIndex == 0
              ? boxList[2].length // 0 > notes
              : bl.currentScreenIndex == 1
                  ? boxList[1].length // 1 > reminder
                  : boxList[5].length, // else or 2 > tasks
          itemBuilder: (context, index) {
            // tsk = [];

            return Dismissible(
                key: Key(index.toString()),
                onDismissed: (direction) {
                  // we can use same function with condition on what current page is
                  // to delete respective pages

                  // task complete
                  // put green background
                  if (direction == DismissDirection.startToEnd) {
                    dismissibleBgColor = Colors.green;
                    if (bl.currentScreenIndex == 0) {
                      boxList[2].deleteAt(index);
                    } else if (bl.currentScreenIndex == 1) {
                      // boxList[1].deleteAt(index);
                      // // also delete the pending notification
                      // // also add to completed reminder
                      // Map<int, int> tmp = boxList[4]
                      //     .values
                      //     .cast<Misc>()
                      //     .first
                      //     .tasksProgressPerDate;
                      // tmp[int.parse("${DateTime.now().year}" +
                      //     "${DateTime.now().month}" +
                      //     "${DateTime.now().day}")] = tmp[int.parse(
                      //         "${DateTime.now().year}" +
                      //             "${DateTime.now().month}" +
                      //             "${DateTime.now().day}")]! +
                      //     1;

                      // boxList[4].putAt(0, tmp);
                    } else if (bl.currentScreenIndex == 2) {
                      boxList[5].deleteAt(index);
                      // also delete the pending notification
                      // also add to completed tasks
                      // Map<int, int> tmp = boxList[4]
                      //     .values
                      //     .cast<Misc>()
                      //     .first
                      //     .tasksProgressPerDate;
                      // tmp[int.parse("${DateTime.now().year}" +
                      //     "${DateTime.now().month}" +
                      //     "${DateTime.now().day}")] = tmp[int.parse(
                      //         "${DateTime.now().year}" +
                      //             "${DateTime.now().month}" +
                      //             "${DateTime.now().day}")]! +
                      //     1;

                      // boxList[4].putAt(0, tmp);
                    }
                  } else if (direction == DismissDirection.endToStart) {
                    dismissibleBgColor = Colors.red;
                    if (bl.currentScreenIndex == 0) {
                      boxList[2].deleteAt(index);
                    } else if (bl.currentScreenIndex == 1) {
                      boxList[1].deleteAt(index);
                      // also delete the pending notification
                    } else if (bl.currentScreenIndex == 2) {
                      boxList[5].deleteAt(index);
                      // also delete the pending notification
                    }
                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task #$index dismissed')));
                },
                background: Container(
                  color: dismissibleBgColor,
                ),
                child: bl.currentScreenIndex == 2
                    ? viewTasks(
                        boxList[5].values.cast<Tasks>().toList()[index], index)
                    : bl.currentScreenIndex == 0
                        ? animatedNotes(index)
                        : animatedReminders(index));
          });
    });
  }
}

Widget viewTasks(Tasks tsktsk, int index) {
  return Container(
    // height: 100,
    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
      ],
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
              child: Text(
            "Task #$index",
            style: TextStyle(color: Colors.grey),
          )),
          Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: cPrimaryColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "⏰ ${DateTime.now().difference(tsktsk.deadLine!).inHours}",
                style: aLittleBetter,
              ))
        ]),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            tsktsk.title ?? 'NO TITLE',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        Text(tsktsk.description ?? '')
      ],
    ),
  );
}

Widget animatedNotes(int index) {
  return Container(
      // height: 100,
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Text(
          boxList[2].values.cast<NotesBlueprint>().toList()[index].notes![0]));
}

Widget animatedReminders(int index) {
  return Container(
      // height: 100,
      margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black12,
          offset: const Offset(
            5.0,
            5.0,
          ),
          blurRadius: 10.0,
          spreadRadius: 2.0,
        ),
      ], color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: Text(boxList[1]
                    .values
                    .cast<RemindersBlueprint>()
                    .toList()[index]
                    .whatToRemind ??
                ""),
          ),
          Text(boxList[1]
              .values
              .cast<RemindersBlueprint>()
              .toList()[index]
              .whenToRemind
              .toString())
        ],
      ));
}

void showAddStuffPopup(BuildContext context) {
  TextEditingController tec = new TextEditingController();
  // this stores everything submitted. this allows us to have a single textfield
  List<String> alt = [];
  DateTime ddline = DateTime.now().add(Duration(days: 30));
  BLoC bl = Provider.of<BLoC>(context, listen: false);
  bool showTf = true, ddlinePicked = false;
  showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: new Text('TODO'),
              //refresh the alertdialoug everytime something is entered
              content: Column(
                children: [
                  // if alt[0] exist, show it
                  if (alt.length > 0)
                    Text(
                      alt[0],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  // ^^
                  if (alt.length > 1)
                    Text(
                      alt[1],
                      style: TextStyle(color: Colors.grey),
                    ),
                  // the remaining can only be tasks
                  for (int i = 2; i < alt.length; i++)
                    if (alt.length > 2) Text(alt[i]),

                  if (showTf)
                    TextField(
                      // maxLines: 10,
                      decoration: InputDecoration(
                          hintText: alt.length == 0
                              ? "Enter Title"
                              : alt.length == 1
                                  ? "A few words"
                                  : "Enter Tasks",
                          helperText: "Press ENTER to ADD"),
                      controller: tec,
                      onSubmitted: (va) {
                        alt.add(va);
                        tec.clear();
                        if (bl.currentPageIndex == 0) {
                          if (bl.currentScreenIndex == 2) {
                            if (alt.length == 2) {
                              showTf = false;
                            }
                          } else {
                            if (alt.length > 0) {
                              //just need the title
                              showTf = false;
                            }
                          }
                        }
                        setState(() {});
                      },
                    ),
                  // we now need a clock for datetime selection

                  if (bl.currentPageIndex == 1 || bl.currentScreenIndex != 0)
                    ElevatedButton(
                      onPressed: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true, minTime: DateTime.now(),
                            // maxTime: DateTime(2019, 6, 7),
                            onChanged: (date) {
                          print('change $date');
                        }, onConfirm: (date) {
                          print('confirm $date');
                          ddline = date;
                          ddlinePicked = true;
                          setState(() {});
                        }, currentTime: DateTime.now());
                      },
                      child: Text(ddlinePicked
                          ? "${ddline.toString()}"
                          : "Pick a deadline"),
                    ),

                  if (bl.currentPageIndex == 1)
                    CustomSegmentedControl(
                      threeStrings: ["meh", "important", "vvimp"],
                    )
                ],
              ),
              actions: <Widget>[
                if ((alt.length >= 1 &&
                        bl.currentScreenIndex != 2 &&
                        bl.currentPageIndex == 0) ||
                    alt.length >= 2)
                  new ElevatedButton(
                    onPressed: () {
                      // just copy paste code from the add button here
                      if (bl.currentPageIndex == 0) {
                        if (bl.currentScreenIndex == 0) {
                          bl.addNotes(NotesBlueprint()..notes = [alt[0]]);
                        } else if (bl.currentScreenIndex == 1) {
                          bl.addReminders(RemindersBlueprint()
                            ..whatToRemind = alt[0]
                            ..whenToRemind = ddline);
                          // add to notification and set notif timer
                          bl.addToNotification(ddline, alt[0]);
                        } else {
                          Tasks tsk = Tasks()
                            ..deadLine = DateTime.now()
                            ..description = alt[1]
                            ..title = alt[0]
                            ..timeCreated = DateTime.now()
                            ..deadLine = ddline;
                          bl.addTask(tsk);
                          // add to notification and set notif timer
                          bl.addToNotification(ddline, alt[0]);
                        }
                      } else if (bl.currentPageIndex == 1) {
                        ProjectBlueprint pb = ProjectBlueprint()
                          ..allTasks = alt
                          ..completedTasks = 0
                          ..totalTasks = alt.length - 2
                          ..projectName = alt[0]
                          ..projectDescription = alt[1]
                          ..deadline = ddline
                          ..priority = bl.currentScreenIndex;

                        bl.addProjects(pb);
                        // add to notification and set notif timer
                        bl.addToNotification(
                            ddline, "project '${alt[0]}' has expired");
                      }

                      // show a task added toast

                      Navigator.of(context, rootNavigator: true)
                          .pop(); // dismisses only the dialog and returns nothing
                    },
                    child: new Text('OK'),
                  ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: cPrimaryColor),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    child: Text("Close"))
              ],
            );
          }));
}
