import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
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
              style: AppTheme.style(
                context,
                Styles.title,
                Preferences.idTheme,
              ),
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
                                  style: AppTheme.style(
                                    context,
                                    Styles.bold,
                                    Preferences.idTheme,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => vm.showPickerIni(context),
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppTheme.color(
                                    context,
                                    Styles.darkPrimary,
                                    Preferences.idTheme,
                                  ),
                                ),
                                label: Text(
                                  vm.formatView(vm.fechaIni!),
                                  style: AppTheme.style(
                                    context,
                                    Styles.normal,
                                    Preferences.idTheme,
                                  ),
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
                                  style: AppTheme.style(
                                    context,
                                    Styles.bold,
                                    Preferences.idTheme,
                                  ),
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => vm.showPickerFin(context),
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppTheme.color(
                                    context,
                                    Styles.darkPrimary,
                                    Preferences.idTheme,
                                  ),
                                ),
                                label: Text(
                                  vm.formatView(vm.fechaFin!),
                                  style: AppTheme.style(
                                    context,
                                    Styles.normal,
                                    Preferences.idTheme,
                                  ),
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
                            child: DropdownButton<int>(
                              isExpanded: true,
                              dropdownColor: AppTheme.color(
                                context,
                                Styles.background,
                                Preferences.idTheme,
                              ),
                              value: vm.idSelectFilter,
                              onChanged: (value) => vm.changeFilter(value!),
                              items: [
                                DropdownMenuItem<int>(
                                  value: 1,
                                  child: Text(
                                    AppLocalizations.of(context)!.translate(
                                      BlockTranslate.cotizacion,
                                      'filtroDoc',
                                    ),
                                    style: AppTheme.style(
                                      context,
                                      Styles.normal,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                ),
                                DropdownMenuItem<int>(
                                  value: 2,
                                  child: Text(
                                    AppLocalizations.of(context)!.translate(
                                      BlockTranslate.fecha,
                                      'filtroDoc',
                                    ),
                                    style: AppTheme.style(
                                      context,
                                      Styles.normal,
                                      Preferences.idTheme,
                                    ),
                                  ),
                                ),
                              ],
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
                            style: AppTheme.style(
                              context,
                              Styles.bold,
                              Preferences.idTheme,
                            ),
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
            color: AppTheme.color(
              context,
              Styles.background,
              Preferences.idTheme,
            ),
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
                style: AppTheme.style(
                  context,
                  Styles.bold,
                  Preferences.idTheme,
                ),
              ),
              Text(
                "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.general,
                  'usuario',
                )}: ${document.usuario}",
                style: AppTheme.style(
                  context,
                  Styles.bold,
                  Preferences.idTheme,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => vm.navigateDestination(context, document),
          child: CardWidget(
            color: AppTheme.color(
              context,
              Styles.secondBackground,
              Preferences.idTheme,
            ),
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
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                          Preferences.idTheme,
                        ),
                      ),
                      Text(
                        vm.formatDate(document.fechaHora),
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                          Preferences.idTheme,
                        ),
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
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                          Preferences.idTheme,
                        ),
                      ),
                      Text(
                        document.fechaDocumento,
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                          Preferences.idTheme,
                        ),
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
                  if (document.observacion != null)
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
