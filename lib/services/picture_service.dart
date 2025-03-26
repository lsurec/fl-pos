import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/models/url_pic_model.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PictureService extends ChangeNotifier {
  // url del servidor
  final String _baseUrl = Preferences.urlApi;

  bool _isDownloading = false;
  String? _errorMessage;
  double _progress = 0.0;
  File? _imageFile;

  bool get isDownloading => _isDownloading;
  String? get errorMessage => _errorMessage;
  double get progress => _progress;
  File? get imageFile => _imageFile;

  Future<void> fetchAndSaveImage(String token, String url) async {
    _isDownloading = true;
    _errorMessage = null;
    _progress = 0.0;
    notifyListeners();

    try {
      final pictureService = PictureService();
      final resPicture =
          await pictureService.getPictureBase64(token, UrlPicModel(url: url));

      if (resPicture.status) {
        final String base64Image = resPicture.data;
        final savedFile = await saveImage(base64Image, getImageName(url));
        _imageFile = savedFile;
      } else {
        _errorMessage = "Error al descargar la imagen";
      }
    } catch (e) {
      _errorMessage = "Error: $e";
    } finally {
      _isDownloading = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedImage(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    if (await file.exists()) {
      _imageFile = file;
      notifyListeners();
    }
  }

  Future<ByteData> getLogo(String url) async {
    final String namePic = getImageName(url);

    File? file = await getSavedImage(namePic);

    if (file == null) {
      return await rootBundle.load('assets/empresa.png');
    } else {
      Uint8List bytes = await file.readAsBytes();
      return ByteData.sublistView(bytes);
    }
  }

  Future<File?> getSavedImage(String name) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    return file.existsSync() ? file : null;
  }

  String getImageName(String url) {
    Uri uri = Uri.parse(url);
    return uri.pathSegments.last; // "miumagen.mmiinmaen.jpg"
  }

  Future<File> saveImage(String base64Image, String name) async {
    Uint8List bytes = base64Decode(base64Image);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');
    await file.writeAsBytes(bytes);
    return file;
  }

  //Obtener displays
  Future<ApiResponseModel> getPictureBase64(
    String token,
    UrlPicModel urlPicture,
  ) async {
    final url = Uri.parse("${_baseUrl}v2/Picture/base64");
    try {
      //url del api completa

      //configuracion y consummo del api
      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: urlPicture.toJson(),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer $token",
        },
      );

      ApiResponseModel res = ApiResponseModel.fromMap(
        jsonDecode(
          response.body,
        ),
      );

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
}
