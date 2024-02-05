import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/card_widget.dart';

class PendingDocsView extends StatelessWidget {
  const PendingDocsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Documento conversion",
          style: AppTheme.titleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Registros(${10})",
                    style: AppTheme.normalBoldStyle,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return const _CardDoc();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardDoc extends StatelessWidget {
  const _CardDoc({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "1515",
                style: AppTheme.normalBoldStyle,
              ),
              Text(
                "Usuario",
                style: AppTheme.normalBoldStyle,
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "destionationDocs");
          },
          child: const CardWidget(
            color: AppTheme.grayAppBar,
            width: double.infinity,
            raidus: 0,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Requerimiento de traslado",
                      style: AppTheme.normalBoldStyle,
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fecha docuento:",
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        "12/12/2024",
                        style: AppTheme.normalStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Fecha hora:",
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        "12/12/2024 12:12:12",
                        style: AppTheme.normalStyle,
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Bodega origen:",
                    style: AppTheme.normalBoldStyle,
                  ),
                  Text(
                    "Dolore irure eiusmod laboris quis.",
                    style: AppTheme.normalStyle,
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Bodega destino:",
                    style: AppTheme.normalBoldStyle,
                  ),
                  Text(
                    "Anim cupidatat adipisicing adipisicing.",
                    style: AppTheme.normalStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}
