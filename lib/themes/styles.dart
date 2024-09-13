import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class StyleApp {
  //Estilos para textos
  static const whiteBold = TextStyle(
    fontSize: 17,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const normal = TextStyle(
    fontSize: 17,
  );

  static const whiteNormal = TextStyle(
    fontSize: 17,
    color: Colors.white60,
  );

  static const normalBold = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.bold,
  );

  static TextStyle menuActive = const TextStyle(
    fontSize: 17,
    color: AppNewTheme.primary,
  );

  static TextStyle menuActiveDark = const TextStyle(
    fontSize: 17,
    color: Colors.white,
    // color: Colors.white60,
  );

  static const title = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const subTitle = TextStyle(
    fontSize: 14,
  );

  static TextStyle titlegrey = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey[400]!,
  );

  static const greyText = TextStyle(
    fontSize: 17,
    color: Colors.grey,
  );

  static const greyBold = TextStyle(
    fontSize: 17,
    color: Colors.grey,
    fontWeight: FontWeight.bold,
  );

  static const blueText = TextStyle(
    fontSize: 15,
    color: AppNewTheme.primary,
  );

  static const blueDarkText = TextStyle(
    fontSize: 15,
    color: AppNewTheme.primaryDark,
  );

  static const cargo = TextStyle(
    fontSize: 17,
    color: Colors.green,
  );

  static const descuento = TextStyle(
    fontSize: 17,
    color: Colors.red,
  );

  static const cargoDark = TextStyle(
    fontSize: 17,
    color: Color.fromARGB(255, 96, 217, 100),
  );

  static const descuentoDark = TextStyle(
    fontSize: 17,
    color: Color.fromARGB(255, 248, 119, 109),
  );

  static const green = TextStyle(
    fontSize: 17,
    color: Colors.green,
  );

  static const red = TextStyle(
    fontSize: 17,
    color: Colors.red,
  );

  static const greenDark = TextStyle(
    fontSize: 17,
    color: Color.fromARGB(255, 96, 217, 100),
  );

  static const redDark = TextStyle(
    fontSize: 17,
    color: Color.fromARGB(255, 248, 119, 109),
  );

  static const user = TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const normal20Style = TextStyle(
    fontSize: 20,
  );

  static const bold30Style = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const action = TextStyle(
    fontSize: 15,
    color: AppNewTheme.primary,
  );

  static const titleWhite = TextStyle(
    color: Colors.white,
    fontSize: 20,
  );

  static const titleBlue = TextStyle(
    fontSize: 20,
    color: AppNewTheme.primary,
    fontWeight: FontWeight.bold,
  );

  static const obligatory = TextStyle(
    fontSize: 20,
    color: Colors.red,
    fontWeight: FontWeight.bold,
  );

  static const task = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const verMas = TextStyle(
    fontSize: 12,
    color: Color.fromARGB(255, 111, 111, 111),
    fontWeight: FontWeight.w500,
  );

  static const horaBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const diasFueraMes = TextStyle(
    fontSize: 14,
    color: Color.fromARGB(255, 111, 111, 111),
  );

  static const diaHoy = TextStyle(
    fontSize: 14,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static final ButtonStyle button = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      AppNewTheme.hexToColor(
        Preferences.valueColor,
      ),
    ),
  );

  static final ButtonStyle disabledButton = ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(
      Colors.grey,
    ),
  );
}
