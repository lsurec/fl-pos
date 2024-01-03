import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductView extends StatelessWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewModel>(context);

    final List arguments = ModalRoute.of(context)!.settings.arguments as List;

    final ProductModel product = arguments[0];
    final int back = arguments[1]; //1 regresar 1, 2 regresar 2

    final homeVM = Provider.of<HomeViewModel>(context, listen: false);

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          bottomNavigationBar: _BottomBar(
            product: product,
            back: back,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "SKU: ${product.productoId}",
                    style: AppTheme.titleStyle,
                  ),
                  const SizedBox(height: 10),
                  _NumericField(),
                  const Text(
                    "Descripción",
                    style: TextStyle(
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.desProducto,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Bodega",
                    style: TextStyle(
                      color: AppTheme.primary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButton<BodegaProductoModel>(
                    isExpanded: true,
                    isDense: true,
                    dropdownColor: AppTheme.backroundColor,
                    value: vm.selectedBodega,
                    onChanged: (value) =>
                        vm.changeBodega(value, context, product),
                    items: vm.bodegas.map((bodega) {
                      return DropdownMenuItem<BodegaProductoModel>(
                        value: bodega,
                        child: Text(
                            "(${bodega.bodega}) ${bodega.nombre} | Existencia (${bodega.existencia.toStringAsFixed(2)})"),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  if (vm.prices.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.prices.first.precio
                              ? "Tipo precio"
                              : "Presentaciones",
                          style: const TextStyle(
                            color: AppTheme.primary,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const TipoPrecioSelect(),
                      ],
                    ),
                  if (vm.prices.isEmpty)
                    const Text("No se encontraron precios"),
                  const SizedBox(height: 5),
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: "Precio Unitario",
                      labelText: "Precio Unitario",
                    ),
                    controller: vm.controllerPrice,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'))
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (value) => vm.chanchePrice(value), //TODO:cambiar
                  ),
                  Text(currencyFormat.format(vm.price)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "Total: ${currencyFormat.format(vm.total)}",
                        style: AppTheme.titleStyle,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.product,
    required this.back,
  });

  final ProductModel product;
  final int back;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewModel>(context);

    return SizedBox(
      height: 75,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                NotificationService.showSnackbar(
                    "Presione nuevamente para cancelar");
              },
              onDoubleTap: () => vm.cancelButton(back, context),
              child: Container(
                margin: const EdgeInsets.all(10),
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Cancelar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => vm.addTransaction(context, product, back),
              child: Container(
                margin: const EdgeInsets.all(10),
                color: AppTheme.primary,
                child: const Center(
                  child: Text(
                    "Agregar",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TipoPrecioSelect extends StatelessWidget {
  const TipoPrecioSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewModel>(context);

    return DropdownButton<UnitarioModel>(
      isExpanded: true,
      dropdownColor: AppTheme.backroundColor,
      value: vm.selectedPrice,
      onChanged: (value) => vm.changePrice(value),
      items: vm.prices.map(
        (precio) {
          return DropdownMenuItem<UnitarioModel>(
            value: precio,
            child: Text(precio.descripcion),
          );
        },
      ).toList(),
    );
  }
}

class _NumericField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewModel>(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: "cantidad",
              labelText: "Cantidad",
            ),
            controller: vm.controllerNum,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
            ],
            keyboardType: TextInputType.number,
            onChanged: (value) => vm.changeTextNum(value),
          ),
        ),
        Column(
          children: [
            IconButton(
              onPressed: vm.incrementNum,
              icon: const Icon(Icons.add_circle_outline),
            ),
            IconButton(
              onPressed: vm.decrementNum,
              icon: const Icon(Icons.remove_circle_outline),
            ),
          ],
        )
      ],
    );
  }
}
