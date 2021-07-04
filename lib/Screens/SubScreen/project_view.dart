import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/Screens/projects_screen.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';

import 'package:provider/provider.dart';

class ProjectView extends StatelessWidget {
  ProjectView({Key? key, required this.projectBlueprintIndex})
      : super(key: key);
  final int projectBlueprintIndex;

  void _saveToTotalTimeSpent(ProjectBlueprint what) {
    // boxList[0].putAt(projectBlueprintIndex, boxList[0].getAt(projectBlueprintIndex).cast<ProjectBlueprint>());
  }

  late Timer timer;
  // late DateTime timeSpent = DateTime(0, 0, 0, 0, 0);
  int testSec = 0;
  //     .values
  //     .cast<ProjectBlueprint>()
  //     .toList()[projectBlueprintIndex]
  //     .totalTimeSpent!;

  void sTimer(StateSetter setState) {
    if (timer.isActive) timer.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        // timeSpent.add(Duration(seconds: 1));
        testSec++;
        print(testSec);
      });
    });

    // if(timeSpent.second %59 == 0)
    // {
    //   _saveToTotalTimeSpent(what)
    // }
  }

  @override
  Widget build(BuildContext context) {
    BLoC bl = Provider.of<BLoC>(context, listen: false);
    ProjectBlueprint projectBlueprint = boxList[0]
        .values
        .cast<ProjectBlueprint>()
        .toList()[projectBlueprintIndex];

    DateTime timespent = projectBlueprint.totalTimeSpent ?? DateTime(0);
    return Scaffold(
      appBar: AppBar(
        title: Text(projectBlueprint.projectName!),
        elevation: 0,
      ),
      body: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return SingleChildScrollView(
            // the page is basically a description and tasks list. it should also contain a timer
            child: Column(
              children: [
                Text(
                  projectBlueprint.projectDescription!,
                  style: aLittleBetter,
                ),

                Text(
                  "${timespent.hour} : ${timespent.minute} : ${timespent.second}",
                  style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (timer.isActive) {
                      timer.cancel();
                    } else {
                      sTimer(setState);
                    }
                  },
                  child: Text("Start/stop timer"),
                ),
                // the tasks added are saved as well
                TaskWidget(
                  index: projectBlueprintIndex,
                  bl: bl,
                  setState: setState,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
