import 'package:flutter/material.dart';

class AppTheme {
  //Color primario de la app
  static const Color primary = Color(0xff134895);
  static const Color grayAppBar = Color(0xfff5f5f5);
  static const Color secondary = Color(0xff1C82AD);
  static const Color activeStep = Color(0xffcccccc);
  static const Color disableStep = primary;
  static const Color disableStepPrimary = Color(0xFF636564);
  static const Color disableStepSecondary = Color(0xFFBABABA);
  static const Color disableStepLine = Color(0xFFDADADA);
  static Color backroundColor = Colors.orange.shade50;
  static const Color backroundColorSecondary = Color(0xffFEF5E7);

  static const normalStyle = TextStyle(
    fontSize: 17,
    color: Colors.black,
  );
  static const normalBoldStyle = TextStyle(
    fontSize: 17,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
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
}
