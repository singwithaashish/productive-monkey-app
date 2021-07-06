// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/Screens/SubScreen/project_view.dart';
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
                // confirmDismiss: areYouSure,
                onDismissed: (direction) {
                  if (bl.currentScreenIndex == 0) {
                    boxList[2].deleteAt(index);
                  } else if (bl.currentScreenIndex == 1) {
                    boxList[1].deleteAt(index);
                    FlutterLocalNotificationsPlugin()
                        .cancel(int.parse("01${boxList[1].length}"));
                  } else if (bl.currentScreenIndex == 2) {
                    boxList[5].deleteAt(index);
                    // also delete the pending notification
                    FlutterLocalNotificationsPlugin()
                        .cancel(int.parse("02${boxList[5].length}"));
                    // also add to completed tasks

                  }

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task #$index dismissed')));
                },
                background: Container(
                  color: dismissibleBgColor,
                ),
                child: bl.currentScreenIndex == 2
                    ? viewTasks(boxList[5].values.cast<Tasks>().toList()[index],
                        index, context)
                    : bl.currentScreenIndex == 0
                        ? animatedNotes(index)
                        : animatedReminders(index));
          });
    });
  }
}

Widget viewTasks(Tasks tsktsk, int index, BuildContext context) {
  return GestureDetector(
    onTap: () {
      showBottomSheet(
        backgroundColor: Colors.black12,
        context: context,
        builder: (context) => Container(
            margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 1.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.purpleAccent,
                  Colors.blue,
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  tsktsk.title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                // SizedBox(height: 20),
                Text(
                  tsktsk.description!,
                  style: aLittleBetter,
                ),
                CustomTimer(boxIndex: 5, contentIndex: index),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Deadline in ${tsktsk.deadLine!.difference(DateTime.now()).inHours} hours",
                      style: aLittleBetter,
                    ),
                    Divider(
                      height: 10,
                      thickness: 10,
                      color: Colors.white,
                    ),
                    Text(
                      "Created on ${tsktsk.timeCreated.toString().split(" ")[0]}",
                      style: aLittleBetter,
                    )
                  ],
                )
              ],
            )),
      );
    },
    child: Container(
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
                "⏰ ${tsktsk.deadLine!.difference(DateTime.now()).inHours}",
                style: aLittleBetter,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: cThemeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "🕛 ${Duration(seconds: tsktsk.totalSecondsSpent).toString().split('.')[0]}",
                style: aLittleBetter,
              ),
            )
          ]),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              tsktsk.title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          Text(tsktsk.description ?? '')
        ],
      ),
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
            child: Text(
              boxList[1]
                      .values
                      .cast<RemindersBlueprint>()
                      .toList()[index]
                      .whatToRemind ??
                  "",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
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

  void _onAdded(String what, StateSetter setState) {
    alt.add(what);
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
  }

  showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              backgroundColor: Colors.blueGrey,
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
                        helperText: "Press ENTER to ADD",
                        suffixIcon: IconButton(
                          onPressed: () {
                            _onAdded(tec.text, setState);
                          },
                          icon: Icon(Icons.add),
                        ),
                      ),
                      controller: tec,
                      onSubmitted: (va) {
                        _onAdded(va, setState);
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
                  Text("Priority : "),
                  if (bl.currentPageIndex == 1)
                    CustomSegmentedControl(
                      threeStrings: ["Low", "Medium", "High"],
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
                          bl.addToNotification(
                              ddline, alt[0], "01${boxList[1].length}");
                        } else {
                          Tasks tsk = Tasks()
                            ..deadLine = DateTime.now()
                            ..description = alt[1]
                            ..title = alt[0]
                            ..timeCreated = DateTime.now()
                            ..deadLine = ddline;
                          bl.addTask(tsk);
                          // add to notification and set notif timer
                          bl.addToNotification(
                              ddline, alt[0], "02${boxList[5].length}");
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
                            ddline,
                            "project '${alt[0]}' has expired",
                            "11${boxList[0].length}");
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
