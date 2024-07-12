// ignore_for_file: avoid_print
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';

class FilesService {
  final String _baseUrl = Preferences.urlApi;

  //Consumo api para actualizar el estado de la tarea.
  Future<bool> posFilesComent(
    String token,
    String user,
    List<File> files,
    int tarea,
    int tareaComentario,
    String urlCarpeta,
  ) async {
    Uri url = Uri.parse("${_baseUrl}FilesComment");
    try {
      var request = http.MultipartRequest('POST', url);

      // Agregar encabezados a la solicitud
      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
        "user": user,
        "tarea": tarea.toString(),
        "tareaComentario": tareaComentario.toString(),
        "urlCarpeta": urlCarpeta
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

      // Manejar la respuesta
      if (response.statusCode == 200) {
        print('Archivos subidos exitosamente');
        return true;
      } else {
        print(
          'Error al subir archivos. Código de estado: ${response.statusCode}',
        );
        return false;
      }
    } catch (e) {
      print('Error al subir archivos: $e');
      return false;
    }
  }
}
