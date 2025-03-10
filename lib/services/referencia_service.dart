import 'dart:convert';

import 'package:flutter_post_printer_example/displays/tareas/models/id_referencia_model.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class ReferenciaService {
  // url del servidor
  final String _baseUrl = Preferences.urlApi;

  //Obtener displays
  Future<ApiResponseModel> getReferencia(
    int empresa,
    String query,
    String user,
    String token,
  ) async {
    final url = Uri.parse("${_baseUrl}Shared/referencia");
    try {
      //url del api completa

      //configuracion y consummo del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "empresa": empresa.toString(),
          "query": query,
          "user": user
        },
      );

      ApiResponseModel res = ApiResponseModel.fromMap(
        jsonDecode(
          response.body,
        ),
      );

      List<IdReferenciaModel> items = (res.data as List)
          .map((item) => IdReferenciaModel.fromMap(item))
          .toList();

      res.data = items;

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
      );
    }
  }
}
