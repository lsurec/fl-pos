// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class RedTheme {
  // Colores del tema claro
  static const Color primary = Color(0xFFFF0000);

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: primary,
    scaffoldBackgroundColor: AppTheme.backroundColor,
    appBarTheme: AppBarTheme(
      backgroundColor: AppTheme.backroundColor,
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

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: primary,
    scaffoldBackgroundColor: AppTheme.darkBackroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppTheme.darkBackroundColor,
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
      color: AppTheme.backroundDarkSecondary,
    ),
    dividerColor: AppTheme.dividerDark,
    dividerTheme: const DividerThemeData(
      color: AppTheme.dividerDark,
    ),
    tabBarTheme: const TabBarTheme(
      labelColor: Colors.white,
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
