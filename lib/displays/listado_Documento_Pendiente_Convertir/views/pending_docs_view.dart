import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
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
              style: StyleApp.title,
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
                                  style: StyleApp.normalBold,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => vm.showPickerIni(context),
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppTheme.color(
                                    context,
                                    Styles.darkPrimary,
                                  ),
                                ),
                                label: Text(
                                  vm.formatView(vm.fechaIni!),
                                  style: StyleApp.normal,
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
                                  style: StyleApp.normalBold,
                                ),
                              ),
                              TextButton.icon(
                                onPressed: () => vm.showPickerFin(context),
                                icon: Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppTheme.color(
                                    context,
                                    Styles.darkPrimary,
                                  ),
                                ),
                                label: Text(
                                  vm.formatView(vm.fechaFin!),
                                  style: StyleApp.normal,
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
                                    style: StyleApp.normal,
                                  ),
                                ),
                                DropdownMenuItem<int>(
                                  value: 2,
                                  child: Text(
                                    AppLocalizations.of(context)!.translate(
                                      BlockTranslate.fecha,
                                      'filtroDoc',
                                    ),
                                    style: StyleApp.normal,
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
                            style: StyleApp.normalBold,
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: vm.formKeySearch,
                        child: TextFormField(
                          onChanged: ((value) => vm.filtrar(context)),
                          onFieldSubmitted: (value) => vm.filtrar(context),
                          textInputAction: TextInputAction.search,
                          controller: vm.searchController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.translate(
                                BlockTranslate.notificacion,
                                'requerido',
                              );
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)!.translate(
                              BlockTranslate.tareas,
                              'buscar',
                            ),
                            labelText: AppLocalizations.of(context)!.translate(
                              BlockTranslate.tareas,
                              'buscar',
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.search,
                                color: AppTheme.color(
                                  context,
                                  Styles.darkPrimary,
                                ),
                              ),
                              onPressed: () => vm.filtrar(context),
                            ),
                          ),
                        ),
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
            color: AppNewTheme.isDark()
                ? AppNewTheme.darkBackroundColor
                : AppNewTheme.backroundColor,
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
                style: StyleApp.normalBold,
              ),
              Text(
                "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.general,
                  'usuario',
                )}: ${document.usuario}",
                style: StyleApp.normalBold,
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
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextsWidget(
                    title: AppLocalizations.of(context)!.translate(
                      BlockTranslate.cotizacion,
                      'idRef',
                    ),
                    text: document.consecutivoInternoRef.toString(),
                  ),
                  const SizedBox(height: 5),
                  TextsWidget(
                    title: AppLocalizations.of(context)!.translate(
                      BlockTranslate.cotizacion,
                      'cuenta',
                    ),
                    text: document.cliente,
                  ),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'fechaHora',
                        ),
                        style: StyleApp.normalBold,
                      ),
                      Text(
                        vm.formatDate(document.fechaHora),
                        style: StyleApp.normal,
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
                        style: StyleApp.normalBold,
                      ),
                      Text(
                        document.fechaDocumento,
                        style: StyleApp.normal,
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

                  // if (document.observacion1 != null ||
                  //     document.observacion1 != "")
                  //   TextsWidget(
                  //     title: "${AppLocalizations.of(context)!.translate(
                  //       BlockTranslate.general,
                  //       'observacion',
                  //     )}: ",
                  //     text: document.observacion1 ?? "",
                  //   ),
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
