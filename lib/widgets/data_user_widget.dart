import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';

class DataUserWidget extends StatelessWidget {
  const DataUserWidget({
    super.key,
    required this.data,
    required this.title,
    required this.colorTitle,
  });

  final DataUserModel data;
  final String title;
  final Color? colorTitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colorTitle,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.nit,
          style: StyleApp.normal,
        ),
        const SizedBox(height: 10),
        Text(
          data.name,
          style: StyleApp.normal,
        ),
        const SizedBox(height: 10),
        Text(
          data.adress,
          style: StyleApp.normal,
        ),
      ],
    );
  }
}
