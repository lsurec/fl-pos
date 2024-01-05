import 'dart:convert';

import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/models/version_model.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:package_info/package_info.dart';
import 'package:http/http.dart' as http;

class VersionService {
  // Url del servidor
  final String _baseUrl = Preferences.urlApi;

  //obtener formas de pago
  Future<ApiResModel> getVersion(
    String idApp,
    String version,
  ) async {
    Uri url = Uri.parse("${_baseUrl}version");
    try {
      //url completa

      //configiracion del api
      final response = await http.get(
        url,
        headers: {
          "user": "user",
          "idApp": idApp,
          "version": version,
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

      //formas de pago disponibles
      List<VersionModel> versiones = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = VersionModel.fromMap(item);
        //agregar item a la lista
        versiones.add(responseFinally);
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: versiones,
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

  Future<String> getVersionLocal() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    return appVersion;
  }
}
