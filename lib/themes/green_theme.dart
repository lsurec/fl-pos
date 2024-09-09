// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class GreenTheme {
  // Colores del tema claro
  static const Color lightPrimaryColor = Colors.green;

  // Colores del tema oscuro
  static final Color darkPrimaryColor = Colors.green.shade800;

  static final ThemeData lightGreen = ThemeData.light().copyWith(
    primaryColor: lightPrimaryColor,
    scaffoldBackgroundColor: AppNewTheme.backroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppNewTheme.backroundColor,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightPrimaryColor,
    ),
  );

  static final ThemeData darkGreen = ThemeData.dark().copyWith(
    primaryColor: darkPrimaryColor,
    scaffoldBackgroundColor: AppNewTheme.darkBackroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppNewTheme.darkBackroundColor,
      titleTextStyle: TextStyle(
        fontSize: 20,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: darkPrimaryColor,
    ),
  );
}
