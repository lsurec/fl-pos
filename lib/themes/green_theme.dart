// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class GreenTheme {
  // Colores del tema claro
  static const Color lightPrimaryColor = Colors.green;

  // Colores del tema oscuro
  static final Color darkPrimaryColor = Colors.green.shade800;

  static final ThemeData lightGreen = ThemeData.light().copyWith(
    // brightness: Brightness.light,
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
    // textTheme: const TextTheme(
    //   bodyText1: TextStyle(
    //     color: Colors.black,
    //   ),
    //   bodyText2: TextStyle(
    //     color: Colors.black,
    //   ),
    // ),
  );

  static final ThemeData darkGreen = ThemeData.dark().copyWith(
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
