import 'dart:convert';

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class TipoReferenciaService {
  //url de lserivdor
  final String _baseUrl = Preferences.urlApi;

  //obtner series
  Future<ApiResModel> getTiposReferencia(
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Referencia/tipo/$user");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "user": user,
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

      //series disponibñes
      List<TipoReferenciaModel> referencias = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TipoReferenciaModel.fromMap(item);
        //agregar item a la lista
        referencias.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: referencias,
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
