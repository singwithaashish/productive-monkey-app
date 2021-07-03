import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
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
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) =>
              //           ProjectView(projectBlueprintIndex: index)),
              // );
              // clear the cursor
              // PrjTskTxt.clear();
              showDialog(
                  context: context,
                  // its a stateful builder so that its
                  // updated everytime something is added to it
                  builder: (context) => StatefulBuilder(builder:
                          (BuildContext context, StateSetter setState) {
                        return AlertDialog(
                          title: new Text('TODO'),
                          content: TaskWidget(
                            // PrjTskTxt: PrjTskTxt,
                            index: index,
                            // alps: alps,
                            bl: bl,
                            setState: setState,
                          ),
                          actions: <Widget>[
                            new ElevatedButton(
                              onPressed: () {
                                // add element to box with the key
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: cThemeColor),
                              child: new Text('Delete'),
                            ),
                            new ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: cPrimaryColor),
                              onPressed: () {
                                Navigator.of(context, rootNavigator: true)
                                    .pop(); // dismisses only the dialog and returns nothing
                              },
                              child: new Text('close'),
                            ),
                          ],
                        );
                      }));
            },
            child: Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                // color: alps[index].priority == 0 ? Colors.green : Colors.red,
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
                    Colors.purple,
                    alps[index].priority == 0 ? Colors.green : Colors.red,
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset('Assets/priority_1.png'),
                  Text(
                    alps[index].projectName ?? "none",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    alps[index].projectDescription ?? "",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          backgroundColor: cSecondaryColor,
                          value: ((alps[index].allTasks ?? []).length /
                              (alps[index].allTasksDone ?? ['']).length),
                          // value: 0.6,
                          minHeight: 10,
                          color: cPrimaryColor,
                        ),
                      ),
                      Text('5/6')
                    ],
                  )
                ],
              ),
            ),
          );
        }),
      );
    });
  }
}

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 600,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Expanded(
          child: ListView.builder(
            itemCount: boxList[0]
                .values
                .cast<ProjectBlueprint>()
                .toList()[index]
                .allTasks!
                .length,
            itemBuilder: (BuildContext context, int inde) {
              return Dismissible(
                key: Key(inde.toString()),
                background: Container(
                  color: Colors.amber,
                ),
                onDismissed: (dir) {
                  // gotta update at inde, man
                  alps[index].allTasks!.removeAt(inde);
                  ProjectBlueprint value = alps[index];
                  // put the updated value back
                  boxList[0].putAt(index, value);
                },
                child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    // color: cBackgroundColor,
                    decoration: BoxDecoration(color: Colors.black26),
                    child: Text(
                      alps[index].allTasks![inde],
                    )),
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
              alps[index].allTasks!.add(va);
              ProjectBlueprint tm = alps[index];
              PrjTskTxt.clear();
              //get a temp value, modify it with va and putat
              boxList[0].putAt(index, tm);
              bl.jnl();
              setState(() {});
            },
            decoration: InputDecoration(
                hintText: "Add new Taks ..", helperText: "Press ENTER to add"),
          ),
        )
      ]),
    );
  }
}

// this is the project screen

