import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
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
                  Preferences.idTheme,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    '${transaction.cantidad} x ${transaction.producto.desProducto} (SKU: ${transaction.producto.productoId})',
                    style: AppTheme.style(
                      context,
                      Styles.bold,
                      Preferences.idTheme,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${AppLocalizations.of(context)!.translate(
                          BlockTranslate.calcular,
                          'precioU',
                        )}: ${currencyFormat.format(transaction.precio!.precioU)}',
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                          Preferences.idTheme,
                        ),
                      ),
                      Text(
                        '${AppLocalizations.of(context)!.translate(
                          BlockTranslate.calcular,
                          'precioT',
                        )}: ${currencyFormat.format(transaction.total)}',
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                          Preferences.idTheme,
                        ),
                      ),
                      if (transaction.cargo != 0)
                        Text(
                          '${AppLocalizations.of(context)!.translate(
                            BlockTranslate.calcular,
                            'cargo',
                          )}: ${currencyFormat.format(transaction.cargo)}',
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
                        ),

                      if (transaction.descuento != 0)
                        Text(
                          '${AppLocalizations.of(context)!.translate(
                            BlockTranslate.calcular,
                            'descuento',
                          )}: ${currencyFormat.format(transaction.descuento)}',
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                            Preferences.idTheme,
                          ),
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
                          style: AppTheme.style(
                            context,
                            Styles.title,
                            Preferences.idTheme,
                          ),
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
                            Preferences.idTheme,
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
                          style: AppTheme.style(
                            context,
                            Styles.bold,
                            Preferences.idTheme,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.calcular,
                            'monto',
                          ),
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
                      Preferences.idTheme,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            activeColor: AppTheme.color(
                              context,
                              Styles.darkPrimary,
                              Preferences.idTheme,
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
                            style: AppTheme.style(
                              context,
                              Styles.cargDesc,
                              Preferences.idTheme,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            operacion.cargo == 0
                                ? currencyFormat.format(operacion.descuento)
                                : currencyFormat.format(operacion.cargo),
                            style: operacion.cargo == 0
                                ? AppTheme.style(
                                    context,
                                    Styles.descuento,
                                    Preferences.idTheme,
                                  )
                                : AppTheme.style(
                                    context,
                                    Styles.cargo,
                                    Preferences.idTheme,
                                  ),
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
