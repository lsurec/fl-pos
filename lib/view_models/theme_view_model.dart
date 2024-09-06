// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:restart_app/restart_app.dart';

class ThemeViewModel extends ChangeNotifier {
  //controlar prcesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  nuevoTema(BuildContext context, ThemeModel tema) async {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    final bool isLightMode = brightness == Brightness.light;

    if (AppTheme.cambiarTema == 1 && tema.id != Preferences.idLanguage) {
      //mostrar dialogo de confirmacion
      bool result = await showDialog(
            context: context,
            builder: (context) => AlertWidget(
              textOk: AppLocalizations.of(context)!.translate(
                BlockTranslate.botones,
                "reiniciar",
              ),
              textCancel: AppLocalizations.of(context)!.translate(
                BlockTranslate.botones,
                "cancelar",
              ),
              title: AppLocalizations.of(context)!.translate(
                BlockTranslate.home,
                "tema",
              ),
              description: AppLocalizations.of(context)!.translate(
                BlockTranslate.notificacion,
                "reiniciar",
              ),
              onOk: () => Navigator.of(context).pop(true),
              onCancel: () => Navigator.of(context).pop(false),
            ),
          ) ??
          false;

      if (!result) return;

      Preferences.theme = tema.id;
      Preferences.idTheme = tema.id.toString();

      notifyListeners();

      isLoading = true;
      timer = Timer(const Duration(milliseconds: 1500), () {
        // Ocultar teclado y reiniciar App
        FocusScope.of(context).unfocus(); //ocultar teclado
        reiniciarApp();
      });
    }

    if (tema.id == 0 && isLightMode) {
      Preferences.systemTheme = "1";
    } else if (tema.id == 0 && isDarkMode) {
      Preferences.systemTheme = "2";
    }

    Preferences.theme = tema.id;
    Preferences.idTheme = tema.id.toString();

    notifyListeners();
  }

  List<ThemeModel> temasApp(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    final bool isLightMode = brightness == Brightness.light;
    return [
      ThemeModel(
        id: 0,
        descripcion: AppLocalizations.of(context)!.translate(
          BlockTranslate.home,
          'temaDispositivo',
        ),
        theme: isLightMode
            ? AppTheme.lightTheme
            : isDarkMode
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
      ),
      ThemeModel(
        id: 1,
        descripcion: AppLocalizations.of(context)!.translate(
          BlockTranslate.home,
          'claro',
        ),
        theme: AppTheme.lightTheme,
      ),
      ThemeModel(
        id: 2,
        descripcion: AppLocalizations.of(context)!.translate(
          BlockTranslate.home,
          'oscuro',
        ),
        theme: AppTheme.darkTheme,
      )
    ];
  }

  Timer? timer; // Temporizador

  void reiniciarTemp(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    final bool isLightMode = brightness == Brightness.light;

    if (Preferences.idTheme.isEmpty && isLightMode) {
      Preferences.idTheme = "0";
      Preferences.systemTheme = "1";
      notifyListeners();

      Navigator.pushNamed(context, AppRoutes.api);
      return;
    }

    if (Preferences.idTheme.isEmpty && isDarkMode) {
      Preferences.idTheme = "0";
      Preferences.systemTheme = "2";
      notifyListeners();
      Navigator.pushNamed(context, AppRoutes.api);
      return;
    }

    isLoading = true;
    timer = Timer(const Duration(milliseconds: 1500), () {
      // Ocultar teclado y reiniciar App
      FocusScope.of(context).unfocus(); //ocultar teclado
      reiniciarApp();
    });
  }

  reiniciarApp() {
    /// Fill webOrigin only when your new origin is different than the app's origin
    Restart.restartApp();
  }

  Icon getThemeIcon(BuildContext context, String tema) {
    // Encontrar el tema del dispositivo
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    // si es oscuro
    final bool isDarkMode = brightness == Brightness.dark;

    if (Preferences.idTheme == "0") {
      // Si no coincide con "1" o "2", usar la lógica original
      tema = isDarkMode ? "2" : "1";
    }
    // Verificar si Preferences.systemTheme tiene longitud mayor que 0
    else if (Preferences.systemTheme.isNotEmpty && Preferences.theme == 0) {
      // Determinar el tema a utilizar basado en Preferences.systemTheme
      switch (Preferences.systemTheme) {
        case "1":
          tema = "1"; // Tema claro
          break;
        case "2":
          tema = "2"; // Tema oscuro
          break;
        default:
          // Si no coincide con "1" o "2", usar la lógica original
          tema = isDarkMode ? "2" : "1";
          break;
      }
    }

    if (tema == "1") {
      return const Icon(
        Icons.light_mode_outlined,
      );
    } else if (tema == "2") {
      return const Icon(
        Icons.dark_mode_outlined,
      );
    }
    return const Icon(
      Icons.light_mode_outlined,
    );
  }

  ThemeData selectedPreferencesTheme = LightTheme.lightTheme;

  ThemeData get selectedTheme => selectedPreferencesTheme;

  void validarColorTema(BuildContext context, int idTema) {
    AppNewTheme.idTema = idTema;
    Preferences.idThemeApp = AppNewTheme.idTema.toString();
    Preferences.idColor = AppNewTheme.idColorTema.toString();
    Preferences.valueColor = obtenerColor(context, Preferences.idColor);
    notifyListeners();

    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;

    // Selección de tema y color
    switch (AppNewTheme.idTema) {
      case 1: // Tema Claro
        selectedPreferencesTheme = getThemeByColor(
          AppNewTheme.idColorTema,
          isDarkMode: false,
        );
        break;
      case 2: // Tema Oscuro
        selectedPreferencesTheme = getThemeByColor(
          AppNewTheme.idColorTema,
          isDarkMode: true,
        );
        break;
      default: // Sistema (idTema == 0)
        selectedPreferencesTheme = getThemeByColor(
          AppNewTheme.idColorTema,
          isDarkMode: isDarkMode,
        );
    }
  }

  // String obtenerColor(BuildContext context, String idcolor) {
  //   for (var i = 0; i < coloresApp(context).length; i++) {
  //     ColorModel color = coloresApp(context)[i];
  //     if (idcolor == color.id) {
  //       return color.valor;
  //     }
  //   }
  //   return "#134895";
  // }

  String obtenerColor(BuildContext context, String idcolor) {
    // Convertir idcolor a int
    int? idColorInt = int.tryParse(idcolor);

    // Si la conversión falla, retornar el color predeterminado
    if (idColorInt == null) {
      return "#134895";
    }

    for (var i = 0; i < coloresApp(context).length; i++) {
      ColorModel color = coloresApp(context)[i];
      // Comparar idColorInt (int) con color.id (int)
      if (idColorInt == color.id) {
        return color.valor;
      }
    }

    // Retornar el color predeterminado si no se encuentra
    return "#134895";
  }

  ColorModel obtenerColorModel(
    BuildContext context,
    int idcolor,
  ) {
    // Convertir idcolor a int

    for (var i = 0; i < coloresApp(context).length; i++) {
      ColorModel color = coloresApp(context)[i];
      if (idcolor == color.id) {
        return color;
      }
    }

    // Retornar el color predeterminado si no se encuentra
    return defaultColor;
  }

// Función auxiliar para obtener el tema por color y modo
  ThemeData getThemeByColor(
    int idColorTema, {
    required bool isDarkMode,
  }) {
    switch (idColorTema) {
      case 1: // Rojo
        return isDarkMode ? RedTheme.darkRed : RedTheme.lightRed;
      case 2: // Naranja
        return isDarkMode ? OrangeTheme.darkOrange : OrangeTheme.lightOrange;
      case 3: // Verde
        return isDarkMode ? GreenTheme.darkGreen : GreenTheme.lightGreen;
      case 4: // Azul
        return isDarkMode ? BlueTheme.darkGreen : BlueTheme.lightGreen;
      case 5: // Azul
        return isDarkMode ? PurpleTheme.darkPurple : PurpleTheme.lightPurple;
      default: // Morado
        return isDarkMode ? DarkTheme.darkTheme : LightTheme.lightTheme;
    }
  }

  void selectedColor(int idColor) {
    AppNewTheme.idColorTema = idColor;
    Preferences.idColor = AppNewTheme.idColorTema.toString();
    notifyListeners();
  }

  List<TemaModel> temasAppM(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    final bool isLightMode = brightness == Brightness.light;
    return [
      TemaModel(
        id: 0,
        descripcion: "Sistema",
        tema: isLightMode
            ? LightTheme.lightTheme
            : isDarkMode
                ? DarkTheme.darkTheme
                : LightTheme.lightTheme,
      ),
      TemaModel(
        id: 1,
        descripcion: "Claro",
        tema: LightTheme.lightTheme,
      ),
      TemaModel(
        id: 2,
        descripcion: "Oscuro",
        tema: DarkTheme.darkTheme,
      ),
    ];
  }

  List<ColorModel> coloresApp(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    final bool isLightMode = brightness == Brightness.light;

    return [
      ColorModel(
        id: 1,
        valor: "#FF0000",
        nombre: "Rojo",
        tema: TemaModel(
          id: 0,
          descripcion: "Sistema",
          tema: isLightMode
              ? LightTheme.lightTheme
              : isDarkMode
                  ? DarkTheme.darkTheme
                  : LightTheme.lightTheme,
        ),
      ),
      ColorModel(
        id: 2,
        valor: "#FFA500",
        nombre: "Naranja",
        tema: TemaModel(
          id: 2,
          descripcion: "Naranja",
          tema: isLightMode
              ? OrangeTheme.lightOrange
              : isDarkMode
                  ? OrangeTheme.darkOrange
                  : OrangeTheme.lightOrange,
        ),
      ),
      ColorModel(
        id: 3,
        valor: "#008000",
        nombre: "Verde",
        tema: TemaModel(
          id: 3,
          descripcion: "Verde",
          tema: isLightMode
              ? GreenTheme.lightGreen
              : isDarkMode
                  ? GreenTheme.darkGreen
                  : GreenTheme.lightGreen,
        ),
      ),
      ColorModel(
        id: 4,
        valor: "#134895",
        nombre: "Azul",
        tema: TemaModel(
          id: 4,
          descripcion: "Azul",
          tema: isLightMode
              ? BlueTheme.lightGreen
              : isDarkMode
                  ? BlueTheme.darkGreen
                  : BlueTheme.lightGreen,
        ),
      ),
      ColorModel(
        id: 5,
        valor: "#800080",
        nombre: "Morado",
        tema: TemaModel(
          id: 5,
          descripcion: "Morado",
          tema: isLightMode
              ? PurpleTheme.lightPurple
              : isDarkMode
                  ? PurpleTheme.darkPurple
                  : PurpleTheme.lightPurple,
        ),
      ),
    ];
  }

  ColorModel defaultColor = ColorModel(
    id: 1,
    valor: "#FF0000",
    nombre: "Azul",
    tema: TemaModel(
      id: 0,
      descripcion: "Claro",
      tema: LightTheme.lightTheme,
    ),
  );
}
