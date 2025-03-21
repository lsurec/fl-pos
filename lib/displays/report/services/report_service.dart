import 'dart:convert';
import 'package:flutter_post_printer_example/displays/report/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class ReportService {
  //url del servidor
  final String _baseUrl = Preferences.urlApi;

  Future<ApiResponseModel> getRptFacturas(
    String token,
    String user,
    DateTime startDate,
    DateTime endDate,
    int typeDoc,
    int enterprise,
    int station,
    int warehouse,
  ) async {
    Uri url = Uri.parse("${_baseUrl}v2/Report/facturas");

    try {
      //url completa

      //configuracion del api
      final response = await http.get(
        url,
        headers: {
          // "Authorization": "bearer $token",
          "Authorization": "bearer $token",
          "user": user,
          "startDate": "$startDate",
          "endDate": "$endDate",
          "typeDoc": "$typeDoc",
          "enterprise": "$enterprise",
          "station": "$station",
          "warehouse": "$warehouse",
        },
      );

      ApiResponseModel res = ApiResponseModel.fromMap(
        jsonDecode(
          response.body,
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        List<ViewFacturaModel> items = (res.data as List)
            .map(
              (item) => ViewFacturaModel.fromMap(item),
            )
            .toList();

        res.data = items;
      }

      res.url = url.toString();
      return res;
    } catch (e) {
      //respuesta incorrecta
      return ApiResponseModel(
        status: false,
        message: "Excepcion no controlada",
        error: e.toString(),
        storeProcedure: "",
        parameters: null,
        data: [],
        timestamp: DateTime.now(),
        version: "Desconocida",
        url: url.toString(),
      );
    }
  }

  Future<ApiResponseModel> getRptExistencias(
    String token,
    String user,
    int enterprise,
    int station,
    int warehouse,
  ) async {
    Uri url = Uri.parse("${_baseUrl}v2/Report/stock");

    try {
      //url completa

      //configuracion del api
      final response = await http.get(
        url,
        headers: {
          // "Authorization": "bearer $token",
          "Authorization": "bearer $token",
          "user": user,
          "enterprise": "$enterprise",
          "station": "$station",
          "warehouse": "$warehouse",
        },
      );

      ApiResponseModel res = ApiResponseModel.fromMap(
        jsonDecode(
          response.body,
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        List<ViewStockModel> items = (res.data as List)
            .map(
              (item) => ViewStockModel.fromMap(item),
            )
            .toList();

        res.data = items;
      }

      res.url = url.toString();
      return res;
    } catch (e) {
      //respuesta incorrecta
      return ApiResponseModel(
        status: false,
        message: "Excepcion no controlada",
        error: e.toString(),
        storeProcedure: "",
        parameters: null,
        data: [],
        timestamp: DateTime.now(),
        version: "Desconocida",
        url: url.toString(),
      );
    }
  }

  //Obtner empresas
  Future<ApiResModel> getViewVentas(
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Report/view/ventas");
    try {
      //url completa

      //configuracion del api
      final response = await http.get(
        url,
        headers: {
          // "Authorization": "bearer $token",
          "Authorization":
              "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJ2ZW50YXMwNSIsIm5iZiI6MTcxODc2MTQwMCwiZXhwIjoxNzQ5ODY1NDAwLCJpYXQiOjE3MTg3NjE0MDB9.Hvq9GcIthvL-ofkdui_k9oOCfYnaVQ5vmQtDnTzRgZY",
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
      List<ViewVentasModel> empresas = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ViewVentasModel.fromMap(item);
        //agregar item a la lista
        empresas.add(responseFinally);
      }

      //Respuesta corerecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: empresas,
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
