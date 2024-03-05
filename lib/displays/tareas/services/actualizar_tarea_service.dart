import 'dart:convert';

import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class ActualizarTareaService {
  final String _baseUrl = Preferences.urlApi;

//Consumo api para actualizar el estado de la tarea.

  //no hace nada,

  Future<ApiResModel> postEstadoTarea(
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/estado/tarea");
    try {
      //url completa
      //Configuraciones del api
      final response = await http.post(
        url,
        headers: {
          "Authorization": "bearer $token",
          "Content-Type": "application/json",
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

      //Invitados retornados por api
      List<IdReferenciaModel> idReferencias = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = IdReferenciaModel.fromMap(item);
        //agregar item a la lista
        idReferencias.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: idReferencias,
        storeProcedure: null,
      );
    } catch (e) {
      //en caso de error retornar el error
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
