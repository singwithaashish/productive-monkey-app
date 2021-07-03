import 'package:flutter/material.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/Screens/projects_screen.dart';
import 'package:productive_monk/main.dart';

import 'package:provider/provider.dart';

class ProjectView extends StatelessWidget {
  const ProjectView({Key? key, required this.projectBlueprintIndex})
      : super(key: key);
  final int projectBlueprintIndex;
  @override
  Widget build(BuildContext context) {
    BLoC bl = Provider.of<BLoC>(context, listen: false);
    ProjectBlueprint projectBlueprint = boxList[0]
        .values
        .cast<ProjectBlueprint>()
        .toList()[projectBlueprintIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(projectBlueprint.projectName!),
      ),
      body: SingleChildScrollView(
        // controller: controller,

        // the page is basically a description and tasks list. it should also contain a timer
        child: Column(
          children: [
            Text(projectBlueprint.projectDescription!),
            StatefulBuilder(
              builder: (BuildContext context, setState) {
                return TaskWidget(
                  index: projectBlueprintIndex,
                  bl: bl,
                  setState: setState,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
