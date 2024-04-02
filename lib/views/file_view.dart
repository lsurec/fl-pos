import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/login_view_model.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class FileUploader extends StatefulWidget {
  @override
  _FileUploaderState createState() => _FileUploaderState();
}

class _FileUploaderState extends State<FileUploader> {
  List<File> _files = [];

  Future<void> _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _files = result.paths.map((path) => File(path!)).toList();
      });
    }
  }

  // Future<void> _uploadFiles() async {
  //   if (_files.isEmpty) return;

  //   try {
  //     // var uri = Uri.parse('http://192.168.0.10:9193/api/Files/upload');
  //     var uri = Uri.parse('http://192.168.1.7:3036/api/Files');
  //     var request = http.MultipartRequest('POST', uri);

  //     // Add files to the request
  //     for (var file in _files) {
  //       request.files
  //           .add(await http.MultipartFile.fromPath('files', file.path));
  //     }

  //     // Add any additional data if needed
  //     request.fields['additionalField'] = 'additionalValue';

  //     var response = await request.send();

  //     // Handle response
  //     if (response.statusCode == 200) {
  //       print('Files uploaded successfully');
  //     } else {
  //       print('Failed to upload files. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error uploading files: $e');
  //   }
  // }

  Future<void> _uploadFiles() async {
    //View model para obtener el usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    if (_files.isEmpty) return;

    try {
      var uri =
          Uri.parse('http://192.168.0.7:3036/api/Tareas/objetos/comentario');
      var request = http.MultipartRequest('POST', uri);

      // Agregar encabezados a la solicitud
      request.headers.addAll({
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJuYW1laWQiOiJkZXNhMDAxIiwibmJmIjoxNzEwOTQyNDAzLCJleHAiOjE3NDIwNDY0MDMsImlhdCI6MTcxMDk0MjQwM30.6x_R5wlXTYhsZDhtYaUvyZXn-dCx2du_-GiHZKeCKnw',
        'Content-Type': 'multipart/form-data',
        "user": "desa001",
        "tarea": 5245.toString(),
        "tareaComentario": 11883.toString(),
      });

      // Agregar archivos a la solicitud
      for (var file in _files) {
        request.files
            .add(await http.MultipartFile.fromPath('files', file.path));
      }

      // Agregar cualquier dato adicional si es necesario
      request.fields['additionalField'] = 'additionalValue';

      var response = await request.send();

      // Manejar la respuesta
      if (response.statusCode == 200) {
        print('Archivos subidos exitosamente');
      } else {
        print(
            'Error al subir archivos. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al subir archivos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'File Uploader',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _selectFiles,
              child: const Text(
                'Seleccionar Archivos',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFiles,
              child: const Text(
                'Subir Archivos',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
