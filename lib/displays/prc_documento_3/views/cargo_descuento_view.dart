import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CargoDescuentoView extends StatelessWidget {
  const CargoDescuentoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //arguments
    final int indexDocument = ModalRoute.of(context)!.settings.arguments as int;

    //view model
    final vm = Provider.of<DetailsViewModel>(context);
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );
    //transaccion que se va a usar
    final TraInternaModel transaction = vm.traInternas[indexDocument];

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Card(
                color: AppTheme.color(
                  context,
                  Styles.transaction,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    '${transaction.cantidad} x ${transaction.producto.desProducto} (SKU: ${transaction.producto.productoId})',
                    style: StyleApp.normalBold,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.translate(
                          BlockTranslate.calcular,
                          'precioU',
                        )}: ${currencyFormat.format(transaction.precio!.precioU)}',
                        style: StyleApp.normal,
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.translate(
                          BlockTranslate.calcular,
                          'precioT',
                        )}: ${currencyFormat.format(transaction.total)}',
                        style: StyleApp.normal,
                      ),
                      if (transaction.cargo != 0)
                        Text(
                          '${AppLocalizations.of(context)!.translate(
                            BlockTranslate.calcular,
                            'cargo',
                          )}: ${currencyFormat.format(transaction.cargo)}',
                          style: StyleApp.normal,
                        ),

                      if (transaction.descuento != 0)
                        Text(
                          '${AppLocalizations.of(context)!.translate(
                            BlockTranslate.calcular,
                            'descuento',
                          )}: ${currencyFormat.format(transaction.descuento)}',
                          style: StyleApp.normal,
                        ),
                      // Text('Detalles: ${transaction.detalles}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              if (transaction.operaciones.isNotEmpty)
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.calcular,
                            'cargoDecuento',
                          ),
                          style: StyleApp.title,
                        ),
                        IconButton(
                          onPressed: () =>
                              vm.deleteMonto(context, indexDocument),
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const SizedBox(width: 12),
                        Checkbox(
                          activeColor: AppTheme.color(
                            context,
                            Styles.darkPrimary,
                          ),
                          value: vm.selectAllMontos,
                          onChanged: (value) =>
                              vm.selectAllMonto(value, indexDocument),
                        ),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.general,
                            'descripcion',
                          ),
                          style: StyleApp.normalBold,
                        ),
                        const Spacer(),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.calcular,
                            'monto',
                          ),
                          style: StyleApp.normalBold,
                        ),
                      ],
                    ),
                  ],
                ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: transaction.operaciones.length,
                itemBuilder: (BuildContext context, int index) {
                  final TraInternaModel operacion =
                      transaction.operaciones[index];
                  return Card(
                    color: AppTheme.color(
                      context,
                      Styles.transaction,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: AppTheme.color(
                              context,
                              Styles.darkPrimary,
                            ),
                            value: operacion.isChecked,
                            onChanged: (value) => vm.changeCheckedMonto(
                              value,
                              indexDocument,
                              index,
                            ),
                          ),
                          Text(
                            operacion.cargo == 0
                                ? AppLocalizations.of(context)!.translate(
                                    BlockTranslate.calcular,
                                    'descuento',
                                  )
                                : AppLocalizations.of(context)!.translate(
                                    BlockTranslate.calcular,
                                    'cargo',
                                  ),
                            style: StyleApp.greyBold,
                          ),
                          const Spacer(),
                          Text(
                            operacion.cargo == 0
                                ? currencyFormat.format(operacion.descuento)
                                : currencyFormat.format(operacion.cargo),
                            style: operacion.cargo == 0
                                ? StyleApp.descuento
                                : StyleApp.cargo,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
