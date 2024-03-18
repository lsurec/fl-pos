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

  //limpiar pedido
  static void clearDocument() {
    _prefs.remove(_docKey);
  }
}
