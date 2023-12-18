import 'dart:convert';

import 'package:flutter_post_printer_example/fel/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/providers/providers.dart';
import 'package:http/http.dart' as http;

class CredencialeService {
  //url de lserivdor
  final String _baseUrl = ApiProvider().baseUrl;

  //obtner series
  Future<ApiResModel> getCredenciales(
    int certificador,
    String user,
    String conStr,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Credenciales/2/$certificador/1/$user");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "connectionStr": conStr,
        },
      );

      if (response.statusCode != 200) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          message: response.body,
          storeProcedure: null,
        );
      }

      //respuesta del api
      final resJson = json.decode(response.body);

      //series disponibñes
      List<CredencialModel> credenciales = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in resJson) {
        //Tipar a map
        final responseFinally = CredencialModel.fromMap(item);
        //agregar item a la lista
        credenciales.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: credenciales,
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
