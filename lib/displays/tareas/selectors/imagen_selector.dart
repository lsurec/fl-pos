import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelector extends StatelessWidget {
  final Function(List<XFile>?) onSelectImages;

  const ImageSelector({
    super.key,
    required this.onSelectImages,
  });

  Future<void> _selectImages() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();

      onSelectImages(pickedFiles);
    } catch (e) {
      print('Error selecting images: $e');
      // errores aca
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _selectImages,
      heroTag: 'imageSelector',
      tooltip: 'Pick Images from gallery',
      child: const Icon(
        Icons.photo,
        color: Colors.white,
      ),
    );
  }
}

class ImagePreview extends StatelessWidget {
  final List<File> images;

  ImagePreview({required this.images});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: images.length,
      itemBuilder: (context, index) {
        print(images.length);
        return Image.file(images[index]);
      },
    );
  }
}
