import 'package:shared_preferences/shared_preferences.dart';

/// Guardar Preferencias de usuario
/// Clave Valor con Shared Prefrences

class Preferences {
  static late SharedPreferences _prefs;

  static const String _printKey = "printKey";
  static const String _conStrKey = "conStrKey";
  static const String _tokenKey = "tokenKey";
  static const String _userKey = "userKey";
  static const String _urlKey = "urlKey";
  static const String _docKey = "docKey";
  static const String _langKey = "langKey";
  static const String _idLangKey = "idLangKey";
  static const String _themeAppKey = "theme";
  static const String _colorKey = "color";
  static const String _valueColorKey = "valueColor";

  //iniciar shared preferences
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static bool get directPrint {
    return _prefs.getBool(_printKey) ?? false;
  }

  static set directPrint(bool value) {
    _prefs.setBool(_printKey, value);
  }

  static String get conStr {
    return _prefs.getString(_conStrKey) ?? "";
  }

  static set conStr(String value) {
    _prefs.setString(_conStrKey, value);
  }

  static String get token {
    return _prefs.getString(_tokenKey) ?? "";
  }

  static set token(String value) {
    _prefs.setString(_tokenKey, value);
  }

  //nombre de usuario
  static String get userName {
    return _prefs.getString(_userKey) ?? "";
  }

  static set userName(String value) {
    _prefs.setString(_userKey, value);
  }

  static String get urlApi {
    return _prefs.getString(_urlKey) ?? "";
  }

  static set urlApi(String value) {
    _prefs.setString(_urlKey, value);
  }

  static String get document {
    return _prefs.getString(_docKey) ?? "";
  }

  static set document(String value) {
    _prefs.setString(_docKey, value);
  }

  static void clearToken() {
    _prefs.remove(_tokenKey);
    _prefs.remove(_userKey);
    _prefs.remove(_conStrKey);
  }

  static void clearUrl() {
    _prefs.remove(_urlKey);
  }

  static void clearLang() {
    _prefs.remove(_langKey);
  }

  static void clearTheme() {
    // _prefs.remove(_themeNameKey);
    _prefs.remove(_colorKey);
    _prefs.remove(_themeAppKey);
  }

  //limpiar pedido
  static void clearDocument() {
    _prefs.remove(_docKey);
  }

  //Idioma de la applicacion
  static String get language {
    return _prefs.getString(_langKey) ?? "";
  }

  static set language(String value) {
    _prefs.setString(_langKey, value);
  }

  //Idioma de la applicacion
  static int get idLanguage {
    return _prefs.getInt(_idLangKey) ?? 0;
  }

  static set idLanguage(int value) {
    _prefs.setInt(_idLangKey, value);
  }

  static String get idThemeApp {
    return _prefs.getString(_themeAppKey) ?? "";
  }

  static set idThemeApp(String value) {
    _prefs.setString(_themeAppKey, value);
  }

  static String get idColor {
    return _prefs.getString(_colorKey) ?? "";
  }

  static set idColor(String value) {
    _prefs.setString(_colorKey, value);
  }

  static String get valueColor {
    return _prefs.getString(_valueColorKey) ?? "";
  }

  static set valueColor(String value) {
    _prefs.setString(_valueColorKey, value);
  }
}
