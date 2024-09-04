import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';

class AppNewTheme {
  static int idTema = int.tryParse(Preferences.idThemeApp) ?? 0;
  static int idColorTema = int.tryParse(Preferences.idColor) ?? 0;

  static Color backroundColor = Colors.orange.shade50;

  // Función para convertir un color hexadecimal en formato RGB
  static List<int> hexToRgb(String hexColor) {
    // Elimina el carácter '#'
    if (hexColor[0] == '#') {
      hexColor = hexColor.substring(1);
    }

    // Divide el color en componentes r, g y b
    int r = int.parse(hexColor.substring(0, 2), radix: 16);
    int g = int.parse(hexColor.substring(2, 4), radix: 16);
    int b = int.parse(hexColor.substring(4, 6), radix: 16);

    return [r, g, b];
  }

  static Color hexToColor(String hexColor) {
    // Asegurarse de que el string no tenga el carácter '#'
    hexColor = hexColor.replaceAll("#", "");

    // Convertir el string hexadecimal a entero y agregar el prefijo 0xFF para la opacidad
    return Color(int.parse("0xFF$hexColor"));
  }
}
