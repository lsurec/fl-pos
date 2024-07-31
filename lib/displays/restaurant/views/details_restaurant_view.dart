import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailsRestaurantView extends StatelessWidget {
  const DetailsRestaurantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeVM = Provider.of<HomeViewModel>(
      context,
      listen: false,
    );

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    final vmProduct = Provider.of<ProductsClassViewModel>(
      context,
      listen: false,
    );

    final docVM = Provider.of<DocumentViewModel>(context, listen: false);
    final vm = Provider.of<DetailsRestaurantViewModel>(context, listen: false);
    final ProductRestaurantModel product = vmProduct.product!;

    return Scaffold(
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,

      body: RefreshIndicator(
        onRefresh: () => vm.loadBodega(context),
        child: ListView(
          children: [
            Stack(
              children: [
                //TODO:Corregir carga
                const ProductImage(
                    url:
                        'https://okdiario.com/img/recetas/2016/12/29/desayunos-alrededor-del-mundo-2.jpg'),
                Positioned(
                  top: 60,
                  left: 20,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5)),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.desProducto,
                    style: AppTheme.style(
                      context,
                      Styles.title,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.productoId,
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'bodega',
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.blueText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  DropdownButton<BodegaProductoModel>(
                    isExpanded: true,
                    isDense: true,
                    dropdownColor: AppTheme.color(
                      context,
                      Styles.background,
                    ),
                    value: vm.bodega,
                    onChanged: (value) => vm.changeBodega(value, context),
                    items: vm.bodegas.map(
                      (bodega) {
                        return DropdownMenuItem<BodegaProductoModel>(
                          value: bodega,
                          child: Text(
                            "(${bodega.bodega}) ${bodega.nombre} | ${AppLocalizations.of(context)!.translate(
                              BlockTranslate.factura,
                              'existencia',
                            )} (${bodega.existencia.toStringAsFixed(2)})",
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(height: 20),
                  if (vm.unitarios.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.unitarios.first.precio
                              ? AppLocalizations.of(context)!.translate(
                                  BlockTranslate.factura,
                                  'tipoPrecio',
                                )
                              : AppLocalizations.of(context)!.translate(
                                  BlockTranslate.factura,
                                  'presentaciones',
                                ),
                          style: AppTheme.style(
                            context,
                            Styles.blueText,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const TipoPrecioSelect(),
                      ],
                    ),
                  if (vm.unitarios.isEmpty)
                    Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.notificacion,
                        'preciosNoEncontrados',
                      ),
                      style: AppTheme.style(
                        context,
                        Styles.normal,
                      ),
                    ),
                  const SizedBox(height: 5),
                  if (vm.unitarios.isNotEmpty && docVM.editPrice())
                    TextFormField(
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                          ),
                        ),
                        hintText: AppLocalizations.of(context)!.translate(
                          BlockTranslate.calcular,
                          'precioU',
                        ),
                        hintStyle: AppTheme.style(
                          context,
                          Styles.normal,
                        ),
                        labelText: AppLocalizations.of(context)!.translate(
                          BlockTranslate.calcular,
                          'precioU',
                        ),
                        labelStyle: AppTheme.style(
                          context,
                          Styles.normal,
                        ),
                      ),
                      controller: vm.controllerPrice,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^(\d+)?\.?\d{0,2}'),
                        ),
                      ],
                      keyboardType: TextInputType.number,
                      onChanged: (value) => vm.chanchePrice(value),
                    ),
                  if (vm.unitarios.isNotEmpty && !docVM.editPrice())
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.calcular,
                            'precioU',
                          ),
                          style: AppTheme.style(
                            context,
                            Styles.blueText,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  if (vm.unitarios.isNotEmpty && !docVM.editPrice())
                    Text(currencyFormat.format(vm.price)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.calcular,
                          'total',
                        )}: ${currencyFormat.format(vm.total)}",
                        style: AppTheme.style(
                          context,
                          Styles.title,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductImage extends StatelessWidget {
  const ProductImage({
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

class TipoPrecioSelect extends StatelessWidget {
  const TipoPrecioSelect({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetailsRestaurantViewModel>(context);

    return DropdownButton<UnitarioModel>(
      isExpanded: true,
      dropdownColor: AppTheme.color(
        context,
        Styles.background,
      ),
      value: vm.selectedPrice,
      onChanged: (value) => vm.changePrice(value),
      items: vm.unitarios.map(
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
