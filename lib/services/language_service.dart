// Esta clase maneja la carga y traducción de cadenas de texto según el idioma seleccionado.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations extends ChangeNotifier {
  static Locale idioma = const Locale("es");
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

  // Mapa para almacenar las cadenas traducidas.
  Map<String, String>? _localizedStrings;

  // Método asincrónico que carga las cadenas de texto traducidas desde un archivo JSON.
  Future<bool> load() async {
    String jsonString =
        await rootBundle.loadString('assets/langs/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  // Método para traducir una cadena de texto según la clave proporcionada.
  String translate(String key) {
    // print(_localizedStrings![key]);
    return _localizedStrings![key] ?? key;
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
    await localizations.load();
    return localizations;
  }

  // Método que indica si se debe volver a cargar el delegado de localizaciones.
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
