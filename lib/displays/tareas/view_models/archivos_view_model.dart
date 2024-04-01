// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ArchivosViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Función para abrir el explorador de archivos
  void abrirExplorador(BuildContext context) {
    print("Abrir explorador de archivos.");
    // Aquí puedes agregar la lógica para abrir el explorador de archivos
  }

  // Función para seleccionar imágenes
  Future<void> selectImages(
    BuildContext context,
    Function(List<XFile>?) onSelectImages,
  ) async {
    try {
      isLoading = true; // Indicar que se está cargando
      final ImagePicker picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();
      onSelectImages(pickedFiles);
    } catch (e) {
      // Manejar errores aquí
      print('Error selecting images: $e');
    } finally {
      isLoading = false; // Indicar que se ha completado la carga
    }
  }

  List<File> selectedImages = [];
  List<File> selectedVideos = [];

  void handleImageSelection(List<XFile>? selectedFiles) {
    if (selectedFiles != null) {
      print(selectedFiles.length);

      selectedImages = selectedFiles.map((xFile) => File(xFile.path)).toList();
      notifyListeners();
    }
  }

  void handleVideoSelection(XFile? selectedFile) {
    if (selectedFile != null) {
      selectedVideos.add(File(selectedFile.path));
      notifyListeners();
    }
  }
}
