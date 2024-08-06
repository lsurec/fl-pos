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
        child: ListView.separated(
          itemCount: vm.orders[0].transacciones.length,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
          itemBuilder: (BuildContext context, int index) {
            final TraRestaurantModel transaction =
                vm.orders[0].transacciones[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    transaction.producto.desProducto,
                    style: AppTheme.style(context, Styles.normal),
                  ),
                  subtitle: Text(vm.getGuarniciones(0, index)),
                  trailing: Text(
                    currencyFormat.format(
                      transaction.cantidad * transaction.precio.precioU,
                    ),
                    style: AppTheme.style(context, Styles.bold),
                  ),
                  leading: const SizedBox(
                    height: 50,
                    width: 50,
                    child: _ProductImage(
                      url:
                          'https://okdiario.com/img/recetas/2016/12/29/desayunos-alrededor-del-mundo-2.jpg',
                    ),
                  ),
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
                Container(
                  height: 45,
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
