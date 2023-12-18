import 'dart:convert';

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class ParametroService {
  //url del servidor
  final String _baseUrl = Preferences.urlApi;
//Obtener displays
  Future<ApiResModel> getParametro(
    String user,
    int tipoDoc,
    String serie,
    int empresa,
    int estacion,
    String token,
  ) async {
    final url = Uri.parse("${_baseUrl}parametro");
    try {
      //url del api completa

      //configuracion y consummo del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "empresa": empresa.toString(),
          "user": user,
          "tipoDoc": "$tipoDoc",
          "serie": serie,
          "estacion": "$estacion",
        },
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

      //displays disponibles
      List<ParametroModel> cambios = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ParametroModel.fromMap(item);
        //agregar item a la lista
        cambios.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: cambios,
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
