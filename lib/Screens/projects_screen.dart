import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/Screens/SubScreen/project_view.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';

// import 'package:hive/hive.dart';

import 'package:provider/provider.dart';

class ProjectsScreen extends StatelessWidget {
  ProjectsScreen({Key? key}) : super(key: key);
  // final TextEditingController PrjTskTxt = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<BLoC>(builder: (context, bl, child) {
      return GridView.count(
        // Create a grid with 2 columns. If you change the scrollDirection to
        // horizontal, this produces 2 rows.
        crossAxisCount: 2,
        // Generate 100 widgets that display their index in the List.
        children: List.generate(boxList[0].length, (index) {
          List<ProjectBlueprint> alps =
              boxList[0].values.cast<ProjectBlueprint>().toList();
          return Hero(
            tag: "Project hero $index",
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProjectView(projectBlueprintIndex: index),
                  ),
                );
              },
              child: projectBox(alps, index),
            ),
          );
        }),
      );
    });
  }

  Container projectBox(List<ProjectBlueprint> alps, int index) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // color: Colors.purple,
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
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.purpleAccent,
            priorityColors[alps[index].priority],
            Colors.purple,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset('Assets/priority_1.png'),
          Icon(Icons.looks),
          Text(
            alps[index].projectName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Flexible(
            child: Text(
              alps[index].projectDescription ?? "",
              style: TextStyle(
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: LinearProgressIndicator(
                  backgroundColor: cPrimaryColor,
                  value: (alps[index].allTasksDone.length /
                      (alps[index].allTasks.length +
                          alps[index].allTasksDone.length)),
                  // value: 0.6,
                  minHeight: 10,
                  color: cPrimaryColor,
                ),
              ),
              Text(
                  ' ${alps[index].allTasksDone.length}/${(alps[index].allTasks.length + alps[index].allTasksDone.length)}')
            ],
          )
        ],
      ),
    );
  }
}

// shows all tasks in this project
class TaskWidget extends StatelessWidget {
  TaskWidget({
    Key? key,
    // required this.PrjTskTxt,
    required this.index,
    // required this.alps,
    required this.bl,
    required this.setState,
  }) : super(key: key);

  final TextEditingController PrjTskTxt = new TextEditingController();
  final int index;
  final List<ProjectBlueprint> alps =
      boxList[0].values.cast<ProjectBlueprint>().toList();
  final BLoC bl;
  final StateSetter setState;

  void _onTaskEntered() {
    if (PrjTskTxt.text == '') return;
    alps[index].allTasks.add(PrjTskTxt.text);
    ProjectBlueprint tm = alps[index];
    PrjTskTxt.clear();
    //get a temp value, modify it with va and putat
    boxList[0].putAt(index, tm);
    bl.jnl();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 600,
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.purpleAccent,
            Colors.blue,
            Colors.redAccent,
          ],
        ),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
          child: ListView.builder(
            itemCount: boxList[0]
                .values
                .cast<ProjectBlueprint>()
                .toList()[index]
                .allTasks
                .length,
            itemBuilder: (BuildContext context, int inde) {
              return Dismissible(
                key: Key(inde.toString()),
                background: Container(
                  color: Colors.amber,
                ),
                onDismissed: (dir) {
                  // gotta update at inde, man
                  alps[index].allTasksDone.add(alps[index].allTasks[inde]);
                  alps[index].allTasks.removeAt(inde);
                  ProjectBlueprint value = alps[index];
                  // put the updated value back
                  boxList[0].putAt(index, value);
                  setState(() {});
                },
                child: projectTasksText(inde, alps[index].allTasks[inde]),
              );
            },
          ),
        ),
        Container(
          margin: EdgeInsets.all(10),
          padding: EdgeInsets.all(10),
          child: TextField(
            controller: PrjTskTxt,
            onSubmitted: (va) {
              _onTaskEntered();
            },
            decoration: InputDecoration(
              hintText: "Add new Taks ..",
              helperText: "Press ENTER to add",
              suffixIcon: IconButton(
                onPressed: _onTaskEntered,
                icon: Icon(Icons.add),
              ),
            ),
          ),
        )
      ]),
    );
  }

  Container projectTasksText(int inde, String text) {
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
}

// this is the project screen

