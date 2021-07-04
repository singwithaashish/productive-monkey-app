import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/Screens/projects_screen.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';

import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProjectView extends StatefulWidget {
  ProjectView({Key? key, required this.projectBlueprintIndex})
      : super(key: key);
  final int projectBlueprintIndex;

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

  final colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

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
                children: [
                  Text(
                    projectBlueprint.projectDescription!,
                    style: aLittleBetter,
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Text(
                    "Time Spent here: ",
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "${Duration(seconds: totalSec).toString().split('.')[0]}",
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // AnimatedTextKit(animatedTexts: [
                  //   ColorizeAnimatedText(
                  //     "${Duration(seconds: totalSec).toString().split('.')[0]}",
                  //     textStyle: colorizeTextStyle,
                  //     colors: colorizeColors,
                  //   ),
                  // ]),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(elevation: 0),
                    onPressed: () {
                      setState(() {
                        if (_timer.isActive) {
                          _timer.cancel();
                          _saveTheTime();
                        } else {
                          startTimer();
                        }
                      });
                    },
                    child: Text(
                      _timer.isActive ? "Stop timer" : "Start Working",
                    ),
                  ),
                  // CircularProgressIndicator(
                  //   value: int.parse(Duration(seconds: totalSec)
                  //           .toString()
                  //           .split(':')[2]
                  //           .split('.')[0]) /
                  //       60,
                  // )
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

class CustomTimer extends StatefulWidget {
  CustomTimer({Key? key}) : super(key: key);

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: null,
    );
  }
}
