import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeProvider({required int theme}) {
    switch (theme) {
      case 1:
        //tema claro
        themeMode = ThemeMode.light;
        break;
      case 2:
        //Tema oscuro
        themeMode = ThemeMode.dark;
        break;
      case 3:
        //Definido por el sitema
        themeMode = ThemeMode.system;
        break;
      default:
        //Definido por el sitema
        themeMode = ThemeMode.system;
        break;
    }
  }

  setDark() {
    themeMode = ThemeMode.dark;
    notifyListeners();
  }

  setLigth() {
    themeMode = ThemeMode.light;
    notifyListeners();
  }

  setSystem() {
    themeMode = ThemeMode.system;
    notifyListeners();
  }

  ThemeMode themeMode = ThemeMode.system;
}
