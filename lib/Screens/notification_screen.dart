import 'package:flutter/material.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/constants.dart';
import 'package:productive_monk/main.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // reverse: true,

      itemCount: boxList[3].length,
      itemBuilder: (BuildContext context, int index) {
        if (boxList[3]
            .values
            .cast<NotificationsBlueprint>()
            .toList()[index]
            .timeOfAlert
            .difference(DateTime.now())
            .isNegative) {
          return Dismissible(
            key: Key(index.toString()),
            background: Container(
              color: Colors.black,
            ),
            onDismissed: (dir) {
              boxList[3].deleteAt(index);
            },
            child: notificationView(index),
          );
        } else {
          return SizedBox(); //cant return null sooo
        }
      },
    );
  }
}

Widget notificationView(int index) {
  return Container(
      // height: 100,
      // margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
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
            // priorityColors[alps[index].priority],
            Colors.redAccent,
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              boxList[3]
                  .values
                  .cast<NotificationsBlueprint>()
                  .toList()[index]
                  .notificationTitle,
              style: aLittleBetter,
            ),
          ),
          Text(boxList[3]
              .values
              .cast<NotificationsBlueprint>()
              .toList()[index]
              .timeOfAlert
              .toString())
        ],
      ));
}
