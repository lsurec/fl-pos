import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

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

  setLigth() {
    themeMode = ThemeMode.light;
    Preferences.themeMode = 1;
    notifyListeners();
  }

  setDark() {
    themeMode = ThemeMode.dark;
    Preferences.themeMode = 2;
    notifyListeners();
  }

  setSystem() {
    themeMode = ThemeMode.system;
    Preferences.themeMode = 3;
    notifyListeners();
  }
}
