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
}
