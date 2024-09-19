// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/order_view_model.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderView extends StatelessWidget {
  const OrderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<OrderViewModel>(context);
    final homeVM = Provider.of<HomeViewModel>(context);

    final currencyFormat = NumberFormat.currency(
      // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      symbol: homeVM.moneda,
      // Número de decimales a mostrar
      decimalDigits: 2,
    );

    final indexOrder = ModalRoute.of(context)!.settings.arguments as int;

    return WillPopScope(
      onWillPop: () => vm.backPage(context, indexOrder),
      child: Stack(
        children: [
          Scaffold(
            bottomNavigationBar: vm.isSelectedMode
                ? null
                : Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppTheme.border,
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 20,
                    ),
                    height: 110,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.calcular,
                                'total',
                              )}:",
                              style: StyleApp.title,
                            ),
                            Text(
                              currencyFormat.format(vm.getTotal(indexOrder)),
                              style: StyleApp.title,
                            )
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () =>
                                  vm.monitorPrint(context, indexOrder),
                              child: SizedBox(
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.translate(
                                      BlockTranslate.botones,
                                      'comandar',
                                    ),
                                    style: StyleApp.whiteBold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            appBar: AppBar(
              title: Text(
                vm.isSelectedMode
                    ? vm.getSelectedItems(indexOrder).toString()
                    : vm.orders[indexOrder].nombre,
                style: StyleApp.normal,
              ),
              actions: vm.isSelectedMode
                  ? [
                      IconButton(
                        onPressed: () => vm.selectedAll(indexOrder),
                        icon: const Icon(Icons.select_all),
                        tooltip: AppLocalizations.of(context)!.translate(
                          BlockTranslate.restaurante,
                          'seleccionarT',
                        ),
                      ),
                      IconButton(
                        onPressed: () => vm.deleteSelected(indexOrder, context),
                        icon: const Icon(Icons.delete_outline),
                        tooltip: AppLocalizations.of(context)!.translate(
                          BlockTranslate.botones,
                          'eliminar',
                        ),
                      ),
                      IconButton(
                        onPressed: () => vm.navigatePermisionView(
                          context,
                          indexOrder,
                        ),
                        icon: const Icon(Icons.drive_file_move_outline),
                        tooltip: AppLocalizations.of(context)!.translate(
                          BlockTranslate.botones,
                          'trasladar',
                        ),
                      ),
                    ]
                  : null,
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: vm.orders[indexOrder].transacciones.length,
                itemBuilder: (BuildContext context, int index) {
                  final TraRestaurantModel transaction =
                      vm.orders[indexOrder].transacciones[index];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () => vm.isSelectedMode
                            ? vm.sleectedItem(indexOrder, index)
                            : null,
                        // vm.modifyTra(context, indexOrder, index),
                        onLongPress: () => vm.onLongPress(indexOrder, index),
                        child: Stack(
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        transaction.producto.desProducto,
                                        style: StyleApp.normal,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "${currencyFormat.format(transaction.precio.precioU)} C/U",
                                        style: StyleApp.normal,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        vm.getGuarniciones(indexOrder, index),
                                        //tenia estil de la version
                                        style: StyleApp.verMas,
                                      ),
                                      if (transaction.observacion.isNotEmpty)
                                        Column(
                                          children: [
                                            const SizedBox(height: 5),
                                            TextsWidget(
                                              title:
                                                  AppLocalizations.of(context)!
                                                      .translate(
                                                BlockTranslate.restaurante,
                                                'notas',
                                              ),
                                              text: transaction.observacion,
                                            ),
                                          ],
                                        ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      currencyFormat.format(
                                        transaction.cantidad *
                                            transaction.precio.precioU,
                                      ),
                                      style: StyleApp.normalBold,
                                    ),
                                    const SizedBox(height: 5),
                                    Container(
                                      height: 45,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: AppTheme.border,
                                        ),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            onPressed: vm
                                                    .orders[indexOrder]
                                                    .transacciones[index]
                                                    .processed
                                                ? null
                                                : () => vm.decrement(
                                                      context,
                                                      indexOrder,
                                                      index,
                                                    ),
                                            icon: transaction.cantidad == 1
                                                ? const Icon(
                                                    Icons.delete_outline)
                                                : const Icon(Icons.remove),
                                          ),
                                          Text(
                                            "${transaction.cantidad}",
                                            style: vm
                                                    .orders[indexOrder]
                                                    .transacciones[index]
                                                    .processed
                                                ? StyleApp.greyText
                                                : StyleApp.normalBold,
                                          ),
                                          IconButton(
                                            onPressed: vm
                                                    .orders[indexOrder]
                                                    .transacciones[index]
                                                    .processed
                                                ? null
                                                : () => vm.increment(
                                                      indexOrder,
                                                      index,
                                                    ),
                                            icon: const Icon(Icons.add),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (vm.orders[indexOrder]
                                        .transacciones[index].processed)
                                      Column(
                                        children: [
                                          const SizedBox(height: 5),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .translate(
                                              BlockTranslate.botones,
                                              'comandada',
                                            ),
                                            style: StyleApp.red,
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ],
                            ),
                            if (vm.isSelectedMode &&
                                vm.orders[indexOrder].transacciones[index]
                                    .selected)
                              const Positioned(
                                left: 40,
                                bottom: 0,
                                child: Icon(
                                  Icons.check_circle,
                                  color: AppTheme.verde,
                                ),
                              ),
                            // if (vm.orders[indexOrder].transacciones[index]
                            //     .processed)
                            //   const Positioned(
                            //     left: 0,
                            //     bottom: 0,
                            //     child: Icon(
                            //       Icons.lock_outline,
                            //       color: Colors.red,
                            //     ),
                            //   ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                    ],
                  );
                },
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
