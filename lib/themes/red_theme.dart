// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class RedTheme {
  // Colores del tema claro
  static const Color lightPrimaryColor = Colors.red;

  // Colores del tema oscuro
  static final Color darkPrimaryColor = Colors.red.shade800;

  static final ThemeData lightRed = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightPrimaryColor,
    scaffoldBackgroundColor: AppNewTheme.backroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightPrimaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightPrimaryColor,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Colors.black,
      ),
      bodyText2: TextStyle(
        color: Colors.black,
      ),
    ),
  );

  static final ThemeData darkRed = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: darkPrimaryColor,
      titleTextStyle: const TextStyle(
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkPrimaryColor,
    ),
    textTheme: const TextTheme(
      bodyText1: TextStyle(
        color: Colors.white,
      ),
      bodyText2: TextStyle(
        color: Colors.white,
      ),
    ),
  );
}
