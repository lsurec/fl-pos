import 'dart:convert';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class EmpresaService {
  //url del servidor
  final String _baseUrl = Preferences.urlApi;

  //Obtner empresas
  Future<ApiResModel> getEmpresa(
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Empresa/$user");
    try {
      //url completa

      //configuracion del api
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
          message: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //Empresas disponuibles
      List<EmpresaModel> empresas = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = EmpresaModel.fromMap(item);
        //agregar item a la lista
        empresas.add(responseFinally);
      }

      //Respuesta corerecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: empresas,
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
