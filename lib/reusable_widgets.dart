import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/Screens/home_screen.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';
import 'package:provider/provider.dart';

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
          showTf = false; //tf = textfield
        }
      } else {
        if (alt.length > 0) {
          //just need the title
          showTf = false;
        }
      }
    } else if (bl.currentPageIndex == 2) {
      showTf = false;
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

              // unless its todo, show datetime picker
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

              if (bl.currentPageIndex == 1) ...[
                Text("Priority : "),
                CustomSegmentedControl(
                  threeStrings: ["Low", "Medium", "High"],
                )
              ]
            ],
          ),
          actions: <Widget>[
            if ((alt.length >= 1 &&
                        (bl.currentScreenIndex != 2 &&
                            bl.currentPageIndex == 0) ||
                    bl.currentPageIndex == 2) ||
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
                  } else if (bl.currentPageIndex == 2) {
                    ProcrastinationReason pr = ProcrastinationReason()
                      ..dateCreated = DateTime.now()
                      ..dateOfLastOccurence = DateTime.now()
                      ..occurence = 0
                      ..reason = alt[0];
                    boxList[7].add(pr);
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
      },
    ),
  );
}
