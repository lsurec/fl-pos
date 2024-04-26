// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;

class CalendarioTareaService {
  final String _baseUrl = Preferences.urlApi;

//Consumo api para obtener id referencia.
  Future<ApiResModel> getTareaCalendario(
    String user,
    String token,
  ) async {
    //url completa
    // Uri url = Uri.parse("${_baseUrl}Tareas/calendario/$user");
    // Uri url = Uri.parse("http://192.168.0.7:3036/api/Tareas/calendario/ASISTENTEG");
    Uri url =
        Uri.parse("http://192.168.0.7:3036/api/Tareas/calendario/desa029");

    // Uri url = Uri.parse("${_baseUrl}Tareas/calendario/desa026");
    try {
      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
        },
      );

// print(response.body);

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

      //Tareas retornadas por api
      List<TareaCalendarioModel> tareasCalendario = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TareaCalendarioModel.fromMap(item);
        //agregar item a la lista
        tareasCalendario.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: tareasCalendario,
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

  //acttualixar servicio de calendario tareas por rango de fecha

  //Consumo api para obtener id referencia.
  Future<ApiResModel> getRangoTareasCalendario(
    String user,
    String token,
    String fechaIni,
    String fechaFin,
  ) async {
    //url completa
    Uri url = Uri.parse("${_baseUrl}Tareas/calendario/$user");

    try {
      //Configuraciones del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
          "fecha_Ini": fechaIni,
          "fecha_Fin": fechaFin,
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

      //Tareas retornadas por api
      List<TareaCalendarioModel> tareasCalendario = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = TareaCalendarioModel.fromMap(item);
        //agregar item a la lista
        tareasCalendario.add(responseFinally);
      }

      //retornar respuesta correcta del api
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: tareasCalendario,
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
