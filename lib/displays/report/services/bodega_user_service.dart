import 'dart:convert';

import 'package:flutter_post_printer_example/displays/report/models/bodega_user_model.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class BodegaUserService {
  //url del servidor
  final String _baseUrl = Preferences.urlApi;

  Future<ApiResponseModel> getBodega(
    String token,
    String user,
    int enterprise,
    int station,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Shared/bodega/user");

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
        },
      );

      ApiResponseModel res = ApiResponseModel.fromMap(
        jsonDecode(
          response.body,
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        List<BodegaUserModel> items = (res.data as List)
            .map(
              (item) => BodegaUserModel.fromMap(item),
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
}
