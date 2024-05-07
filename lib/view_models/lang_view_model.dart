// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/widgets/alert_widget.dart';
import 'package:restart_app/restart_app.dart';

class LangViewModel extends ChangeNotifier {
  // cambiar el valor del idioma
  void cambiarIdioma(Locale nuevoIdioma) {
    Preferences.language = nuevoIdioma.languageCode;

    AppLocalizations.idioma = Locale(Preferences.language);

    notifyListeners();
    print(Preferences.language);
  }

  Timer? timer; // Temporizador

  void reiniciarTemp(BuildContext context) {
    isLoading = true;
    // timer?.cancel(); // Cancelar el temporizador existente si existe
    timer = Timer(const Duration(milliseconds: 3000), () {
      // Función de filtrado que consume el servicio
      FocusScope.of(context).unfocus(); //ocultar teclado
      isLoading = false;
      // reiniciarApp();
    }); // Establecer el período de retardo en milisegundos (en este caso, 1000 ms o 1 segundo)
  }

  reiniciarApp() {
    /// Fill webOrigin only when your new origin is different than the app's origin
    Restart.restartApp();
  }

  //controlar prcesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  guardarReiniciar(BuildContext context) async {
    //mostrar dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: "Idioma seleccionado.",
            description:
                "Para visualizar los cambios, primero reinicie la aplicación.",
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
}
