import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/order_view_model.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrderViewModel>(context, listen: false);

    return Scaffold(
      body: ListView.separated(
        itemCount: vm.orders[0].transacciones.length,
        separatorBuilder: (BuildContext context, int index) {
          return const Divider();
        },
        itemBuilder: (BuildContext context, int index) {
          final TraRestaurantModel transaction =
              vm.orders[0].transacciones[index];

          return Column(
            children: [
              ListTile(
                title: Text(
                  transaction.producto.desProducto,
                  style: AppTheme.style(context, Styles.normal),
                ),
                subtitle: Text(vm.getGuarniciones(0, index)),
                leading: const SizedBox(
                  height: 50,
                  width: 50,
                  child: _ProductImage(
                    url:
                        'https://okdiario.com/img/recetas/2016/12/29/desayunos-alrededor-del-mundo-2.jpg',
                  ),
                ),
              ),
            ],
          );
        },
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
