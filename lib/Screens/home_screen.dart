import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/Screens/SubScreen/tasks_view.dart';
import 'package:productive_monk/constants.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
            child: CustomSegmentedControl(
          threeStrings: ["TODO", "REMINDERS", "TASKS"],
        )),
        Expanded(child: TaskView()),
      ],
    );
  }
}

class CustomSegmentedControl extends StatefulWidget {
  const CustomSegmentedControl({Key? key, required this.threeStrings})
      : super(key: key);
  final List<String> threeStrings;
  // final String a = "asd";
  @override
  _CustomSegmentedControlState createState() => _CustomSegmentedControlState();
}

//creates the sliding toggle. change page based on
// segmentcontrolgrpval and make sure its animated
class _CustomSegmentedControlState extends State<CustomSegmentedControl> {
  late Map<int, Widget> myTabs = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myTabs = <int, Widget>{
      0: Text(
        widget.threeStrings[0],
        style: TextStyle(color: Colors.white),
      ),
      1: Text(
        widget.threeStrings[1],
        style: TextStyle(color: Colors.white),
      ),
      2: Text(
        widget.threeStrings[2],
        style: TextStyle(color: Colors.white),
      )
    };
  }

  @override
  Widget build(BuildContext context) {
    BLoC bl = Provider.of<BLoC>(context, listen: false);
    int segmentedControlGroupValue = bl.currentScreenIndex;
    return CupertinoSlidingSegmentedControl(
        padding: EdgeInsets.all(5),
        thumbColor: cPrimaryColor,
        backgroundColor: Colors.grey,
        groupValue: segmentedControlGroupValue,
        children: myTabs,
        onValueChanged: (i) {
          bl.currentScreenIndex = int.parse(i.toString());
          bl.jnl();
          setState(() {
            segmentedControlGroupValue = int.parse(i.toString());
          });
        });
  }
}
