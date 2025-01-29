import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class GreenAccentTheme {
  // Color primario de este tema
  static const Color primary = Color(0xff1d8763);

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: primary,
    scaffoldBackgroundColor: AppTheme.backroundColor,
    appBarTheme: AppBarTheme(
      titleTextStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      color: AppTheme.backroundColor,
      iconTheme: const IconThemeData(
        size: 30,
        color: Colors.black,
      ),
      elevation: 0,
    ),
    inputDecorationTheme: InputDecorationTheme(
      floatingLabelStyle: const TextStyle(
        color: primary,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(8),
      ),
      border: OutlineInputBorder(
        //borderSide: const BorderSide(color: primary),
        borderRadius: BorderRadius.circular(8),
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

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: primary,
    scaffoldBackgroundColor: AppTheme.darkBackroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppTheme.darkBackroundColor,
      titleTextStyle: TextStyle(
        fontSize: 20,
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
