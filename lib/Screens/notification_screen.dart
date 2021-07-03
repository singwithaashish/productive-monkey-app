import 'package:flutter/material.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/main.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: boxList[3].length,
      itemBuilder: (BuildContext context, int index) {
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
        color: Colors.amber[200],
        // borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(boxList[3]
                .values
                .cast<NotificationsBlueprint>()
                .toList()[index]
                .notificationTitle),
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
