// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class BlueTheme {
  // Colores del tema claro
  static const Color lightPrimaryColor = Color(0xff134895);

  // Colores del tema oscuro
  static const Color darkPrimaryColor = Color(0xff134895);

  static final ThemeData lightGreen = ThemeData(
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

  static final ThemeData darkGreen = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkPrimaryColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimaryColor,
      titleTextStyle: TextStyle(
        color: Colors.white,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
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
