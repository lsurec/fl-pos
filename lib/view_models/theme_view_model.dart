// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
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

  nuevoTema(BuildContext context, ThemeModel tema) {
    Preferences.theme = tema.id;
    Preferences.idTheme = tema.id.toString();
    print(
        "${tema.id} id del tema y preferencia ${Preferences.theme} ${Preferences.idTheme}");

    notifyListeners();

    if (AppTheme.cambiarTema == 1) {
      guardarReiniciar(context);
    }
  }

  List<ThemeModel> temasApp(BuildContext context) {
    final Brightness brightness = MediaQuery.of(context).platformBrightness;
    final bool isDarkMode = brightness == Brightness.dark;
    final bool isLightMode = brightness == Brightness.light;
    return [
      ThemeModel(
        id: 0,
        descripcion: "Determinado por el Sistema",
        theme: isLightMode
            ? AppTheme.lightTheme
            : isDarkMode
                ? AppTheme.darkTheme
                : AppTheme.lightTheme,
      ),
      ThemeModel(
        id: 1,
        descripcion: "Claro",
        theme: AppTheme.lightTheme,
      ),
      ThemeModel(
        id: 2,
        descripcion: "Oscuro",
        theme: AppTheme.darkTheme,
      )
    ];
  }

  Timer? timer; // Temporizador

  void reiniciarTemp(BuildContext context) {
    if (Preferences.idTheme.isEmpty && AppTheme.claro) {
      Preferences.idTheme = "1";
      notifyListeners();
    }

    if (Preferences.idTheme.isEmpty && AppTheme.oscuro) {
      Preferences.idTheme = "2";
      notifyListeners();
    }

    // isLoading = true;
    // timer?.cancel(); // Cancelar el temporizador existente si existe
    timer = Timer(const Duration(milliseconds: 2000), () {
      // Función de filtrado que consume el servicio
      FocusScope.of(context).unfocus(); //ocultar teclado
      // reiniciarApp();
    });

    print("Tema de preferencia ${Preferences.theme}");
  }

  reiniciarApp() {
    /// Fill webOrigin only when your new origin is different than the app's origin
    Restart.restartApp();
  }

  guardarReiniciar(BuildContext context) async {
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
              "aceptar",
            ),
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.preferencias,
              "seleccionado",
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

    //reiniciar la aplicacion
    // ignore: use_build_context_synchronously
    reiniciarTemp(context);
  }

  Icon getThemeIcon(int theme, bool isClaro, bool isOscuro) {
    if (theme == 1) {
      return const Icon(
        Icons.light_mode_outlined,
      );
    } else if (theme == 2) {
      return const Icon(
        Icons.dark_mode_outlined,
      );
    } else if (theme == 0 && isClaro) {
      return const Icon(
        Icons.light_mode_outlined,
      );
    } else if (theme == 0 && isOscuro) {
      return const Icon(
        Icons.dark_mode_outlined,
      );
    } else {
      return const Icon(
        Icons.light_mode_outlined,
      );
    }
  }
}
