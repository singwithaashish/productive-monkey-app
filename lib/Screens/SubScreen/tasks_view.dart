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
                  // Colors.purpleAccent,
                  cPrimaryColor,
                  // Colors.blue,
                  cThemeColor
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
        color: cPrimaryColor,
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
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white),
            ),
          ),
          Text(
            tsktsk.description ?? '',
            style: TextStyle(color: Colors.white),
          )
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
