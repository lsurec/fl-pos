import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/document_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
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
                  style: StyleApp.normalBold,
                ),
              ],
            ),
            Expanded(
              child: ListView.separated(
                itemCount: clients.length,
                // Agregar el separador
                separatorBuilder: (
                  context,
                  index,
                ) =>
                    const Divider(
                  color: AppNewTheme.grey,
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
                      style: StyleApp.normal,
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 3),
                        Text(
                          client.facturaNombre,
                          style: StyleApp.normal,
                        ),
                        const SizedBox(height: 3),
                        Text("(${client.desCuentaCta})")
                      ],
                    ),
                    onTap: () => docVM.selectClient(true, client, context),
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
