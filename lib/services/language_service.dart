// Esta clase maneja la carga y traducción de cadenas de texto según el idioma seleccionado.
// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';

class AppLocalizations extends ChangeNotifier {
  // static Locale idioma = const Locale("es");
  static Locale idioma = Preferences.language.isEmpty
      ? AppLocalizations.idioma
      : Locale(Preferences.language);

  static int cambiarIdioma = 0;

  final Locale locale;

  // Constructor que toma un Locale como argumento.
  AppLocalizations(this.locale);

  // Método estático que devuelve una instancia de AppLocalizations basada en el contexto proporcionado.
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Delegado de localizaciones que será utilizado por Flutter para cargar las traducciones.
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  late Map<String, Map<String, String>> _localizedStrings;

  Future<bool> load(String languageCode) async {
    String jsonString =
        await rootBundle.loadString('assets/langs/$languageCode.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Convertimos el mapa de bloques en un mapa de mapa de cadenas
    _localizedStrings = jsonMap.map((key, value) {
      Map<String, String> innerMap = Map<String, String>.from(value);
      return MapEntry(key, innerMap);
    });

    return true;
  }

  String translate(String block, String key) {
    // Verificar si el bloque y la clave existen
    if (_localizedStrings.containsKey(block) &&
        _localizedStrings[block]!.containsKey(key)) {
      return _localizedStrings[block]![key]!;
    }
    // Devolver la llave si no se encuentra la traducción
    return "$block.$key";
  }
}

// Delegado de localizaciones personalizado que se utiliza para cargar las traducciones.
class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  // Método que verifica si el idioma es compatible con la aplicación.
  @override
  bool isSupported(Locale locale) {
    return ['en', 'es', 'fr', 'de'].contains(locale.languageCode);
  }

  // Método asincrónico que carga las traducciones para un idioma específico.
  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load(locale.languageCode);
    return localizations;
  }

  // Método que indica si se debe volver a cargar el delegado de localizaciones.
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
