import 'dart:convert';

import 'package:flutter_post_printer_example/models/models.dart';
import 'package:http/http.dart' as http;

import '../shared_preferences/preferences.dart';

class LoginService {
  // Url del servidor
  final String _baseUrl = Preferences.urlApi;

  Future<ApiResponseModel> validateDeviceID(
    String id,
    String user,
    String token,
  ) async {
    final url = Uri.parse("${_baseUrl}Shared/validate/id/device");
    try {
      //url del api completa

      //configuracion y consummo del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "id": id,
          "user": user,
        },
      );

      ApiResponseModel res = ApiResponseModel.fromMap(
        jsonDecode(
          response.body,
        ),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        List<IdDeviceResModel> items = (res.data as List)
            .map(
              (item) => IdDeviceResModel.fromMap(item),
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

  //Login de usuario
  Future<ApiResModel> postLogin(LoginModel loginModel) async {
    //manejo de errores
    Uri url = Uri.parse("${_baseUrl}Login");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: loginModel.toJson(),
        headers: {"Content-Type": "application/json"},
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
      // Asignar respuesta del Api ResLogin
      AccessModel respLogin = AccessModel.fromMap(res.data);

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: respLogin,
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
