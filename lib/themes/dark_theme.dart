import 'package:flutter/material.dart';

class DarkTheme {
  //COLORES
  static const Color darkDackroundColor = Color.fromARGB(255, 48, 45, 45);
  static const Color darkPrimary = Color.fromARGB(255, 159, 197, 255);
  static const Color darkBackroundSecondary = Color.fromARGB(255, 68, 68, 67);

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

  static const subTitleStyle = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 206, 192, 192),
  );
}
