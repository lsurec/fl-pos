import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

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

  Future<void> _uploadFiles() async {
    if (_files.isEmpty) return;

    try {
      var uri = Uri.parse('http://192.168.0.10:9193/api/Files/upload');
      var request = http.MultipartRequest('POST', uri);

      // Add files to the request
      for (var file in _files) {
        request.files
            .add(await http.MultipartFile.fromPath('files', file.path));
      }

      // Add any additional data if needed
      request.fields['additionalField'] = 'additionalValue';

      var response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        print('Files uploaded successfully');
      } else {
        print('Failed to upload files. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading files: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Uploader'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _selectFiles,
              child: Text('Select Files'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFiles,
              child: Text('Upload Files'),
            ),
          ],
        ),
      ),
    );
  }
}
