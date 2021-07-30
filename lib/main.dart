import 'package:flutter/material.dart';
import 'package:task_manager/constants/app_theme.dart';
import 'package:task_manager/ui/login/LoginPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task manager',
      theme: themeData,
      home: LoginPage(),
    );
  }
}
