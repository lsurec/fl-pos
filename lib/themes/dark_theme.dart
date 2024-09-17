// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class DarkTheme {
  //COLORES
  static const Color backroundColor = Color.fromARGB(255, 48, 45, 45);
  static const Color grayAppBar = Color.fromARGB(255, 51, 50, 50);
  static const Color darkPrimary = Color.fromARGB(255, 159, 197, 255);
  static const Color backroundSecondary = Color.fromARGB(255, 40, 40, 40);
  static const Color grey = Colors.grey;
  static const Color primary = Color(0xff134895);
  static const Color iconActive = Colors.white60;
  static const Color white = Color.fromARGB(255, 211, 204, 204);
  static const Color icons = Color.fromARGB(255, 246, 216, 216);
  static const Color border = Color.fromARGB(255, 112, 111, 111);
  static const Color verde = Color.fromARGB(255, 96, 217, 100);
  static const Color rojo = Color.fromARGB(255, 248, 119, 109);
  static const Color greyBorder = Color.fromARGB(255, 112, 111, 111);
  static const Color transparent = Colors.transparent;
  static const Color disableStepSecondary = Color(0xFFBABABA);
  static const Color text = Color.fromARGB(255, 235, 219, 219);
  static const Color titleText = Color.fromARGB(255, 138, 131, 131);
  static const Color black = Colors.black;
  static const Color loading = Colors.black;
  static const Color divider = Colors.white60;

  //ESTILOD TEXTOS
  static const normalStyle = TextStyle(
    fontSize: 17,
    color: white,
  );

  static const normalBoldStyle = TextStyle(
    fontSize: 17,
    color: white,
    fontWeight: FontWeight.bold,
  );

  static const obligatoryStyle = TextStyle(
    fontSize: 20,
    color: Color.fromARGB(255, 255, 30, 14),
    fontWeight: FontWeight.bold,
  );

  static const horaBoldStyle = TextStyle(
    fontSize: 14,
    color: white,
    fontWeight: FontWeight.bold,
  );

  static const titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: white,
  );

  static const titlegrey = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey,
  );

  static const subTitleStyle = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 206, 192, 192),
  );

  static const disabledStyle = TextStyle(
    fontSize: 17,
    color: white,
    fontWeight: FontWeight.bold,
  );

  static const buttonsStyle = TextStyle(
    fontSize: 17,
    color: white,
    fontWeight: FontWeight.bold,
  );

  static final ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      primary,
    ),
  );

  static const whiteBoldStyle = TextStyle(
    fontSize: 17,
    color: white,
    fontWeight: FontWeight.bold,
  );

  static const normal20Style = TextStyle(
    fontSize: 20,
    color: white,
  );

  static const bold30Style = TextStyle(
    fontSize: 30,
    color: white,
    fontWeight: FontWeight.bold,
  );

  static const inactive = TextStyle(
    fontSize: 17,
    color: Colors.grey,
  );

  static const versionStyle = TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 235, 219, 219),
  );

  static const whiteStyle = TextStyle(
    fontSize: 17,
    color: white,
  );

  static const titleWhite = TextStyle(
    color: white,
    fontSize: 20,
  );

  static const user = TextStyle(
    color: white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const menuActiveStyle = TextStyle(
    fontSize: 17,
    color: darkPrimary,
  );

  static const actionStyle = TextStyle(
    fontSize: 15,
    color: darkPrimary,
  );

  static const cargDesc = TextStyle(
    fontSize: 17,
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  static const cargo = TextStyle(
    fontSize: 17,
    color: Color.fromARGB(255, 96, 217, 100),
  );

  static const descuento = TextStyle(
    fontSize: 17,
    color: Color.fromARGB(255, 248, 119, 109),
  );

  static const green = TextStyle(
    fontSize: 17,
    color: Color.fromARGB(255, 96, 217, 100),
  );

  static const red = TextStyle(
    fontSize: 17,
    color: Color.fromARGB(255, 248, 119, 109),
  );

  static const azul = TextStyle(
    fontSize: 14,
    color: darkPrimary,
    decoration: TextDecoration.underline,
  );

  static const blueText = TextStyle(
    fontSize: 15,
    color: darkPrimary,
  );

  static const diasFueraMes = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 159, 150, 150),
    fontWeight: FontWeight.bold,
  );

  static const taskStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: white,
  );

  static const verMas = TextStyle(
    fontSize: 12,
    color: Color.fromARGB(255, 207, 191, 191),
    fontWeight: FontWeight.w500,
  );

  static const blueTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: darkPrimary,
  );

  // Colores del tema claro
  static const Color darkPrimaryColor = Color(0xff134895);

  static final ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppNewTheme.darkBackroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppNewTheme.darkBackroundColor,
      titleTextStyle: TextStyle(
        fontSize: 20,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkPrimaryColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimaryColor,
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
  );
}
