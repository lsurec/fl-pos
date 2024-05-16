import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class PendingDocsView extends StatelessWidget {
  const PendingDocsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PendingDocsViewModel>(context);
    final TypeDocModel tipoDoc =
        ModalRoute.of(context)!.settings.arguments as TypeDocModel;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "${tipoDoc.fDesTipoDocumento} (${AppLocalizations.of(context)!.translate(
                BlockTranslate.cotizacion,
                'origen',
              )})",
              style: AppTheme.titleStyle,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => vm.laodData(context),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.translate(
                                    BlockTranslate.fecha,
                                    'inicio',
                                  ),
                                  style: AppTheme.normalBoldStyle,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => vm.showPickerIni(context),
                                icon: const Icon(Icons.calendar_today_outlined),
                                label: Text(
                                  vm.formatView(vm.fechaIni!),
                                  style: AppTheme.normalStyle,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.translate(
                                    BlockTranslate.fecha,
                                    'fin',
                                  ),
                                  style: AppTheme.normalBoldStyle,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => vm.showPickerFin(context),
                                icon: const Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppTheme.primary,
                                ),
                                label: Text(
                                  vm.formatView(vm.fechaFin!),
                                  style: AppTheme.normalStyle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        children: [
                          SizedBox(
                            width: 175,
                            child: DropdownButton<String>(
                              isExpanded: true,
                              dropdownColor: AppTheme.backroundColor,
                              value: vm.selectFilter,
                              onChanged: (value) => vm.changeFilter(value!),
                              items: vm.filters.map(
                                (filter) {
                                  return DropdownMenuItem<String>(
                                    value: filter,
                                    child: Text(
                                      filter,
                                      style: AppTheme.normalStyle,
                                    ),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                          IconButton(
                            onPressed: () => vm.ascendente = !vm.ascendente,
                            icon: Icon(
                              vm.ascendente
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'registro',
                            )} (${vm.documents.length})",
                            style: AppTheme.normalBoldStyle,
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vm.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _CardDoc(
                            document: vm.documents[index],
                          );
                        },
                      ),
                    ],
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
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _CardDoc extends StatelessWidget {
  const _CardDoc({
    required this.document,
  });

  final OriginDocModel document;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PendingDocsViewModel>(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.home,
                  'idDoc',
                )} ${document.iDDocumento}",
                style: AppTheme.normalBoldStyle,
              ),
              Text(
                "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.general,
                  'usuario',
                )}: ${document.usuario}",
                style: AppTheme.normalBoldStyle,
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => vm.navigateDestination(context, document),
          child: CardWidget(
            color: AppTheme.grayAppBar,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'fechaHora',
                        ),
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        vm.formatDate(document.fechaHora),
                        style: AppTheme.normalStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'fechaDoc',
                        ),
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        document.fechaDocumento,
                        style: AppTheme.normalStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  TextsWidget(
                      title: "${AppLocalizations.of(context)!.translate(
                        BlockTranslate.factura,
                        'serieDoc',
                      )}: ",
                      text: "${document.serie} (${document.serieDocumento})"),
                  const SizedBox(height: 5),
                  if (document.observacion.isNotEmpty)
                    TextsWidget(
                      title: "${AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'observacion',
                      )}: ",
                      text: document.observacion,
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
