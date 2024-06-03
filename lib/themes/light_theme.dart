import 'package:flutter/material.dart';

class LightTheme {
  //COLORES
  //Color primario de la app
  static const Color primary = Color(0xff134895);
  static const Color grey = Colors.grey;

  static const Color grayAppBar = Color(0xfff5f5f5);
  static const Color secondary = Color(0xff1C82AD);
  static const Color activeStep = Color(0xffcccccc);
  static const Color disableStep = primary;
  static const Color disableStepPrimary = Color(0xFF636564);
  static const Color disableStepSecondary = Color(0xFFBABABA);
  static const Color disableStepLine = Color(0xFFDADADA);
  static Color backroundColor = Colors.orange.shade50;
  static const Color backroundColorSecondary = Color(0xffFEF5E7);
  static const Color white = Colors.white;
  static const Color black = Colors.black;

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
    fontSize: 12,
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

  static const inactivoStyle = TextStyle(
    fontSize: 17,
    color: Colors.grey,
  );

  static const diasFueraMes = TextStyle(
    fontSize: 17,
    color: Color.fromARGB(255, 111, 111, 111),
    fontWeight: FontWeight.bold,
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
}
