import 'dart:convert';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class MenuService {
  //url del servidor
  final String _baseUrl = Preferences.urlApi;

  //Obtener displays
  Future<ApiResModel> getDisplay(
    int application,
    String user,
    String token,
  ) async {
    final url = Uri.parse("${_baseUrl}Display");
    try {
      //url del api completa

      //configuracion y consummo del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "application": application.toString(),
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
      //respuesta del api

      //displays disponibles
      List<DisplayModel> displays = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = DisplayModel.fromMap(item);
        //agregar item a la lista
        displays.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: displays,
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

  //obtener aplicaciones
  Future<ApiResModel> getApplication(
    String user,
    String token,
  ) async {
    final url = Uri.parse("${_baseUrl}Application/$user");
    try {
      //url commmpleta del api

      //configuracion y consumo del api
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

      //aplicaciones disponibles
      List<ApplicationModel> applications = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ApplicationModel.fromMap(item);
        //agregar item a la lista
        applications.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: applications,
        storeProcedure: null,
      );
    } catch (e) {
      //Respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
