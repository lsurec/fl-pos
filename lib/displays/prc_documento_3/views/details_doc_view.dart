import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Resumen Documento (${document.consecutivo})",
          style: AppTheme.titleStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.print_outlined),
            tooltip: "Imprimir",
          ),
          // if (!vm.showBlock)
          //   IconButton(
          //     onPressed: () => vm.showBlock = true,
          //     icon: const Icon(
          //       Icons.lock_outline,
          //     ),
          //     tooltip: "Desbloquear documento",
          //   ),
          // if (vm.showBlock)
          //   IconButton(
          //     onPressed: () => vm.showBlock = false,
          //     icon: const Icon(
          //       Icons.lock_open_outlined,
          //     ),
          //     tooltip: "Bloquear documento",
          //   ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: AppTheme.normalStyle,
                  children: [
                    const TextSpan(text: "Fecha: ", style: AppTheme.titleStyle),
                    TextSpan(text: document.fecha, style: AppTheme.normalStyle)
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  style: AppTheme.normalStyle,
                  children: [
                    const TextSpan(
                        text: "Empresa: ", style: AppTheme.titleStyle),
                    TextSpan(
                        text:
                            "${document.empresa.empresaNombre} (${document.empresa.empresa})",
                        style: AppTheme.normalStyle)
                  ],
                ),
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  style: AppTheme.normalStyle,
                  children: [
                    const TextSpan(
                        text: "Estación: ", style: AppTheme.titleStyle),
                    TextSpan(
                        text:
                            "${document.estacion.descripcion} (${document.estacion.estacionTrabajo})",
                        style: AppTheme.normalStyle)
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
                      const Text(
                        "Tipo docuemento:",
                        style: AppTheme.titleStyle,
                      ),
                      Text(
                        document.documento,
                        style: AppTheme.normalStyle,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Serie documento:",
                        style: AppTheme.titleStyle,
                      ),
                      Text(
                        document.serie,
                        style: AppTheme.normalStyle,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              const Text(
                "Cuenta: ",
                style: AppTheme.titleStyle,
              ),
              const SizedBox(height: 5),
              if (document.client == null)
                const Text(
                  "No disponible",
                  style: AppTheme.normalStyle,
                ),
              if (document.client != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Nit: ${document.client!.facturaNit}",
                      style: AppTheme.normalStyle,
                    ),
                    Text(
                      "Nombre: ${document.client!.facturaNombre}",
                      style: AppTheme.normalStyle,
                    ),
                    Text(
                      "Dirección: ${document.client!.facturaDireccion}",
                      style: AppTheme.normalStyle,
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
                    const Text(
                      "Vendedor:",
                      style: AppTheme.titleStyle,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      document.seller!,
                      style: AppTheme.normalStyle,
                    ),
                  ],
                ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              const Text(
                "Productos:",
                style: AppTheme.titleStyle,
              ),
              const SizedBox(height: 5),
              _Transaction(
                transactions: document.transactions,
              ),
              const SizedBox(height: 5),
              const Divider(),
              const SizedBox(height: 5),
              const Text(
                "Forma de pago",
                style: AppTheme.titleStyle,
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
                      color: Colors.grey[400]!,
                      width: 1.0), // Define el color y grosor del borde
                ),
                color: AppTheme.backroundColor,
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      RowTotalWidget(
                        title: "Subtotal",
                        value: document.subtotal,
                      ),
                      RowTotalWidget(
                        title: "(+) Cargo",
                        value: document.cargo,
                      ),
                      RowTotalWidget(
                        title: "(-) Descuento",
                        value: document.descuento,
                      ),
                      const Divider(),
                      RowTotalWidget(
                        title: "Total",
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
                    const Text(
                      "Observacion",
                      style: AppTheme.titleStyle,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      document.observacion,
                      style: AppTheme.normalStyle,
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
              //         color:
              //             vm.showBlock ? Colors.red : const Color(0xFFCCCCCC),
              //         child: const Center(
              //           child: Text(
              //             "Anular",
              //             style: TextStyle(
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
                color: Colors.grey[400]!,
                width: 1.0), // Define el color y grosor del borde
          ),
          color: AppTheme.backroundColor,
          child: ListTile(
            title: Text(
              amount.payment.descripcion,
              style: AppTheme.normalStyle,
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (amount.authorization != "")
                  Text(
                    'Autorización: ${amount.authorization}',
                    style: AppTheme.normalStyle,
                  ),
                if (amount.reference != "")
                  Text(
                    'Referencia: ${amount.reference}',
                    style: AppTheme.normalStyle,
                  ),
                if (amount.payment.banco)
                  Text(
                    'Banco: ${amount.bank?.nombre}',
                    style: AppTheme.normalStyle,
                  ),
                if (amount.account != null)
                  Text(
                    'Cuenta: ${amount.account!.descripcion}',
                    style: AppTheme.normalStyle,
                  ),
                Text(
                  'Monto: ${currencyFormat.format(amount.amount)}',
                  style: AppTheme.normalStyle,
                ),
                Text(
                  'Diferencia: ${currencyFormat.format(amount.diference)}',
                  style: AppTheme.normalStyle,
                ),
                Text(
                  'Pago total: ${currencyFormat.format(amount.amount + amount.diference)}',
                  style: AppTheme.normalStyle,
                ),
                // Text('Detalles: ${transaction.detalles}'),
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
                color: Colors.grey[400]!,
                width: 1.0), // Define el color y grosor del borde
          ),
          color: AppTheme.backroundColor,
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${transaction.cantidad} x ${transaction.product.desProducto}',
                  style: AppTheme.normalStyle,
                ),
                Text(
                  'SKU: ${transaction.product.productoId}',
                  style: AppTheme.normalStyle,
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Precio Unitario: ${currencyFormat.format(transaction.cantidad > 0 ? transaction.total / transaction.cantidad : transaction.total)}',
                  style: AppTheme.normalStyle,
                ),

                Text(
                  'Total: ${currencyFormat.format(transaction.total)}',
                  style: AppTheme.normalStyle,
                ),

                // Text('Detalles: ${transaction.detalles}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
