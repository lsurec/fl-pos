import 'package:flutter/material.dart';

class DarkTheme {
  //COLORES
  static const Color backroundColor = Color.fromARGB(255, 48, 45, 45);
  static const Color grayAppBar = Color.fromARGB(255, 51, 50, 50);
  static const Color darkPrimary = Color.fromARGB(255, 159, 197, 255);
  static const Color backroundSecondary = Color.fromARGB(255, 68, 68, 67);
  static const Color grey = Colors.grey;
  static const Color primary = Color(0xff134895);
  static const Color iconActive = Colors.white60;
  static const Color white = Colors.white;
  static const Color icons = Color.fromARGB(255, 246, 216, 216);
  static const Color border = Color.fromARGB(255, 112, 111, 111);
  static const Color verde = Color.fromARGB(255, 96, 217, 100);
  static const Color rojo = Color.fromARGB(255, 248, 119, 109);

  //ESTILOD TEXTOS
  static const normalStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
  );

  static const normalBoldStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const obligatoryStyle = TextStyle(
    fontSize: 20,
    color: Color.fromARGB(255, 255, 30, 14),
    fontWeight: FontWeight.bold,
  );

  static const horaBoldStyle = TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
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
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const buttonsStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static final ButtonStyle buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      primary,
    ),
  );

  static const whiteBoldStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const normal20Style = TextStyle(
    fontSize: 20,
    color: Colors.white,
  );

  static const bold30Style = TextStyle(
    fontSize: 30,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const inactivoStyle = TextStyle(
    fontSize: 17,
    color: Colors.grey,
  );

  static const versionStyle = TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 235, 219, 219),
  );

  static const whiteStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
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
}
