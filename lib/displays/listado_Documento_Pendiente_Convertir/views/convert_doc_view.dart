import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ConvertDocView extends StatelessWidget {
  const ConvertDocView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<dynamic> arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;

    final OriginDocModel docOrigen = arguments[0];
    final DestinationDocModel docDestino = arguments[1];

    final vm = Provider.of<ConvertDocViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          key: vm.scaffoldKey,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.cotizacion,
                'convertirDoc',
              ),
              style: StyleApp.title,
            ),
            // actions: const [_Actions()],
          ),
          floatingActionButton: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Positioned(
                // Ajusta esta posición según lo que necesites
                // bottom: 70,
                // right: 10,
                bottom: 10,
                right: 10,
                child: FloatingActionButton(
                  heroTag: 'button1', // Tag único para el primer botón
                  onPressed: () => vm.convertirDocumento(
                    context,
                    docOrigen,
                    docDestino,
                  ),
                  child: const Icon(
                    Icons.check,
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 10,
              //   right: 10,
              //   child: FloatingActionButton(
              //     heroTag: 'button2', // Tag único para el segundo botón
              //     onPressed: () {
              //       //editar

              //       vm.editarNewDocumento(
              //         context,
              //         docOrigen,
              //       );
              //     },
              //     child: Icon(
              //       Icons.edit,
              //     ),
              //   ),
              // ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => vm.loadData(context, docOrigen),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextsWidget(
                        title: "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.cotizacion,
                          'idDoc',
                        )}: ",
                        text: "${docOrigen.iDDocumento}",
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      ColorTextCardWidget(
                        color: AppNewTheme.verde,
                        text: "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.cotizacion,
                          'origenT',
                        )} - (${docOrigen.documento}) ${docOrigen.documentoDescripcion} - (${docOrigen.serieDocumento}) ${docOrigen.serie}.",
                      ),
                      ColorTextCardWidget(
                        color: AppNewTheme.rojo,
                        text: "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.cotizacion,
                          'destinoT',
                        )} - (${docDestino.fTipoDocumento}) ${docDestino.documento} - (${docDestino.fSerieDocumento}) ${docDestino.serie}.",
                      ),
                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 13),
                            child: Checkbox(
                              activeColor: AppNewTheme.hexToColor(
                                Preferences.valueColor,
                              ),
                              value: vm.selectAllTra,
                              onChanged: (value) => vm.selectAllTra = value!,
                            ),
                          ),
                          Text(
                            "${AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'registro',
                            )} (${vm.detailsOrigin.length})",
                            style: StyleApp.normalBold,
                          ),
                        ],
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vm.detailsOrigin.length,
                        itemBuilder: (BuildContext context, int index) {
                          DetailOriginDocInterModel detallle =
                              vm.detailsOrigin[index];

                          return _CardDetalle(
                            documento: detallle,
                            index: index,
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

// ignore: unused_element
class _Actions extends StatelessWidget {
  const _Actions();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Container(
              color: AppNewTheme.isDark()
                  ? AppNewTheme.darkBackroundColor
                  : AppNewTheme.backroundColor,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextsWidget(
                      title: "${AppLocalizations.of(context)!.translate(
                        BlockTranslate.cotizacion,
                        'idDoc',
                      )}:",
                      text: "10",
                    ),
                    const SizedBox(height: 10),
                    const TextsWidget(
                      title: "NIT: ",
                      text: "10151515",
                    ),
                    TextsWidget(
                      title: "${AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'nombre',
                      )}: ",
                      text: "Nombre del cliente",
                    ),
                    TextsWidget(
                      title: "${AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'direccion',
                      )}: ",
                      text: "Ciudad",
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      icon: const Icon(Icons.info_outline),
    );
  }
}

class _CardDetalle extends StatelessWidget {
  const _CardDetalle({
    required this.documento,
    required this.index,
  });

  final DetailOriginDocInterModel documento;
  final int index;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ConvertDocViewModel>(context);

    return GestureDetector(
      onTap: () {
        if (vm.detailsOrigin[index].detalle.disponible == 0) {
          NotificationService.showSnackbar(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'noMarcarSiEsCero',
            ),
          );
          return;
        }

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: AppNewTheme.isDark()
                  ? AppNewTheme.darkBackroundColor
                  : AppNewTheme.backroundColor,
              title: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.cotizacion,
                  'autorizar',
                ),
              ),
              content: TextFormField(
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.translate(
                    BlockTranslate.factura,
                    'cantidad',
                  ),
                  hintText: AppLocalizations.of(context)!.translate(
                    BlockTranslate.factura,
                    'cantidad',
                  ),
                ),
                initialValue: "${documento.detalle.disponible}",
                onChanged: (value) => vm.textoInput = value,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(
                      r'^(\d+)?\.?\d{0,2}',
                    ),
                  )
                ],
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.translate(
                      BlockTranslate.notificacion,
                      'requerido',
                    );
                  } else if (double.tryParse(value) == 0) {
                    return AppLocalizations.of(context)!.translate(
                      BlockTranslate.notificacion,
                      'noCero',
                    );
                  }
                  return null;
                },
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'cancelar',
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => vm.modificarDisponible(context, index),
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'aceptar',
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: CardWidget(
        child: ListTile(
          leading: Checkbox(
            value: documento.checked,
            onChanged: (value) => vm.selectTra(
              context,
              index,
              value!,
            ),
            activeColor: AppNewTheme.hexToColor(
              Preferences.valueColor,
            ),
          ),
          contentPadding: const EdgeInsets.all(10),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextsWidget(
                title: "Id: ",
                text: documento.detalle.id,
              ),
              const SizedBox(height: 5),
              TextsWidget(
                title: "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.cotizacion,
                  'producto',
                )}: ",
                text: documento.detalle.productoDescripcion,
              ),
              const SizedBox(height: 5),
              TextsWidget(
                title: "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.factura,
                  'cantidad',
                )}: ",
                text: "${documento.detalle.cantidad}",
              ),
              const SizedBox(height: 5),
              TextsWidget(
                title: "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.cotizacion,
                  'disponible',
                )}: ",
                text: "${documento.detalle.disponible}",
              ),
              const SizedBox(height: 5),
              TextsWidget(
                title: "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.cotizacion,
                  'autorizar',
                )}: ",
                text: "${documento.detalle.disponible}",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
