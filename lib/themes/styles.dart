import 'package:flutter/material.dart';
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

  static TextStyle titlegrey = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey[400]!,
  );

  static const inactive = TextStyle(
    fontSize: 17,
    color: Colors.grey,
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
}
