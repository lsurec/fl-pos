import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';

class HelpView extends StatelessWidget {
  const HelpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.botones,
            "ayuda",
          ),
          style: AppTheme.style(
            Styles.title,
          ),
        ),
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            HelpSection(),
            ClientSection(),
          ],
        ),
      ),
    );
  }
}

class HelpSection extends StatelessWidget {
  const HelpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: AppTheme.color(
          Styles.background,
        ),
        child: ListTile(
          title: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.impresora,
              "sinImprimir",
            ),
            style: AppTheme.style(
              Styles.bold,
            ),
          ),
          subtitle: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.impresora,
              "noVinculada",
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            // Aquí puedes agregar la lógica para abrir la sección de ayuda
            // o mostrar información adicional.
            NotificationService.showInfoPrint(context);
          },
        ),
      ),
    );
  }
}

class ClientSection extends StatelessWidget {
  const ClientSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: AppTheme.color(
          Styles.background,
        ),
        child: ListTile(
          title: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.cliente,
              "noEncontrado",
            ),
            style: AppTheme.style(
              Styles.bold,
            ),
          ),
          subtitle: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.cliente,
              "noRegistrado",
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onTap: () {
            // Lógica específica para la pregunta sobre la búsqueda de clientes
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.cliente,
                      "informacion",
                    ),
                  ),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.cliente,
                          "pasos",
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.cliente,
                          "verificar",
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.cliente,
                          "crear",
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.cliente,
                          "buscar",
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.cliente,
                          "soporte",
                        ),
                        style: AppTheme.style(
                          Styles.bold,
                        ),
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.botones,
                          "cerrar",
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
