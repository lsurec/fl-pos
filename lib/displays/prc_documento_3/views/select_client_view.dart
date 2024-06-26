import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/document_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:provider/provider.dart';

class SelectClientView extends StatelessWidget {
  const SelectClientView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ClientModel> clients =
        ModalRoute.of(context)!.settings.arguments as List<ClientModel>;

    final docVM = Provider.of<DocumentViewModel>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "${AppLocalizations.of(context)!.translate(
                    BlockTranslate.general,
                    'registro',
                  )} (${clients.length})",
                  style: AppTheme.style(
                    context,
                    Styles.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: clients.length,
                // Agregar el separador
                separatorBuilder: (context, index) => Divider(
                  color: AppTheme.color(
                    context,
                    Styles.border,
                  ),
                ),
                itemBuilder: (context, index) {
                  final ClientModel client = clients[index];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 20,
                    ),
                    title: Text(
                      client.facturaNit,
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 3),
                        Text(
                          client.facturaNombre,
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text("(${client.desCuentaCta})")
                      ],
                    ),
                    onTap: () => docVM.selectClient(client, context),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
