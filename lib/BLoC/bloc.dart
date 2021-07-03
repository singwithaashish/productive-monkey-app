import 'dart:io';

// import 'package:get/state_manager.dart';
// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:localstore/localstore.dart';
import 'package:productive_monk/BLoC/model_data.dart';
import 'package:productive_monk/main.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class BLoC extends ChangeNotifier {
  BLoC() {
    initialize();
  }
  // DataToSave allAppData = DataToSave();
  final db = Localstore.instance;

  int currentPageIndex = 0;
  int currentScreenIndex = 0;

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void initialize() {
    if (boxList[4].isEmpty) {
      boxList[4].add(Misc());
    }
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

// this should navigate us to notification
// page but cant do this without context

  Future onSelectNotification(String? payload) async {
    // showDialog(
    //   context: context,
    //   builder: (_) {
    //     return new AlertDialog(
    //       title: Text("Your Notification Detail"),
    //       content: Text("Payload : $payload"),
    //     );
    //   },
    // );
  }

  void addTask(Tasks tsk) {
    boxList[5].add(tsk);
    notifyListeners();
  }

  void addProjects(ProjectBlueprint prj) {
    boxList[0].add(prj);
    notifyListeners();
  }

  void addNotes(NotesBlueprint nt) {
    boxList[2].add(nt);
    notifyListeners();
  }

  void addReminders(RemindersBlueprint rm) {
    boxList[1].add(rm);
    //also set a timer and notification for the deadline
    notifyListeners();
  }

  Misc getMisc() {
    return boxList[4].values.cast<Misc>().toList()[0];
  }

  void updateMisc(Misc m) {
    boxList[4].putAt(0, m);
  }

// used to update any consumer widget
  void jnl() {
    notifyListeners();
  }

// call this function to schedule notification
  Future<void> addToNotification(DateTime when, String what) async {
    boxList[3].add(NotificationsBlueprint()
      ..notificationTitle = what
      ..timeOfAlert = when);
    // add the shownotif thing here
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.max, priority: Priority.high);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.zonedSchedule(
        3,
        'Productive Monkey', //check if task and say its a reminder or deadline
        '$what',
        tz.TZDateTime.from(
            when, tz.local), //.now(tz.local).add(const Duration(seconds: 5)),
        const NotificationDetails(
            android: AndroidNotificationDetails('your channel id',
                'your channel name', 'your channel description')),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
