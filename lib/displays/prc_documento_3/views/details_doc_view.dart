import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
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

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              "${document.consecutivo}",
              style: AppTheme.style(
                context,
                Styles.title,
                Preferences.idTheme,
              ),
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
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                        Preferences.idTheme,
                      ),
                      children: [
                        TextSpan(
                          text: "Id Doc Ref: ",
                          style: AppTheme.style(
                            context,
                            Styles.title,
                            Preferences.idTheme,
                          ),
                        ),
                        TextSpan(
                          text: document.idRef.toString(),
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                        Preferences.idTheme,
                      ),
                      children: [
                        TextSpan(
                          text: "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.fecha,
                            'fecha',
                          )} ",
                          style: AppTheme.style(
                            context,
                            Styles.title,
                            Preferences.idTheme,
                          ),
                        ),
                        TextSpan(
                          text: document.fecha,
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                        Preferences.idTheme,
                      ),
                      children: [
                        TextSpan(
                          text: "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.localConfig,
                            'empresa',
                          )}: ",
                          style: AppTheme.style(
                            context,
                            Styles.title,
                            Preferences.idTheme,
                          ),
                        ),
                        TextSpan(
                          text:
                              "${document.empresa.empresaNombre} (${document.empresa.empresa})",
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  RichText(
                    text: TextSpan(
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                        Preferences.idTheme,
                      ),
                      children: [
                        TextSpan(
                          text: "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.localConfig,
                            'estacion',
                          )}: ",
                          style: AppTheme.style(
                            context,
                            Styles.title,
                            Preferences.idTheme,
                          ),
                        ),
                        TextSpan(
                          text:
                              "${document.estacion.descripcion} (${document.estacion.estacionTrabajo})",
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
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
                            style: AppTheme.style(
                              context,
                              Styles.title,
                              Preferences.idTheme,
                            ),
                          ),
                          Text(
                            document.documentoDesc,
                            style: AppTheme.style(
                              context,
                              Styles.normal,
                              Preferences.idTheme,
                            ),
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
                            style: AppTheme.style(
                              context,
                              Styles.title,
                              Preferences.idTheme,
                            ),
                          ),
                          Text(
                            document.serieDesc,
                            style: AppTheme.style(
                              context,
                              Styles.normal,
                              Preferences.idTheme,
                            ),
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
                    style: AppTheme.style(
                      context,
                      Styles.title,
                      Preferences.idTheme,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (document.client == null)
                    Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'noDisponible',
                      ),
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                        Preferences.idTheme,
                      ),
                    ),
                  if (document.client != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nit: ${document.client!.facturaNit}",
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.general,
                            'nombre',
                          )}: ${document.client!.facturaNombre}",
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
                        ),
                        Text(
                          "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.general,
                            'direccion',
                          )}: ${document.client!.facturaDireccion}",
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
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
                          style: AppTheme.style(
                            context,
                            Styles.title,
                            Preferences.idTheme,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          document.seller!,
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
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
                    style: AppTheme.style(
                      context,
                      Styles.title,
                      Preferences.idTheme,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _Transaction(
                    transactions: document.transactions,
                  ),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'formasPago',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.title,
                      Preferences.idTheme,
                    ),
                  ),
                  const SizedBox(height: 5),
                  _Pyments(amounts: document.payments),
                  const SizedBox(height: 5),
                  const Divider(),
                  const SizedBox(height: 5),
                  Card(
                    elevation: 0,
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: BorderSide(
                        color: AppTheme.color(
                          context,
                          Styles.border,
                          Preferences.idTheme,
                        ),
                        width: 1.0,
                      ), // Define el color y grosor del borde
                    ),
                    color: AppTheme.color(
                      context,
                      Styles.background,
                      Preferences.idTheme,
                    ),
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
                          style: AppTheme.style(
                            context,
                            Styles.title,
                            Preferences.idTheme,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          document.observacion,
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
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
            side: BorderSide(
              color: AppTheme.color(
                context,
                Styles.border,
                Preferences.idTheme,
              ),
              width: 1.0,
            ), // Define el color y grosor del borde
          ),
          color: AppTheme.color(
            context,
            Styles.background,
            Preferences.idTheme,
          ),
          child: ListTile(
            title: Text(
              amount.payment.descripcion,
              style: AppTheme.style(
                context,
                Styles.normal,
                Preferences.idTheme,
              ),
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
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),
                if (amount.reference != "")
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'referencia',
                    )}: ${amount.reference}',
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),
                if (amount.payment.banco)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'banco',
                    )}: ${amount.bank?.nombre}',
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),
                if (amount.account != null)
                  Text(
                    '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'cuenta',
                    )}: ${amount.account!.descripcion}',
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                      Preferences.idTheme,
                    ),
                  ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'monto',
                  )}: ${currencyFormat.format(amount.amount)}',
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
                ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'diferencia',
                  )}: ${currencyFormat.format(amount.diference)}',
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
                ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'pagoTotal',
                  )}: ${currencyFormat.format(amount.amount + amount.diference)}',
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
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
            side: BorderSide(
              color: AppTheme.color(
                context,
                Styles.border,
                Preferences.idTheme,
              ),
              width: 1.0,
            ), // Define el color y grosor del borde
          ),
          color: AppTheme.color(
            context,
            Styles.background,
            Preferences.idTheme,
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction.cantidad} x ${transaction.product.desProducto}',
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
                ),
                Text(
                  'SKU: ${transaction.product.productoId}',
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
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
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
                ),
                Text(
                  '${AppLocalizations.of(context)!.translate(
                    BlockTranslate.calcular,
                    'total',
                  )}: ${currencyFormat.format(transaction.total)}',
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                    Preferences.idTheme,
                  ),
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
