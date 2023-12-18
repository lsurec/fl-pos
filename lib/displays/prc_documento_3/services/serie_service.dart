import 'dart:convert';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class SerieService {
  //url de lserivdor
  final String _baseUrl = Preferences.urlApi;

  //obtner series
  Future<ApiResModel> getSerie(
    int documento,
    int empresa,
    int estacion,
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Serie");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "documento": documento.toString(),
          "empresa": empresa.toString(),
          "estacion": estacion.toString(),
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
          message: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //series disponibñes
      List<SerieModel> series = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = SerieModel.fromMap(item);
        //agregar item a la lista
        series.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: series,
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
