// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class MediumPurpleTheme {
  // Color primario de este tema
  static const Color primary = Color(0xff6156ca);

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: primary,
    scaffoldBackgroundColor: AppNewTheme.backroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppNewTheme.backroundColor,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
    ),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: primary,
    scaffoldBackgroundColor: AppNewTheme.darkBackroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppNewTheme.darkBackroundColor,
      titleTextStyle: TextStyle(
        fontSize: 20,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
    ),
  );
}
