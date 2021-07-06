import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/Screens/projects_screen.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';

import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProjectView extends StatefulWidget {
  ProjectView({
    Key? key,
    required this.projectBlueprintIndex,
  }) : super(key: key);
  final int projectBlueprintIndex;
  // final StateSetter projectState;

  @override
  _ProjectViewState createState() => _ProjectViewState();
}

class _ProjectViewState extends State<ProjectView> {
  void _saveToTotalTimeSpent(ProjectBlueprint what) {
    // boxList[0].putAt(projectBlueprintIndex, boxList[0].getAt(projectBlueprintIndex).cast<ProjectBlueprint>());
  }

  late int totalSec = boxList[0]
      .values
      .cast<ProjectBlueprint>()
      .toList()[widget.projectBlueprintIndex]
      .totalSecondsSpent;

  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _timer = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {},
    );
    _timer.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _timer.cancel();
  }

  void _saveTheTime() {
    boxList[0].putAt(
        widget.projectBlueprintIndex,
        boxList[0].getAt(widget.projectBlueprintIndex)
          ..totalSecondsSpent = totalSec);
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted)
          setState(() {
            totalSec++;
            if (totalSec % 60 == 0) {
              _saveTheTime();
            }
          });
      },
    );
  }

  Container projectTksText(int inde, String text) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      // color: cBackgroundColor,
      decoration: BoxDecoration(color: Colors.black26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "#$inde",
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            text,
            style: aLittleBetter,
          ),
        ],
      ),
    );
  }

  final colorizeTextStyle = TextStyle(
    fontSize: 50.0,
    fontFamily: 'Horizon',
  );

  @override
  Widget build(BuildContext context) {
    BLoC bl = Provider.of<BLoC>(context, listen: false);
    ProjectBlueprint projectBlueprint = boxList[0]
        .values
        .cast<ProjectBlueprint>()
        .toList()[widget.projectBlueprintIndex];

    return Hero(
        tag: "Project hero ${widget.projectBlueprintIndex}",
        child: Scaffold(
          backgroundColor: priorityColors[projectBlueprint.priority],
          appBar: AppBar(
            backgroundColor: priorityColors[projectBlueprint.priority],
            title: Text(projectBlueprint.projectName),
            elevation: 0,
          ),
          body: SlidingUpPanel(
            backdropEnabled: true,
            backdropTapClosesPanel: true,
            panel: TaskWidget(
              index: widget.projectBlueprintIndex,
              bl: bl,
              setState: setState,
            ),
            collapsed: Container(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Center(
                child: Text(
                  "slide up to Show All Tasks",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            body: SingleChildScrollView(
              // the page is basically a description and tasks list. it should also contain a timer
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.purpleAccent,
                          // priorityColors[alps[index].priority],
                          Colors.blue,
                        ],
                      ),
                    ),
                    child: Text(
                      projectBlueprint.projectDescription!,
                      style: aLittleBetter,
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  CustomTimer(
                    boxIndex: 0,
                    contentIndex: widget.projectBlueprintIndex,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      valueShower(
                          projectBlueprint.priority.toString(), "Priority"),
                      valueShower(
                          "${projectBlueprint.deadline.difference(DateTime.now()).toString().split(':')[0]} hours",
                          "Deadline"),
                      valueShower(
                          "${projectBlueprint.dateCreated.toString().split(" ")[0]}",
                          "Date created")
                    ],
                  ),
                  SizedBox(height: 100),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.redAccent[700],
                        ),
                        onPressed: () {
                          // delete
                          // print("deleting");
                          boxList[0].deleteAt(widget.projectBlueprintIndex);
                          // also delete the pending notification
                          // print("del not");
                          FlutterLocalNotificationsPlugin()
                              .cancel(int.parse("02${boxList[5].length}"));
                          // pop

                          Navigator.of(context).pop();
                          // setstate of parent but for now,
                          bl.jnl();
                        },
                        child: Text("Delete this Project"),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("close"),
                      ),
                    ],
                  ),
                  Text(
                    "Completed tasks: ",
                    style: aLittleBetter,
                  ),
                  Container(
                    height: 500,
                    padding: EdgeInsets.all(10),
                    child: ListView.builder(
                      itemCount: projectBlueprint.allTasksDone.length,
                      itemBuilder: (BuildContext context, int index) {
                        return projectTksText(
                            index, projectBlueprint.allTasksDone[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
        ));
  }
}

Container valueShower(String top, String bottom) {
  return Container(
    // width: 60,
    height: 055,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Colors.purple, Colors.blue],
        ),
        borderRadius: BorderRadius.circular(10)),
    child: Column(
      children: [
        Expanded(
            child: Text(
          top,
          style: aLittleBetter,
        )),
        Text(
          bottom,
          style: TextStyle(color: Colors.white),
        )
      ],
    ),
  );
}

class CustomTimer extends StatefulWidget {
  CustomTimer({Key? key, required this.boxIndex, required this.contentIndex})
      : super(key: key);

  @override
  _CustomTimerState createState() => _CustomTimerState();

  int boxIndex, contentIndex;
}

class _CustomTimerState extends State<CustomTimer> {
  late Timer timerr;

  void initState() {
    // TODO: implement initState
    super.initState();
    totalSec = boxList[widget.boxIndex]
        .values
        .toList()[widget.contentIndex]
        .totalSecondsSpent;
    timerr = new Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) {},
    );
    timerr.cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _saveTheTime();
    timerr.cancel();
  }

  int totalSec = 0;

  void _saveTheTime() {
    boxList[widget.boxIndex].putAt(
        widget.contentIndex,
        boxList[widget.boxIndex].getAt(widget.contentIndex)
          ..totalSecondsSpent = totalSec);
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    timerr = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (mounted)
          setState(() {
            totalSec++;
            if (totalSec % 60 == 0) {
              _saveTheTime();
            }
          });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (timerr.isActive) {
            timerr.cancel();
            _saveTheTime();
          } else {
            startTimer();
          }
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.purpleAccent,
                // priorityColors[alps[index].priority],
                Colors.blue,
              ],
            ),
            border: Border.all(color: Colors.white, width: 10),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: [
            Text(
              "Total time spent : ",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "${Duration(seconds: totalSec).toString().split('.')[0]}",
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              timerr.isActive ? "Tap to Stop timer" : "Tap to Start Working",
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
