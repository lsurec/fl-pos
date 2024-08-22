import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/tables_view_model.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class TransferSummaryView extends StatelessWidget {
  const TransferSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Datos simulados para el origen y el destino
    final String originLocation = "Balcón";

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resumen de Traslado',
          style: AppTheme.style(
            context,
            Styles.title,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Origen",
                    style: AppTheme.style(
                      context,
                      Styles.title,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  TextsWidget(
                    title: "Ubicacion: ",
                    text: originLocation,
                  ),
                  const SizedBox(height: 5),
                  TextsWidget(
                    title: "Mesa: ",
                    text: originLocation,
                  ),
                  const SizedBox(height: 5),
                  TextsWidget(
                    title: "Cuenta: ",
                    text: originLocation,
                  ),
                ],
              ),
            ),
            Container(
              color: const Color.fromARGB(255, 227, 226, 226),
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Destino",
                    style: AppTheme.style(
                      context,
                      Styles.title,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  TextsWidget(
                    title: "Ubicacion: ",
                    text: originLocation,
                  ),
                  const SizedBox(height: 5),
                  TextsWidget(
                    title: "Mesa: ",
                    text: originLocation,
                  ),
                  const SizedBox(height: 5),
                  TextsWidget(
                    title: "Cuenta: ",
                    text: originLocation,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: _Options(),
            )
          ],
        ),
      ),
    );
  }
}

class _Options extends StatelessWidget {
  const _Options();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primary),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {
                  final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
                    context,
                    listen: false,
                  );

                  tablesVM.restartTable();
                  Navigator.popUntil(
                      context, ModalRoute.withName(AppRoutes.order));
                },
                child: Center(
                  child: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'cancelar',
                      ),
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 17,
                      )),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.color(
                  context,
                  Styles.primary,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: () {},
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'confirmar',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.whiteStyle,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
