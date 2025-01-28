// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailsDocView extends StatefulWidget {
  const DetailsDocView({Key? key}) : super(key: key);

  @override
  State<DetailsDocView> createState() => _DetailsDocViewState();
}

class _DetailsDocViewState extends State<DetailsDocView> {
  @override
  Widget build(BuildContext context) {
    // final vm = Provider.of<DetailsDocViewModel>(context);

    final DetailDocModel document =
        ModalRoute.of(context)?.settings.arguments as DetailDocModel;

    final vm = Provider.of<DetailsDocViewModel>(context);
    final docVM = Provider.of<DocumentViewModel>(context);
    final paymentsVM = Provider.of<PaymentViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "${document.consecutivo}",
              style: StyleApp.title,
            ),
            actions: [
              IconButton(
                onPressed: () => vm.navigatePrint(context, document),
                icon: const Icon(Icons.print_outlined),
                tooltip: AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  'imprimir',
                ),
              ),
              IconButton(
                onPressed: () => vm.share(context, document),
                icon: const Icon(Icons.share_outlined),
                tooltip: AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  'compartir',
                ),
              ),
              // if (!vm.showBlock)
              // IconButton(
              //   onPressed: () => vm.showBlock = true,
              //   icon: const Icon(
              //     Icons.lock_outline,
              //   ),
              //   tooltip: AppLocalizations.of(context)!.translate(
              //     BlockTranslate.botones,
              //     'desbloquearDoc',
              //   ),
              // ),
              // if (vm.showBlock)
              //   IconButton(
              //     onPressed: () => vm.showBlock = false,
              //     icon: const Icon(
              //       Icons.lock_open_outlined,
              //     ),
              //     tooltip: AppLocalizations.of(context)!.translate(
              //       BlockTranslate.botones,
              //       'bloquearDoc',
              //     ),
              //   ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: StyleApp.normal.copyWith(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.translate(
                            BlockTranslate.cotizacion,
                            'docIdRef',
                          ),
                          style: StyleApp.normalBold,
                        ),
                        TextSpan(
                          text: document.idRef.toString(),
                          style: StyleApp.normal,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: StyleApp.normal.copyWith(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      children: [
                        TextSpan(
                          text: "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.fecha,
                            'fecha',
                          )} ",
                          style: StyleApp.normalBold,
                        ),
                        TextSpan(
                          text: document.fecha,
                          style: StyleApp.normal,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: StyleApp.normal.copyWith(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      children: [
                        TextSpan(
                          text: "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.localConfig,
                            'empresa',
                          )}: ",
                          style: StyleApp.normalBold,
                        ),
                        TextSpan(
                          text:
                              "${document.empresa.empresaNombre} (${document.empresa.empresa})",
                          style: StyleApp.normal,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: StyleApp.normal.copyWith(
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                      children: [
                        TextSpan(
                          text: "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.localConfig,
                            'estacion',
                          )}: ",
                          style: StyleApp.normalBold,
                        ),
                        TextSpan(
                          text:
                              "${document.estacion.descripcion} (${document.estacion.estacionTrabajo})",
                          style: StyleApp.normal,
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate(
                              BlockTranslate.factura,
                              'tipoDoc',
                            )}:",
                            style: StyleApp.title,
                          ),
                          Text(
                            document.documentoDesc,
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate(
                              BlockTranslate.factura,
                              'serieDoc',
                            )}:",
                            style: StyleApp.title,
                          ),
                          Text(
                            document.serieDesc,
                            style: StyleApp.normal,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'cuenta',
                    ),
                    style: StyleApp.title,
                  ),
                  const SizedBox(height: 5),
                  if (document.client == null)
                    Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'noDisponible',
                      ),
                      style: StyleApp.normal,
                    ),
                  if (document.client != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nit: ${document.client!.facturaNit}",
                          style: StyleApp.normal,
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.general,
                            'nombre',
                          )}: ${document.client!.facturaNombre}",
                          style: StyleApp.normal,
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.general,
                            'direccion',
                          )}: ${document.client!.facturaDireccion}",
                          style: StyleApp.normal,
                        ),
                      ],
                    ),
                  if (document.seller != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.factura,
                            'vendedor',
                          ),
                          style: StyleApp.title,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          document.seller ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'noDisponible',
                              ),
                          style: StyleApp.normal,
                        ),
                      ],
                    ),
//Tipo Referencia: 58
                  if (document.docRefTipoReferencia != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.tiket,
                            'tipoRef',
                          ),
                          style: StyleApp.title,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "${document.docRefTipoReferencia}",
                          style: StyleApp.normal,
                        ),
                      ],
                    ),
//Contacto: 385
                  if (document.docRefObservacion2 != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          docVM.getTextParam(385) ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.factura,
                                'contacto',
                              ),
                          style: StyleApp.title,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          document.docRefObservacion2 ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'noDisponible',
                              ),
                          style: StyleApp.normal,
                        ),
                      ],
                    ),
//Descripcion: 383
                  if (document.docRefObservacion != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          docVM.getTextParam(383) ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'descripcion',
                              ),
                          style: StyleApp.title,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          document.docRefObservacion ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'noDisponible',
                              ),
                          style: StyleApp.normal,
                        ),
                      ],
                    ),
//Direccion Entrega: 386
                  if (document.docRefObservacion3 != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          docVM.getTextParam(386) ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.cotizacion,
                                'direEntrega',
                              ),
                          style: StyleApp.title,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          document.docRefObservacion3 ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'noDisponible',
                              ),
                          style: StyleApp.normal,
                        ),
                      ],
                    ),
//Observacion: 384
                  if (document.docRefDescripcion != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          docVM.getTextParam(384) ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'observacion',
                              ),
                          style: StyleApp.title,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          document.docRefDescripcion ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'noDisponible',
                              ),
                          style: StyleApp.normal,
                        ),
                      ],
                    ),
                  if (document.docRefFechaIni != null ||
                      document.docRefFechaFin != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
//Fecha Ref Ini
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          docVM.getTextParam(381) ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.fecha,
                                'entrega',
                              ),
                          style: StyleApp.title,
                        ),
                        Text(
                          Utilities.formatearFechaHora(
                            docVM.fechaRefIni,
                          ),
                          style: StyleApp.normal,
                        ),
//Fecha Ref Fin
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          docVM.getTextParam(382) ??
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.fecha,
                                'recoger',
                              ),
                          style: StyleApp.title,
                        ),
                        Text(
                          Utilities.formatearFechaHora(
                            docVM.fechaRefFin,
                          ),
                          style: StyleApp.normal,
                        ),
                      ],
                    ),
                  if (document.docFechaIni != null ||
                      document.docFechaFin != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
//Fecha Ini
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.fecha,
                            'inicio',
                          ),
                          style: StyleApp.title,
                        ),
                        Text(
                          Utilities.formatearFechaHora(
                            docVM.fechaInicial,
                          ),
                          style: StyleApp.normal,
                        ),
//Fecha Fin
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.fecha,
                            'fin',
                          ),
                          style: StyleApp.title,
                        ),
                        Text(
                          Utilities.formatearFechaHora(
                            docVM.fechaFinal,
                          ),
                          style: StyleApp.normal,
                        ),
                      ],
                    ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'productos',
                    ),
                    style: StyleApp.title,
                  ),
                  const SizedBox(height: 5),
                  _Transaction(
                    transactions: document.transactions,
                  ),
                  if (paymentsVM.paymentList.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.factura,
                            'formasPago',
                          ),
                          style: StyleApp.title,
                        ),
                        const SizedBox(height: 5),
                        _Pyments(amounts: document.payments),
                      ],
                    ),

                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(
                        color: AppTheme.grey,
                        width: 1.0,
                      ), // Define el color y grosor del borde
                    ),
                    color: AppTheme.isDark()
                        ? AppTheme.darkBackroundColor
                        : AppTheme.backroundColor,
                    child: Padding(
                      padding: const EdgeInsets.all(
                        10,
                      ),
                      child: Column(
                        children: [
                          RowTotalWidget(
                            title: AppLocalizations.of(context)!.translate(
                              BlockTranslate.calcular,
                              'subTotal',
                            ),
                            value: document.subtotal,
                          ),
                          RowTotalWidget(
                            title:
                                "(+) ${AppLocalizations.of(context)!.translate(
                              BlockTranslate.calcular,
                              'cargo',
                            )}",
                            value: document.cargo,
                          ),
                          RowTotalWidget(
                            title:
                                "(-) ${AppLocalizations.of(context)!.translate(
                              BlockTranslate.calcular,
                              'descuento',
                            )}",
                            value: document.descuento,
                          ),
                          const Divider(),
                          RowTotalWidget(
                            title: AppLocalizations.of(context)!.translate(
                              BlockTranslate.calcular,
                              'total',
                            ),
                            value: document.total,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (document.observacion.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.general,
                            'observacion',
                          ),
                          style: StyleApp.title,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          document.observacion,
                          style: StyleApp.normal,
                        ),
                      ],
                    ),
                  // const SizedBox(height: 5),
                  // SizedBox(
                  //   height: 75,
                  //   child: Expanded(
                  //     child: GestureDetector(
                  //       onTap: vm.showBlock ? () {} : null,
                  //       child: Container(
                  //         margin: const EdgeInsets.only(
                  //           top: 10,
                  //           bottom: 10,
                  //           right: 10,
                  //         ),
                  //         color: vm.showBlock
                  //             ? Colors.red
                  //             : const Color(0xFFCCCCCC),
                  //         child: Center(
                  //           child: Text(
                  //             AppLocalizations.of(context)!.translate(
                  //               BlockTranslate.botones,
                  //               'anular',
                  //             ),
                  //             style: const TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 17,
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.isDark()
                ? AppTheme.darkBackroundColor
                : AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _Pyments extends StatelessWidget {
  final List<AmountModel> amounts;

  const _Pyments({required this.amounts});

  @override
  Widget build(BuildContext context) {
    final homeVM = Provider.of<HomeViewModel>(context);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: amounts.length,
      itemBuilder: (BuildContext context, int index) {
        final AmountModel amount = amounts[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(
              color: AppTheme.grey,
              width: 1.0,
            ), // Define el color y grosor del borde
          ),
          color: AppTheme.isDark()
              ? AppTheme.darkBackroundColor
              : AppTheme.backroundColor,
          child: ListTile(
            title: Text(
              amount.payment.descripcion,
              style: StyleApp.normal,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (amount.authorization != "")
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'autorizar',
                    )}: ${amount.authorization}',
                    style: StyleApp.normal,
                  ),
                if (amount.reference != "")
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'referencia',
                    )}: ${amount.reference}',
                    style: StyleApp.normal,
                  ),
                if (amount.payment.banco)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'banco',
                    )}: ${amount.bank?.nombre}',
                    style: StyleApp.normal,
                  ),
                if (amount.account != null)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'cuenta',
                    )}: ${amount.account!.descripcion}',
                    style: StyleApp.normal,
                  ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'monto',
                  )}: ${currencyFormat.format(amount.amount)}',
                  style: StyleApp.normal,
                ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'diferencia',
                  )}: ${currencyFormat.format(amount.diference)}',
                  style: StyleApp.normal,
                ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'pagoTotal',
                  )}: ${currencyFormat.format(amount.amount + amount.diference)}',
                  style: StyleApp.normal,
                ),
                // Text('${AppLocalizations.of(context)!.translate(
                //   BlockTranslate.general,
                //   'detalles',
                // )}: ${transaction.detalles}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Transaction extends StatelessWidget {
  final List<TransactionDetail> transactions;

  const _Transaction({required this.transactions});

  @override
  Widget build(BuildContext context) {
    final homeVM = Provider.of<HomeViewModel>(context);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: transactions.length,
      itemBuilder: (BuildContext context, int index) {
        final TransactionDetail transaction = transactions[index];

        return Card(
          elevation: 0,
          margin: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(
              color: AppTheme.grey,
              width: 1.0,
            ), // Define el color y grosor del borde
          ),
          color: AppTheme.isDark()
              ? AppTheme.darkBackroundColor
              : AppTheme.backroundColor,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction.cantidad} x ${transaction.product.desProducto}',
                  style: StyleApp.normal,
                ),
                Text(
                  'SKU: ${transaction.product.productoId}',
                  style: StyleApp.normal,
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'precioU',
                  )}: ${currencyFormat.format(transaction.cantidad > 0 ? transaction.total / transaction.cantidad : transaction.total)}',
                  style: StyleApp.normal,
                ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'total',
                  )}: ${currencyFormat.format(transaction.total)}',
                  style: StyleApp.normal,
                ),
                // Text(
                //   '${AppLocalizations.of(context)!.translate(
                //     BlockTranslate.general,
                //     'detalles',
                //   )}: ${transaction.detalles}',
                // ),
              ],
            ),
          ),
        );
      },
    );
  }
}
