import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/constants/app_theme.dart';
import 'package:task_manager/services/NotificationService.dart';
import 'package:task_manager/services/SharedPrefService.dart';
import 'package:task_manager/ui/MainPage.dart';
import 'package:task_manager/ui/home/HomePage.dart';
import 'package:task_manager/ui/login/LoginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await SharedPrefService().intPref();
  runApp(MyApp());
}

Future selectNotification(String? payload) async {
  if (payload != null) {
    debugPrint('notification payload: $payload');
  }
  // await Navigator.push(
  //   context,
  //   MaterialPageRoute<void>(builder: (context) => SecondScreen(payload)),
  // );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var isUserLoggedIn = SharedPrefService().isUserLoggedIn();
    var currentUserId = SharedPrefService().getCurrentUserId();
    return MaterialApp(
      title: 'Task manager',
      theme: themeData,
      home:
          isUserLoggedIn && currentUserId.isNotEmpty ? MainPage() : LoginPage(),
    );
  }
}
