import 'package:flutter/material.dart';
import 'package:task_manager/gen/fonts.gen.dart';

final ThemeData themeData = new ThemeData(
    fontFamily: FontFamily.openSans,
    brightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.green),
    primaryColor: Colors.green,
    primaryColorBrightness: Brightness.light,
    accentColor: Colors.green,
    accentColorBrightness: Brightness.light,
    textTheme: const TextTheme(
      headline4: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w900),
      headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      subtitle1: TextStyle(
          fontSize: 14.0, fontStyle: FontStyle.normal, color: Colors.grey),
    ));

final ThemeData themeDataDark = ThemeData(
  fontFamily: FontFamily.openSans,
  brightness: Brightness.dark,
  primaryColor: Colors.red,
  primaryColorBrightness: Brightness.dark,
  accentColor: Colors.red,
  accentColorBrightness: Brightness.dark,
);
