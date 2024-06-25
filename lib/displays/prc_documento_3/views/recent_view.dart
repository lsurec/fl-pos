import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class RecentView extends StatefulWidget {
  const RecentView({Key? key}) : super(key: key);

  @override
  State<RecentView> createState() => _RecentViewState();
}

class _RecentViewState extends State<RecentView> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) {
    final vm = Provider.of<RecentViewModel>(context, listen: false);
    vm.loadDocs(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RecentViewModel>(context);
    final homeVM = Provider.of<HomeViewModel>(context);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.factura,
                'docRecientes',
              ),
              style: AppTheme.style(
                context,
                Styles.title,
                Preferences.idTheme,
              ),
            ),
          ),
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
                      )} (${vm.documents.length})",
                      style: AppTheme.style(
                        context,
                        Styles.bold,
                        Preferences.idTheme,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => vm.loadDocs(context),
                    child: ListView.separated(
                      itemCount: vm.documents.length,
                      separatorBuilder: (context, index) =>
                          const Divider(), // Agregar el separador
                      itemBuilder: (context, index) {
                        final DocumentoResumenModel doc = vm.documents[index];

                        return ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 0,
                            horizontal: 20,
                          ),
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Id. Ref: ${doc.estructura.docIdDocumentoRef}",
                                    style: AppTheme.style(
                                      context,
                                      Styles.bold,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                  Text(
                                    "Cons. Interno: ${doc.item.consecutivoInterno}",
                                    style: AppTheme.style(
                                      context,
                                      Styles.bold,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                  Text(
                                    vm.strDate(doc.item.fechaHora),
                                    style: AppTheme.style(
                                      context,
                                      Styles.normal,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(currencyFormat.format(doc.subtotal),
                                      style: AppTheme.style(
                                        context,
                                        Styles.blueText,
                                        Preferences.idTheme,
                                      )),
                                  Text(
                                    "(+) ${currencyFormat.format(doc.cargo)}",
                                    style: AppTheme.style(
                                      context,
                                      Styles.cargo,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                  Text(
                                    "(-) ${currencyFormat.format(doc.descuento)}",
                                    style: AppTheme.style(
                                      context,
                                      Styles.descuento,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                  Container(
                                    width: 50,
                                    height: 1,
                                    color: AppTheme.color(
                                      context,
                                      Styles.normal,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                  Text(
                                    currencyFormat.format(doc.total),
                                    style: AppTheme.style(
                                      context,
                                      Styles.bold,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () => vm.navigateView(context, doc),
                          // onTap: () {},
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.color(
              context,
              Styles.loading,
              Preferences.idTheme,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
