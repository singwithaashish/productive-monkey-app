import 'dart:math';

import 'package:flutter/material.dart';
import 'package:productive_monk/BLoC/bloc.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';
import 'package:provider/provider.dart';

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
    return Consumer<BLoC>(builder: (context, bl, child) {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              margin: EdgeInsets.all(20),
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
                color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListView.builder(
                itemCount: pr.length,
                itemBuilder: (BuildContext context, int index) {
                  return projectTksText(index, pr[index].reason);
                },
              ),
            ),
            Text("Get Motivated : "),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.lightGreenAccent),
              child: Text(allQuotes['quotes']
                  [Random().nextInt(allQuotes['quotes'].length)]['quote']),
            )
          ],
        ),
      );
    });
  }
}
