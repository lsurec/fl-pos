// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class DarkTheme {
  // Colores del tema claro
  static const Color primary = Color(0xff134895);

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
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
    cardTheme: const CardTheme(
      color: AppNewTheme.backroundDarkSecondary,
    ),
    dividerColor: AppNewTheme.dividerDark,
    dividerTheme: const DividerThemeData(
      color: AppNewTheme.dividerDark,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(
            color: primary,
            fontSize: 17,
          ),
        ),
        foregroundColor: MaterialStateProperty.all<Color>(
          primary,
        ),
      ),
    ),
  );
}
