// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';

class ArchivosView extends StatelessWidget {
  const ArchivosView({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Adjuntar archivos',
              style: AppTheme.titleStyle,
            ),
          ),
          body: Center(
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.attach_file_outlined,
                size: 50,
              ),
              tooltip: "Adjuntar Archivos",
            ),
          ),
        )
      ],
    );
  }
}
