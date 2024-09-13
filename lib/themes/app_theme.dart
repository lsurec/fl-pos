// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class AppTheme {
  //CAMBIAR TEMA CAMBIA A 1 DESDE LOS AJUSTES
  static int cambiarTema = 0;

  //Color primario de la app
  static const Color primary = Color(0xff134895);
  static Color backroundColor = Colors.orange.shade50;
  static const Color black = Colors.black;

  static final ButtonStyle disabledButtonsStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
  );

  static final ButtonStyle buttonsStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(primary),
  );

  //Tema claro
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primary,
    appBarTheme: AppBarTheme(
      color: backroundColor,
      iconTheme: const IconThemeData(
        size: 30,
        color: Colors.black,
      ),
      elevation: 0,
    ),
    scaffoldBackgroundColor: backroundColor,
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // ignore: deprecated_member_use
        primary: primary,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        // ignore: deprecated_member_use
        primary: primary,
        elevation: 0,
        shape: const StadiumBorder(),
      ),
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
  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primary,
    ),
  );
}
