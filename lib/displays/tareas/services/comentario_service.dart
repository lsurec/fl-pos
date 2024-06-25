import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';

class ComentarService {
  final String _baseUrl = Preferences.urlApi;

  Future<ApiResModel> postComentar(
    String token,
    ComentarModel comentario,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/comentario");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: comentario.toJson(),
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
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      ResComentarioModel resComent = ResComentarioModel.fromMap(res.data);

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: resComent,
        storeProcedure: null,
      );
    } catch (e) {
      //retornar respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }
}
