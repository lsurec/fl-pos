import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
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
                color: AppTheme.grayAppBar,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  title: Text(
                    '${transaction.cantidad} x ${transaction.producto.desProducto} (SKU: ${transaction.producto.productoId})',
                    style: AppTheme.normalBoldStyle,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Precio Unitario: ${currencyFormat.format(transaction.precio!.precioU)}',
                        style: AppTheme.normalStyle,
                      ),
                      Text(
                        'Precio Total: ${currencyFormat.format(transaction.total)}',
                        style: AppTheme.normalStyle,
                      ),
                      if (transaction.cargo != 0)
                        Text(
                          'Cargo: ${currencyFormat.format(transaction.cargo)}',
                          style: AppTheme.normalStyle,
                        ),

                      if (transaction.descuento != 0)
                        Text(
                          'Descuento: ${currencyFormat.format(transaction.descuento)}',
                          style: AppTheme.normalStyle,
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
                        const Text(
                          "Cargos y descuentos",
                          style: AppTheme.titleStyle,
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
                          activeColor: AppTheme.primary,
                          value: vm.selectAllMontos,
                          onChanged: (value) =>
                              vm.selectAllMonto(value, indexDocument),
                        ),
                        const Text(
                          "Descripcion",
                          style: AppTheme.normalBoldStyle,
                        ),
                        const Spacer(),
                        const Text(
                          "Monto",
                          style: AppTheme.normalBoldStyle,
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
                      color: AppTheme.grayAppBar,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Checkbox(
                              activeColor: AppTheme.primary,
                              value: operacion.isChecked,
                              onChanged: (value) => vm.changeCheckedMonto(
                                value,
                                indexDocument,
                                index,
                              ),
                            ),
                            Text(
                              operacion.cargo == 0 ? "Descuento" : "Cargo",
                              style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            const Spacer(),
                            Text(
                              operacion.cargo == 0
                                  ? currencyFormat.format(operacion.descuento)
                                  : currencyFormat.format(operacion.cargo),
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: operacion.cargo == 0
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            )
                          ],
                        ),
                      ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
