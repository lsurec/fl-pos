import 'dart:convert';

import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class TipoAccionService {
  //url del servidor
  final String _baseUrl = Preferences.urlApi;

  //Obtner empresas
  Future<ApiResModel> validaTipoAccion(
    int tipoAccion,
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Usuarios/accion/$user/$tipoAccion");
    try {
      //url completa

      //configuracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      RespLogin respLogin = RespLogin.fromMap(res.data);

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: respLogin,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
