import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:task_manager/models/task.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  NotificationService._internal();
  factory NotificationService() {
    return _notificationService;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future<bool?> requestPermissions() async {
    return flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // showNotification() async {
  //   print("Show Notification");
  //   const IOSNotificationDetails iOSPlatformChannelSpecifics =
  //       IOSNotificationDetails(
  //     presentAlert:
  //         true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  //     presentBadge:
  //         true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
  //   );
  //   const NotificationDetails platformChannelSpecifics =
  //       NotificationDetails(iOS: iOSPlatformChannelSpecifics);
  //   await flutterLocalNotificationsPlugin.show(
  //     12345,
  //     "A Notification From My Application",
  //     "This notification was sent using Flutter Local Notifcations Package",
  //     platformChannelSpecifics,
  //     payload: 'data',
  //   );

  //   print("Notification show done");
  // }

  showNotification() async {
    print("Show Notification");
    await flutterLocalNotificationsPlugin.show(
      12345,
      "A Notification From My Application",
      "This notification was sent using Flutter Local Notifcations Package",
      _getNotificationDetails(),
      payload: 'data',
    );

    print("Notification show done");
  }

  _getNotificationDetails() {
    return NotificationDetails(
        iOS: _getIosNotificationDetails(),
        android: _getAndroidNotificationDetails());
  }

  _getAndroidNotificationDetails() {
    return AndroidNotificationDetails(
      "reminderID", //Required for Android 8.0 or after
      "reminder", //Required for Android 8.0 or after
      "It is reminder channel", //Required for Android 8.0 or after
      importance: Importance.high,
      priority: Priority.high,
    );
  }

  _getIosNotificationDetails() {
    return IOSNotificationDetails(
      presentAlert:
          true, // Present an alert when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
      presentBadge:
          true, // Present the badge number when the notification is displayed and the application is in the foreground (only from iOS 10 onwards)
    );
  }

  sheduleNotification(Task task, int timeInMillis) async {
    print("Sheduling Notification");
    await flutterLocalNotificationsPlugin.zonedSchedule(
        task.id,
        "Reminder for Task",
        "${task.title}",
        tz.TZDateTime.now(tz.local).add(Duration(
          milliseconds: timeInMillis,
        )),
        _getNotificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
    return;
  }

  Future selectNotification(String? payload) async {
    //Handle notification tapped logic here

    print("selectNotification");
  }

  Future onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    print("onDidReceiveLocalNotification");
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title!),
    //     content: Text(body!),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               builder: (context) => SecondScreen(payload),
    //             ),
    //           );
    //         },
    //       )
    //     ],
    //   ),
    // );
  }
}
