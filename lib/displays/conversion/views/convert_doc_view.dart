import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/card_widget.dart';

class ConvertDocView extends StatelessWidget {
  const ConvertDocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.check,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "ORIGEN - (84) Requerimiento de translado - (40) Cambio de producto.",
                style: AppTheme.titleStyle,
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Registros (10)",
                    style: AppTheme.normalBoldStyle,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              CardWidget(
                color: AppTheme.grayAppBar,
                child: ListTile(
                  leading: Checkbox(value: false, onChanged: (value) {}),
                  contentPadding: const EdgeInsets.all(10),
                  subtitle: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Texts(title: "Cantidad: ", text: "1000"),
                      SizedBox(height: 5),
                      _Texts(title: "Disponible: ", text: "1000"),
                      SizedBox(height: 5),
                      _Texts(title: "Clase: ", text: "1000"),
                      SizedBox(height: 5),
                      _Texts(title: "Marca: ", text: "1000"),
                      SizedBox(height: 5),
                      _Texts(title: "Id: ", text: "1000"),
                      SizedBox(height: 5),
                      _Texts(title: "Bodega: ", text: "1000"),
                      SizedBox(height: 5),
                      _Texts(title: "Producto: ", text: "1000"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Texts extends StatelessWidget {
  const _Texts({
    super.key,
    required this.title,
    required this.text,
  });

  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: AppTheme.normalStyle,
        children: [
          TextSpan(text: title, style: AppTheme.normalBoldStyle),
          TextSpan(
            text: text,
          )
        ],
      ),
    );
  }
}
