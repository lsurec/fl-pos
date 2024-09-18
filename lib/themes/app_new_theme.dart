import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class AppNewTheme {
  //CAMBIAR TEMA CAMBIA A 1 DESDE LOS AJUSTES
  static int cambiarTema = 0;

  static int idTema = int.tryParse(Preferences.idThemeApp) ?? 0;
  static int idColorTema = int.tryParse(Preferences.idColor) ?? 0;
  static bool oscuro = false;

  static Color white = Colors.white;
  static Color backroundColor = Colors.orange.shade50;
  static const Color darkBackroundColor = Color(0xFF242323);
  static const Color backroundSecondary = Color(0xffFEF5E7);
  static const Color backroundDarkSecondary = Color.fromARGB(255, 40, 40, 40);

  static Color divider = Colors.grey[400]!;
  static const Color dividerDark = Colors.white60;

  static const Color primary = Color(0xff134895);
  static const Color primaryDark = Color.fromARGB(255, 159, 197, 255);

  static const Color greyBorder = Color.fromRGBO(0, 0, 0, 0.12);
  static const Color greyBorderDark = Color.fromARGB(255, 112, 111, 111);

  static const Color grey = Colors.grey;

  static const Color verde = Colors.green;
  static const Color rojo = Colors.red;

  static const Color grayAppBar = Color(0xfff5f5f5);

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

  static Color colorPref(int idColor) {
    switch (idColorTema) {
      case 0: // Sistema
        return primary;
      case 1: // Azul
        return BlueTheme.primary;
      case 2: // Rojo
        return RedTheme.primary;
      case 3: // Naranja
        return OrangeTheme.primary;
      case 4: // Verde Musgo
        return OliveTheme.primary;
      case 5: // Verde
        return GreenTheme.primary;
      case 6: // Verde 2
        return GreenAccentTheme.primary;
      case 7: // Cyan
        return CyanTheme.primary;
      case 8: // Aqua
        return SteelBlueTheme.primary;
      case 9: // Lila
        return MediumPurpleTheme.primary;
      case 10: // Morado
        return PurpleTheme.primary;
      case 11: // Fucsia
        return FuchsiaTheme.primary;
      case 12: // Rosadito
        return RosyBrownTheme.primary;
      case 13: // Gris
        return GreyTheme.primary;
      default: // Default
        return LightTheme.primary;
    }
  }
}
