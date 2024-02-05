import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/card_widget.dart';

class ConvertDocView extends StatelessWidget {
  const ConvertDocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "ORIGEN - (84) Requerimiento de translado - (40) Cambio de producto.",
                style: AppTheme.titleStyle,
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
