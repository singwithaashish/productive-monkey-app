import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';

class ProgressScreen extends StatelessWidget {
  ProgressScreen({Key? key}) : super(key: key);
  final Misc allUserData = boxList[4].values.cast<Misc>().first;

  // List<FlSpot> allFLs = [];

  @override
  Widget build(BuildContext context) {
    // allUserData.tasksProgressPerDate.forEach((key, value) {
    //   print(key);
    //   allFLs.add(
    //       FlSpot(double.parse(key.toString()), double.parse(value.toString())));
    // });

    // allUserData.tasksProgressPerDate.forEach((key, value) {
    //   print(key + value);
    // });

    return SingleChildScrollView(
      // controller: controller,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 4,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  // color: Colors.black12,
                  offset: const Offset(
                    5.0,
                    5.0,
                  ),
                  blurRadius: 10.0,
                  spreadRadius: 2.0,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.purple, cPrimaryColor],
              ),
              borderRadius: BorderRadius.circular(20),
            ),

            // color: cPrimaryColor,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        avatars[
                            boxList[4].values.cast<Misc>().first.avatarIndex],
                        fit: BoxFit.cover,
                      ),
                    ),
                    Text(
                      "Your Progress",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Tasks Completed: ${allUserData.totalTasksDone}",
                      style: aLittleBetter,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Tasks remaining: ${boxList[5].length}",
                      style: aLittleBetter,
                    ),
                    Text(
                      "projects remaining : ${boxList[0].length}",
                      style: aLittleBetter,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Notes saved: ${boxList[2].length}",
                      style: aLittleBetter,
                    ),
                    Text(
                      "pending remainders : ${boxList[1].length}",
                      style: aLittleBetter,
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              // gradient: LinearGradient(
              //   begin: Alignment.centerLeft,
              //   end: Alignment.centerRight,
              //   colors: [Colors.purple, Colors.blue],
              // ),
              color: cPrimaryColor,
            ),
            child: Column(
              children: [
                Text(
                  "Help Us by ",
                  style: aLittleBetter,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: cThemeColor),
                      onPressed: () {
                        // ! navigate to app screen
                      },
                      child: Text("Rating our app"),
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: cThemeColor),
                        onPressed: () {
                          // !sharing
                        },
                        child: Text("Sharing it 💌"))
                  ],
                )
              ],
            ),
            // child: LineChart(
            //   LineChartData(
            //     axisTitleData: FlAxisTitleData(
            //       leftTitle:
            //           AxisTitle(titleText: "Tasks Completed", showTitle: true),
            //       show: true,
            //       bottomTitle: AxisTitle(titleText: "Date", showTitle: true),
            //     ),
            //     backgroundColor: cPrimaryColor,
            //     // clipData: FlClipData.(),
            //     lineBarsData: [
            //       LineChartBarData(
            //         isCurved: true, barWidth: 10, spots: allFLs,

            //         // fl
            //         //  [
            //         //   FlSpot(12, 2),
            //         //   FlSpot(15, 8),
            //         //   FlSpot(20, 5),
            //         // ],
            //       )
            //     ],
            //   ),
            //   swapAnimationDuration: Duration(milliseconds: 150), // Optional
            //   swapAnimationCurve: Curves.linear, // Optional
            // ),
          ),
        ],
      ),
    );
  }
}
