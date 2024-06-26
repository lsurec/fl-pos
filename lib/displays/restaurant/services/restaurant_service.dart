import 'dart:convert';

import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class RestaurantService {
  final String _baseUrl = Preferences.urlApi;

  Future<ApiResModel> getClassifications(
    int typeDoc,
    int enterprise,
    int station,
    String series,
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Restaurant/classifications");
    try {
      //url completa

      //configuracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "typeDoc": "$typeDoc",
          "enterprise": "$enterprise",
          "station": "$station",
          "series": series,
          "user": user,
          "token": token,
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

      //Empresas disponuibles
      List<ClassificationModel> classifications = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ClassificationModel.fromMap(item);
        //agregar item a la lista
        classifications.add(responseFinally);
      }

      //Respuesta corerecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: classifications,
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

  Future<ApiResModel> getAccountPin(
    String token,
    int enterprice,
    String pin,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Restaurant/account/pin");
    try {
      //url completa

      //configuracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "enterprise": "$enterprice",
          "pin": pin,
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

      //Empresas disponuibles
      List<AccountPinModel> cuentas = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = AccountPinModel.fromMap(item);
        //agregar item a la lista
        cuentas.add(responseFinally);
      }

      //Respuesta corerecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: cuentas,
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

  Future<ApiResModel> getTables(
    int typeDoc,
    int enterprise,
    int station,
    String series,
    int elementAssigned,
    String user,
    String token,
  ) async {
    //url completa
    Uri url = Uri.parse("${_baseUrl}Restaurant/tables");

    try {
      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "typeDoc": "$typeDoc",
          "enterprise": "$enterprise",
          "station": "$station",
          "series": series,
          "elementAssigned": "$elementAssigned",
          "user": user,
          "token": token,
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

      //bodegas disponibles
      List<TableModel> tables = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TableModel.fromMap(item);
        //agregar item a la lista
        tables.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: tables,
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

  Future<ApiResModel> getLocations(
    int typeDoc,
    int enterprise,
    int station,
    String series,
    String user,
    String token,
  ) async {
    //url completa
    Uri url = Uri.parse("${_baseUrl}Restaurant/locations");

    try {
      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "typeDoc": "$typeDoc",
          "enterprise": "$enterprise",
          "station": "$station",
          "series": series,
          "user": user,
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

      //bodegas disponibles
      List<LocationModel> locations = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = LocationModel.fromMap(item);
        //agregar item a la lista
        locations.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: locations,
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
