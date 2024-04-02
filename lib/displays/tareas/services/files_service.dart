import 'dart:convert';
import 'dart:io';
import 'package:flutter_post_printer_example/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_post_printer_example/models/api_res_model.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';

class FilesService {
  final String _baseUrl = Preferences.urlApi;

  //Consumo api para actualizar el estado de la tarea.
  Future<ApiResModel> posFilesComent(
    String token,
    String user,
    List<File> files,
    int tarea,
    int tareaComentario,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Tareas/objetos/comentario");
    try {
      //url completa

      // // Configurar Api y consumirla
      // final response = await http.post(

      //   url,
      //   body: files,
      //   headers: {
      //     "Content-Type": "multipart/form-data",
      //     "Authorization": "bearer $token",
      //     "user": user,
      //     "tarea": tarea.toString(),
      //     "tareaComentario": tareaComentario.toString(),
      //   },

      // );

      var request = http.MultipartRequest('POST', url);

      // Agregar encabezados a la solicitud
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
        "user": user,
        "tarea": tarea.toString(),
        "tareaComentario": tareaComentario.toString(),
      });

      // Agregar archivos a la solicitud
      for (var file in files) {
        request.files.add(
          await http.MultipartFile.fromPath('files', file.path),
        );
      }

      // Agregar cualquier dato adicional si es necesario
      request.fields['additionalField'] = 'additionalValue';

      var response = await request.send();

      // ResponseModel res =
      //     ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          message: "Incorrecto",
          storeProcedure: null,
        );
      }

      //Retornar respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        message: "Correcto",
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
