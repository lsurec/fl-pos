// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/utilities/languages_utilities.dart';
import 'package:flutter_post_printer_example/widgets/alert_widget.dart';
import 'package:restart_app/restart_app.dart';

class LangViewModel extends ChangeNotifier {
  List<LanguageModel> languages = LanguagesProvider().languagesProvider;

  int indexLangSelect = 0;

  // cambiar el valor del idioma
  void cambiarIdioma(Locale nuevoIdioma, int indexLang) {
    Preferences.language = nuevoIdioma.languageCode;

    AppLocalizations.idioma = Locale(Preferences.language);

    AppLocalizations.langSelect = languages[indexLang];

    indexLangSelect = indexLang;

    notifyListeners();
  }

  Timer? timer; // Temporizador

  void reiniciarTemp(BuildContext context) {
    isLoading = true;
    // timer?.cancel(); // Cancelar el temporizador existente si existe
    timer = Timer(const Duration(milliseconds: 2000), () {
      // Función de filtrado que consume el servicio
      FocusScope.of(context).unfocus(); //ocultar teclado
      reiniciarApp();
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
            textOk: "Reiniciar ahora.",
            textCancel: "Aceptar",
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

  // String? getNameByLanguageRegion(LanguageModel data) {
  //   final names = data.names;
  //   final languageRegion = names.firstWhereOrNull(
  //       (item) => item.lrCode == '${activeLang.lang}-${activeLang.reg}');
  //   return languageRegion != null ? languageRegion.name : null;
  // }

}
