// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/selectors/imagen_selector.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ArchivosView extends StatefulWidget {
  const ArchivosView({super.key});

  @override
  State<ArchivosView> createState() => _ArchivosViewState();
}

class _ArchivosViewState extends State<ArchivosView> {
  List<File> selectedImages = [];

  void handleImageSelection(List<XFile>? selectedFiles) {
    if (selectedFiles != null) {
      print(selectedFiles.length);
      setState(() {
        selectedImages =
            selectedFiles.map((xFile) => File(xFile.path)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // final vm = Provider.of<ArchivosViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Adjuntar archivos',
              style: AppTheme.titleStyle,
            ),
          ),
          body: Column(
            children: [
              ImageSelector(onSelectImages: handleImageSelection),
              if (selectedImages.isNotEmpty)
                ImagePreview(images: selectedImages),
              // Center(
              //   child: IconButton(
              //     onPressed: () => vm.abrirExplorador(context),
              //     icon: const Icon(
              //       Icons.attach_file_outlined,
              //       size: 50,
              //     ),
              //     tooltip: "Adjuntar Archivos",
              //   ),
              // ),
              // FloatingActionButton(
              //   onPressed: () {
              //     vm.selectImages(context, (List<XFile>? pickedFiles) {
              //       // Aquí puedes manejar las imágenes seleccionadas
              //     });
              //   },
              //   heroTag: 'imageSelector',
              //   tooltip: 'Pick Images from gallery',
              //   child: const Icon(Icons.photo),
              // )
            ],
          ),
        )
      ],
    );
  }
}

// class ImageSelector extends StatelessWidget {
//   final Function(List<XFile>?) onSelectImages;

//   const ImageSelector({
//     super.key,
//     required this.onSelectImages,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<ArchivosViewModel>(context);

//     return FloatingActionButton(
//       onPressed: () {
//         vm.selectImages(context, (List<XFile>? pickedFiles) {
//           // Aquí puedes manejar las imágenes seleccionadas
//         });
//       },
//       heroTag: 'imageSelector',
//       tooltip: 'Pick Images from gallery',
//       child: const Icon(
//         Icons.photo,
//         color: Colors.white,
//       ),
//     );
//   }
// }

// class ImagePreview extends StatelessWidget {
//   final List<File> images;

//   const ImagePreview({
//     super.key,
//     required this.images,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       itemCount: images.length,
//       itemBuilder: (context, index) {
//         print(images.length);
//         return Image.file(images[index]);
//       },
//     );
//   }
// }
