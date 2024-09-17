// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class LightTheme {
  //COLORES
  //Color primario de la app
  static const Color primary = Color(0xff134895);
  static const Color grey = Colors.grey;
  static const Color grayAppBar = Color(0xfff5f5f5);
  static const Color disableStepLine = Color(0xFFDADADA);
  static Color backroundColor = Colors.orange.shade50;
  static const Color backroundColorSecondary = Color(0xffFEF5E7);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static Color border = Colors.grey[400]!;
  static const Color verde = Colors.green;
  static const Color rojo = Colors.red;
  static const Color greyBorder = Color.fromRGBO(0, 0, 0, 0.12);
  static const Color transparent = Colors.transparent;
  static Color divider = Colors.grey[400]!;

  //ESTILOS DE LO TEXTOS

  static const normalStyle = TextStyle(
    fontSize: 17,
    color: Colors.black,
  );
  static const normalBoldStyle = TextStyle(
    fontSize: 17,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const horaBoldStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const whiteBoldStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const whiteStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
  );

  static const titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle titlegrey = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: border,
  );

  static const obligatoryBoldStyle = TextStyle(
    fontSize: 20,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  static const tareaStyle = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 78, 77, 77),
    fontWeight: FontWeight.w500,
  );

  static const verMas = TextStyle(
    fontSize: 12,
    color: Color.fromARGB(255, 111, 111, 111),
    fontWeight: FontWeight.w500,
  );

  static const inactive = TextStyle(
    fontSize: 17,
    color: Colors.grey,
  );

  static const diasFueraMes = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 111, 111, 111),
  );

  static const taskStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  static const subTitleStyle = TextStyle(
    fontSize: 14,
    color: Colors.black,
  );

  static const disabledStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const buttonsStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const titleWhite = TextStyle(
    color: Colors.white,
    fontSize: 20,
  );

  static final ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      primary,
    ),
  );

  static const normal20Style = TextStyle(
    fontSize: 20,
    color: Colors.black,
  );

  static const bold30Style = TextStyle(
    fontSize: 30,
    color: Colors.black,
    fontWeight: FontWeight.bold,
  );

  static const versionStyle = TextStyle(
    fontSize: 16,
    color: Colors.grey,
  );

  static const menuActiveStyle = TextStyle(
    fontSize: 17,
    color: primary,
  );

  static const actionStyle = TextStyle(
    fontSize: 15,
    color: primary,
  );

  static const cargDesc = TextStyle(
    fontSize: 17,
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  static const cargo = TextStyle(
    fontSize: 17,
    color: Colors.green,
  );

  static const descuento = TextStyle(
    fontSize: 17,
    color: Colors.red,
  );

  static const green = TextStyle(
    fontSize: 17,
    color: Colors.green,
  );

  static const red = TextStyle(
    fontSize: 17,
    color: Colors.red,
  );

  static const azul = TextStyle(
    fontSize: 14,
    color: primary,
    decoration: TextDecoration.underline,
  );

  static const blueText = TextStyle(
    fontSize: 15,
    color: primary,
  );

  static const blueTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: primary,
  );

  //dia hoy
  static const diaHoy = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // Colores del tema claro
  static const Color lightPrimaryColor = Color(0xff134895);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
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
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightPrimaryColor,
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
  );
}
