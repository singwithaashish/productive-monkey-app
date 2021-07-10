import 'dart:math';

import 'package:flutter/material.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';

class SelfHelp extends StatefulWidget {
  const SelfHelp({Key? key}) : super(key: key);

  @override
  _SelfHelpState createState() => _SelfHelpState();
}

class _SelfHelpState extends State<SelfHelp> {
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

  @override
  Widget build(BuildContext context) {
    List<ProcrastinationReason> pr =
        boxList[7].values.cast<ProcrastinationReason>().toList();
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height / 2,
          child: ListView.builder(
            itemCount: pr.length,
            itemBuilder: (BuildContext context, int index) {
              return projectTksText(index, pr[index].reason);
            },
          ),
        ),
        Center(
          child: Column(
            children: [
              Text(allQuotes['quotes']
                  [Random().nextInt(allQuotes['quotes'].length)]['quote'])
            ],
          ),
        )
      ],
    );
  }
}
