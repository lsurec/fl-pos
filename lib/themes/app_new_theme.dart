import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';

class AppNewTheme {
  static int idTema = int.tryParse(Preferences.idThemeApp) ?? 0;
  static int idColorTema = int.tryParse(Preferences.idColor) ?? 0;
  static bool oscuro = false;
  static Color backroundColor = Colors.orange.shade50;
  static const Color darkBackroundColor = Color(0xFF242323);
  static const Color backroundSecondary = Color(0xffFEF5E7);
  static const Color backroundDarkSecondary = Color.fromARGB(255, 40, 40, 40);

  static Color divider = Colors.grey[400]!;
  static const Color dividerDark = Colors.white60;

  static const Color primary = Color(0xff134895);
  static const Color primaryDark = Color.fromARGB(255, 159, 197, 255);

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

  static bool isDark() {
    if (oscuro && idTema == 0) {
      return true;
    }

    if (idTema == 2) {
      return true;
    }

    return false;
  }

  static TextStyle style(
    TextStyle claro,
    TextStyle oscuro,
  ) {
    if (isDark()) {
      return oscuro;
    }
    return claro;
  }
}
