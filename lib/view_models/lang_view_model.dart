// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/utilities/languages_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/alert_widget.dart';
import 'package:restart_app/restart_app.dart';

class LangViewModel extends ChangeNotifier {
  List<LanguageModel> languages = LanguagesProvider.languagesProvider;
  LanguageModel activeLang =
      LanguagesProvider.languagesProvider[LanguagesProvider.indexDefaultLang];

  // cambiar el valor del idioma
  void cambiarIdioma(
    BuildContext context,
    Locale nuevoIdioma,
    int indexLang,
  ) async {
    //Si es desde ajustes
    if (AppLocalizations.cambiarIdioma == 1 &&
        indexLang != Preferences.idLanguage) {
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

      //Si reinicia, guardar el nuevo tema

      Preferences.language = nuevoIdioma.languageCode;

      AppLocalizations.idioma = Locale(Preferences.language);

      Preferences.idLanguage = indexLang;

      activeLang = languages[indexLang];

      notifyListeners();

      isLoading = true;
      // timer?.cancel(); // Cancelar el temporizador existente si existe
      timer = Timer(const Duration(milliseconds: 2000), () {
        // Función de filtrado que consume el servicio
        FocusScope.of(context).unfocus(); //ocultar teclado
        reiniciarApp();
      });
    }

    Preferences.language = nuevoIdioma.languageCode;

    AppLocalizations.idioma = Locale(Preferences.language);

    Preferences.idLanguage = indexLang;

    activeLang = languages[indexLang];

    notifyListeners();

    // if (AppLocalizations.cambiarIdioma == 1) {
    //   guardarReiniciar(context);
    // }
  }

  Timer? timer; // Temporizador

  void reiniciarTemp(BuildContext context) {
    if (Preferences.language.isEmpty) {
      Preferences.language = languages[LanguagesProvider.indexDefaultLang].lang;
      Preferences.idLanguage = LanguagesProvider.indexDefaultLang;
      notifyListeners();
      Navigator.pushNamed(context, AppRoutes.theme);
      return;
    }
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

  String? getNameLang(LanguageModel lang) {
    final names = lang.names;
    for (var item in names) {
      if (item.lrCode.startsWith(Preferences.language)) {
        return item.name;
      }
    }
    return null;
  }
}
