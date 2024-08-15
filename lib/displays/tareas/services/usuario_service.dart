import 'dart:convert';

import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:http/http.dart' as http;

class UsuarioService {
  final String _baseUrl = Preferences.urlApi;

  //Consumo api para obtener id referencia.
  Future<ApiResModel> getUsuario(
    String user,
    String token,
    String filtro,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Usuarios");

    try {
      //url completa
      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "user": user,
          "filtro": filtro,
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

      //Invitados retornados por api
      List<UsuarioModel> usuarios = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = UsuarioModel.fromMap(item);
        //agregar item a la lista
        usuarios.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: usuarios,
        storeProcedure: null,
      );
    } catch (e) {
      //en caso de error retornar el error
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
