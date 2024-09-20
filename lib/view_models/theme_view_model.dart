// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:restart_app/restart_app.dart';

class ThemeViewModel extends ChangeNotifier {
  //controlar prcesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  back(BuildContext context) {
    Navigator.pop(context);
  }

  navegarApi(BuildContext context) {
    Preferences.idThemeApp = AppTheme.idTema.toString();

    print(Preferences.idThemeApp);

    Navigator.pushNamed(
      context,
      AppRoutes.api,
    );
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
            ? LightTheme.lightTheme
            : isDarkMode
                ? DarkTheme.darkTheme
                : LightTheme.lightTheme,
      ),
      ThemeModel(
        id: 1,
        descripcion: AppLocalizations.of(context)!.translate(
          BlockTranslate.home,
          'claro',
        ),
        theme: LightTheme.lightTheme,
      ),
      ThemeModel(
        id: 2,
        descripcion: AppLocalizations.of(context)!.translate(
          BlockTranslate.home,
          'oscuro',
        ),
        theme: DarkTheme.darkTheme,
      )
    ];
  }

  Timer? timer; // Temporizador

  reiniciarApp() {
    /// Fill webOrigin only when your new origin is different than the app's origin
    Restart.restartApp();
  }

  ThemeData selectedPreferencesTheme = LightTheme.lightTheme;

  ThemeData get selectedTheme => selectedPreferencesTheme;

  void validarColorTema(BuildContext context, int idTema) {
    AppTheme.idTema = idTema;
    Preferences.idThemeApp = AppTheme.idTema.toString();
    Preferences.idColor = AppTheme.idColorTema.toString();
    Preferences.valueColor = obtenerColor(Preferences.idColor);

    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    AppTheme.oscuro = isDarkMode;
    notifyListeners();
    // Selección de tema y color
    switch (AppTheme.idTema) {
      case 1: // Tema Claro
        selectedPreferencesTheme = getThemeByColor(
          AppTheme.idColorTema,
          isDarkMode: false,
        );
        break;
      case 2: // Tema Oscuro
        selectedPreferencesTheme = getThemeByColor(
          AppTheme.idColorTema,
          isDarkMode: true,
        );
        break;
      default: // Sistema (idTema == 0)
        selectedPreferencesTheme = getThemeByColor(
          AppTheme.idColorTema,
          isDarkMode: isDarkMode,
        );
    }
  }

  static Color? preferencia;

  String obtenerColor(String idcolor) {
    // Convertir idcolor a int
    int? idColorInt = int.tryParse(idcolor);

    // Si la conversión falla, retornar el color predeterminado
    if (idColorInt == null) {
      return "#134895";
    }

    for (var i = 0; i < coloresTemaApp.length; i++) {
      ColorModel color = coloresTemaApp[i];
      // Comparar idColorInt (int) con color.id (int)
      if (idColorInt == color.id) {
        return color.valor;
      }
    }

    // Retornar el color predeterminado si no se encuentra
    return "#134895";
  }

  ColorModel temaColor(String idcolor) {
    // Convertir idcolor a int
    int? idColorInt = int.tryParse(idcolor);

    // Si la conversión falla, retornar el color predeterminado
    if (idColorInt != null) {
      for (var i = 0; i < coloresTemaApp.length; i++) {
        ColorModel color = coloresTemaApp[i];
        // Comparar idColorInt (int) con color.id (int)
        if (idColorInt == color.id) {
          return color;
        }
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
      case 0: // Sistema
        return isDarkMode ? DarkTheme.darkTheme : LightTheme.lightTheme;
      case 1: // Azul
        return isDarkMode ? BlueTheme.dark : BlueTheme.light;
      case 2: // Rojo
        return isDarkMode ? RedTheme.dark : RedTheme.light;
      case 3: // Naranja
        return isDarkMode ? OrangeTheme.dark : OrangeTheme.light;
      case 4: // Verde Musgo
        return isDarkMode ? OliveTheme.dark : OliveTheme.light;
      case 5: // Verde
        return isDarkMode ? GreenTheme.dark : GreenTheme.light;
      case 6: // Verde 2
        return isDarkMode ? GreenAccentTheme.dark : GreenAccentTheme.light;
      case 7: // Cyan
        return isDarkMode ? CyanTheme.dark : CyanTheme.light;
      case 8: // Aqua
        return isDarkMode ? SteelBlueTheme.dark : SteelBlueTheme.light;
      case 9: // Lila
        return isDarkMode ? MediumPurpleTheme.dark : MediumPurpleTheme.light;
      case 10: // Morado
        return isDarkMode ? PurpleTheme.dark : PurpleTheme.light;
      case 11: // Fucsia
        return isDarkMode ? FuchsiaTheme.dark : FuchsiaTheme.light;
      case 12: // Rosadito
        return isDarkMode ? RosyBrownTheme.dark : RosyBrownTheme.light;
      case 13: // Gris
        return isDarkMode ? GreyTheme.dark : GreyTheme.light;
      default: // Default
        return isDarkMode ? DarkTheme.darkTheme : LightTheme.lightTheme;
    }
  }

  Color colorPref(int idColor) {
    switch (idColor) {
      case 0: // Sistema
        return AppTheme.primary;
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

  void selectedColor(int idColor) {
    AppTheme.idColorTema = idColor;
    Preferences.idColor = AppTheme.idColorTema.toString();
    Preferences.valueColor = obtenerColor(Preferences.idColor);
    notifyListeners();
  }

  List<TemaModel> temasAppM(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    final bool isLightMode = brightness == Brightness.light;
    AppTheme.oscuro = isDarkMode;

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

  List<ColorModel> coloresTemaApp = [
    ColorModel(
      id: 0,
      valor: "#134895",
      nombre: "Auto (Azul)",
      tema: TemaModel(
        id: 0,
        descripcion: "Auto",
        tema: LightTheme.lightTheme,
      ),
    ),
    ColorModel(
      id: 1,
      valor: "#134895",
      nombre: "Azul",
      tema: TemaModel(
        id: 1,
        descripcion: "Azul",
        tema: BlueTheme.light,
      ),
    ),
    ColorModel(
      id: 2,
      valor: "#FF0000",
      nombre: "Rojo",
      tema: TemaModel(
        id: 2,
        descripcion: "Rojo",
        tema: RedTheme.light,
      ),
    ),
    ColorModel(
      id: 3,
      valor: "#FFA500",
      nombre: "Naranja",
      tema: TemaModel(
        id: 3,
        descripcion: "Naranja",
        tema: OrangeTheme.dark,
      ),
    ),
    ColorModel(
      id: 4,
      valor: "#6e6b57",
      nombre: "Verde Musgo",
      tema: TemaModel(
        id: 4,
        descripcion: "Verde Musgo",
        tema: OliveTheme.light,
      ),
    ),
    ColorModel(
      id: 5,
      valor: "#3c7944",
      nombre: "Verde",
      tema: TemaModel(
        id: 5,
        descripcion: "Verde",
        tema: GreenTheme.light,
      ),
    ),
    ColorModel(
      id: 6,
      valor: "#1d8763",
      nombre: "Verde 2",
      tema: TemaModel(
        id: 6,
        descripcion: "Verde 2",
        tema: GreenAccentTheme.light,
      ),
    ),
    ColorModel(
      id: 7,
      valor: "#067d91",
      nombre: "Cyan",
      tema: TemaModel(
        id: 7,
        descripcion: "Cyan",
        tema: CyanTheme.light,
      ),
    ),
    ColorModel(
      id: 8,
      valor: "#336ca3",
      nombre: "Azul Acerado",
      tema: TemaModel(
        id: 8,
        descripcion: "Azul Acerado",
        tema: SteelBlueTheme.light,
      ),
    ),
    ColorModel(
      id: 9,
      valor: "#6156ca",
      nombre: "Lila",
      tema: TemaModel(
        id: 9,
        descripcion: "Lila",
        tema: MediumPurpleTheme.light,
      ),
    ),
    ColorModel(
      id: 10,
      valor: "#9832ca",
      nombre: "Morado",
      tema: TemaModel(
        id: 10,
        descripcion: "Morado",
        tema: PurpleTheme.light,
      ),
    ),
    ColorModel(
      id: 11,
      valor: "#ab367a",
      nombre: "Fucsia",
      tema: TemaModel(
        id: 11,
        descripcion: "Fucsia",
        tema: FuchsiaTheme.light,
      ),
    ),
    ColorModel(
      id: 12,
      valor: "#8e606b",
      nombre: "Rosita",
      tema: TemaModel(
        id: 12,
        descripcion: "Rosita",
        tema: RosyBrownTheme.light,
      ),
    ),
    ColorModel(
      id: 13,
      valor: "#72717f",
      nombre: "Gris",
      tema: TemaModel(
        id: 13,
        descripcion: "Gris",
        tema: GreyTheme.light,
      ),
    ),
  ];
}
