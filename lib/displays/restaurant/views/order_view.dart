import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/order_view_model.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/texts_widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrderViewModel>(context, listen: false);
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);

    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          vm.orders[0].nombre,
          style: AppTheme.style(context, Styles.normal),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: vm.orders[0].transacciones.length,
          itemBuilder: (BuildContext context, int index) {
            final TraRestaurantModel transaction =
                vm.orders[0].transacciones[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const SizedBox(
                      height: 50,
                      width: 50,
                      child: _ProductImage(
                        url:
                            'https://okdiario.com/img/recetas/2016/12/29/desayunos-alrededor-del-mundo-2.jpg',
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.producto.desProducto,
                            style: AppTheme.style(context, Styles.normal),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            vm.getGuarniciones(0, index),
                            style: AppTheme.style(context, Styles.versionStyle),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          currencyFormat.format(
                            transaction.cantidad * transaction.precio.precioU,
                          ),
                          style: AppTheme.style(context, Styles.bold),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          height: 45,
                          width: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.primary),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              IconButton(
                                onPressed: () => {},
                                icon: transaction.cantidad == 1
                                    ? const Icon(Icons.delete_outline)
                                    : const Icon(Icons.remove),
                              ),
                              Text(
                                "${transaction.cantidad}",
                                style: AppTheme.style(context, Styles.bold),
                              ),
                              IconButton(
                                onPressed: () => {},
                                icon: const Icon(Icons.add),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                if (transaction.observacion.isNotEmpty)
                  Column(
                    children: [
                      TextsWidget(
                          title: "Notas: ", text: transaction.observacion),
                      const SizedBox(height: 10),
                    ],
                  ),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    Key? key,
    this.url,
  }) : super(key: key);
  final String? url;

  @override
  Widget build(BuildContext context) {
    return getImage(url);
  }

  Widget getImage(String? picture) {
    if (picture == null || picture.isEmpty) {
      return const Image(
        image: AssetImage("assets/placeimg.jpg"),
        fit: BoxFit.cover,
      );
    }

    return FadeInImage(
      placeholder: const AssetImage('assets/load.gif'),
      image: NetworkImage(url!),
      fit: BoxFit.cover,
    );
  }
}
