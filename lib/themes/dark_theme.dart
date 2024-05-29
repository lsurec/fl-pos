import 'package:flutter/material.dart';

class DarkTheme {
  //COLORES
  static const Color darkDackroundColor = Color.fromARGB(255, 48, 45, 45);
  static const Color darkPrimary = Color.fromARGB(255, 159, 197, 255);
  static const Color darkBackroundSecondary = Color.fromARGB(255, 68, 68, 67);



  //ESTILOD TEXTOS
  static const darkNormalStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
  );

  static const darkNormalBoldStyle = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const darkObligatoryBoldStyle = TextStyle(
    fontSize: 20,
    color: Color.fromARGB(255, 255, 30, 14),
    fontWeight: FontWeight.bold,
  );

  static const darkHoraBoldStyle = TextStyle(
    fontSize: 12,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );
}
