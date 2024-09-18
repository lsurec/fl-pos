import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class FuchsiaTheme {
  // Color primario de este tema
  static const Color primary = Color(0xffab367a);

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
    cardTheme: const CardTheme(
      color: AppNewTheme.backroundSecondary,
    ),
    dividerColor: AppNewTheme.divider,
    dividerTheme: DividerThemeData(
      color: AppNewTheme.divider,
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
