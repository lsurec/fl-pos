import 'dart:convert';

import 'package:flutter_post_printer_example/models/models.dart';
import 'package:http/http.dart' as http;

import '../shared_preferences/preferences.dart';

class LoginService {
  // Url del servidor
  final String _baseUrl = Preferences.urlApi;

  //Login de usuario
  Future<ApiResModel> postLogin(LoginModel loginModel) async {
    //manejo de errores
    Uri url = Uri.parse("${_baseUrl}Login");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: loginModel.toJson(),
        headers: {"Content-Type": "application/json"},
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          message: res.data,
          storeProcedure: res.storeProcedure,
        );
      }
      // Asignar respuesta del Api ResLogin
      AccessModel respLogin = AccessModel.fromMap(res.data);

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: respLogin,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
