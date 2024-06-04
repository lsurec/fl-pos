import 'dart:convert';

import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class TipoCambioService {
  //url del servidor
  final String _baseUrl = Preferences.urlApi;
//Obtener displays
  Future<ApiResModel> getTipoCambio(
    int empresa,
    String user,
    String token,
  ) async {
    final url = Uri.parse("${_baseUrl}tipocambio");
    try {
      //url del api completa

      //configuracion y consummo del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "empresa": empresa.toString(),
          "user": user
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

      //displays disponibles
      List<TipoCambioModel> cambios = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TipoCambioModel.fromMap(item);
        //agregar item a la lista
        cambios.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: cambios,
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
