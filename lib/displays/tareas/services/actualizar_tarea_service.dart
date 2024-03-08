import 'dart:convert';

import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class ActualizarTareaService {
  final String _baseUrl = Preferences.urlApi;

  //Consumo api para actualizar el estado de la tarea.
  Future<ApiResModel> postEstadoTarea(
    String token,
    ActualizarEstadoModel estado,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/estado/tarea");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: estado.toJson(),
        headers: {
          "Content-Type": "application/json",
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

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: res.data,
        storeProcedure: null,
      );
    } catch (e) {
      //retornar respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //Consumo api para actualizar el nivel de prioridad de la tarea.
  Future<ApiResModel> postPrioridadTarea(
    String token,
    ActualizarPrioridadModel prioridad,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/prioridad/tarea");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: prioridad.toJson(),
        headers: {
          "Content-Type": "application/json",
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

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: res.data,
        storeProcedure: null,
      );
    } catch (e) {
      //retornar respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //Consumo api para eliminar usuarios invitados de la tarea.
  Future<ApiResModel> postEliminarInvitado(
      String token, EliminarUsuarioModel usuario, int tareaUser) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/eliminar/usuario/invitado");
    try {
      //url completa
      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: usuario.toJson(),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer $token",
          "tareaUser": tareaUser.toString(),
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

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: res.data,
        storeProcedure: null,
      );
    } catch (e) {
      //retornar respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //Consumo api para agregar usuarios invitados a la tarea.
  Future<ApiResModel> postInvitados(
    String token,
    NuevoUsuarioModel usuario,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/usuario/invitado");
    try {
      //url completa
      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: usuario.toJson(),
        headers: {
          "Content-Type": "application/json",
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

      //Invitado nuevo retornado por api
      List<ResNuevoUsuarioModel> invitado = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = ResNuevoUsuarioModel.fromMap(item);
        //agregar item a la lista
        invitado.add(responseFinally);
      }

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: invitado,
        storeProcedure: null,
      );
    } catch (e) {
      //retornar respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        message: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
