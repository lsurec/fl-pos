import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DestinationDocView extends StatelessWidget {
  const DestinationDocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final OriginDocModel document =
        ModalRoute.of(context)!.settings.arguments as OriginDocModel;

    final vm = Provider.of<DestinationDocViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.cotizacion,
                'destinoDoc',
              ),
              style: AppTheme.style(
                Styles.title,
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: RefreshIndicator(
              onRefresh: () => vm.loadData(context, document),
              child: ListView(
                children: [
                  Column(
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
                              Styles.bold,
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vm.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          final DestinationDocModel doc = vm.documents[index];

                          return GestureDetector(
                            onTap: () =>
                                vm.navigateConvert(context, document, doc),
                            child: CardWidget(
                              color: AppTheme.color(
                                Styles.secondBackground,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.translate(
                                        BlockTranslate.general,
                                        'documento',
                                      )}:",
                                      style: AppTheme.style(
                                        Styles.bold,
                                      ),
                                    ),
                                    Text(
                                      doc.documento,
                                      style: AppTheme.style(
                                        Styles.normal,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      AppLocalizations.of(context)!.translate(
                                        BlockTranslate.general,
                                        'serie',
                                      ),
                                      style: AppTheme.style(
                                        Styles.bold,
                                      ),
                                    ),
                                    Text(
                                      doc.serie,
                                      style: AppTheme.style(
                                        Styles.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.color(
              Styles.loading,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
