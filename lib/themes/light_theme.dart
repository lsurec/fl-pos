// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class LightTheme {
  // Colores del tema claro
  static const Color primary = Color(0xff134895);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primary,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppTheme.backroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppTheme.backroundColor,
      titleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primary,
      foregroundColor: AppTheme.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
    ),
    cardTheme: const CardTheme(
      color: AppTheme.backroundSecondary,
    ),
    dividerColor: AppTheme.divider,
    dividerTheme: DividerThemeData(
      color: AppTheme.divider,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.black,
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
