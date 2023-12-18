import 'dart:convert';

import 'package:flutter_post_printer_example/fel/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/providers/providers.dart';
import 'package:http/http.dart' as http;

class CatalogoApisService {
  //url de lserivdor
  final String _baseUrl = ApiProvider().baseUrl;

  //obtner series
  Future<ApiResModel> getCatalogoApis(
    String apiUse,
    String user,
    String conStr,
  ) async {
    Uri url = Uri.parse("${_baseUrl}ApiCatalogo/3/$apiUse/$user");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "connectionStr": conStr,
        },
      );

      //respuesta del api
      final resJson = json.decode(response.body);

      //series disponibñes
      List<CatalogoApiModel> apis = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in resJson) {
        //Tipar a map
        final responseFinally = CatalogoApiModel.fromMap(item);
        //agregar item a la lista
        apis.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: apis,
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

  //obtner series
  Future<ApiResModel> getCatalogoParametros(
    String apiUse,
    String user,
    String conStr,
  ) async {
    Uri url = Uri.parse("${_baseUrl}ParametroCatalogo/$apiUse/$user");
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
      List<CatalogoParametroModel> parametros = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in resJson) {
        //Tipar a map
        final responseFinally = CatalogoParametroModel.fromMap(item);
        //agregar item a la lista
        parametros.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: parametros,
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
