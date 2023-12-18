import 'dart:convert';

import 'package:flutter_post_printer_example/fel/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/providers/providers.dart';
import 'package:http/http.dart' as http;

class TokenService {
  //url de lserivdor

  final String _baseUrl = ApiProvider().baseUrl;

  //obtner series
  Future<ApiResModel> getToken(
    int apiToken,
    int certificador,
    String user,
    String conStr,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tokens/$certificador/1/$user");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "connectionStr": conStr,
          "apiToken": "$apiToken",
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

      // Asignar respuesta del Api ResLogin
      ResStatusModel res = ResStatusModel.fromMap(jsonDecode(response.body));

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: res,
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
