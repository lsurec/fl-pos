// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
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

    if (AppTheme.cambiarTema == 1) {
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
}
