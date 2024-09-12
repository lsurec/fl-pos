import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
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

    final homeVM = Provider.of<HomeViewModel>(context);
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

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
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => vm.viewProductImages(
                          context,
                          product,
                        ),
                        icon: const Icon(
                          Icons.image,
                        ),
                      ),
                      Text(
                        "SKU: ${product.productoId}",
                        style: StyleApp.title,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _NumericField(),
                  Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.general,
                      'descripcion',
                    ),
                    style: StyleApp.blueText,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    product.desProducto,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.factura,
                      'bodega',
                    ),
                    style: StyleApp.blueText,
                  ),
                  const SizedBox(height: 5),
                  DropdownButton<BodegaProductoModel>(
                    isExpanded: true,
                    isDense: true,
                    dropdownColor: AppTheme.color(
                      context,
                      Styles.background,
                    ),
                    value: vm.selectedBodega,
                    onChanged: (value) =>
                        vm.changeBodega(value, context, product),
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
                  if (vm.prices.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          vm.prices.first.precio
                              ? AppLocalizations.of(context)!.translate(
                                  BlockTranslate.factura,
                                  'tipoPrecio',
                                )
                              : AppLocalizations.of(context)!.translate(
                                  BlockTranslate.factura,
                                  'presentaciones',
                                ),
                          style: StyleApp.blueText,
                        ),
                        const SizedBox(height: 5),
                        const TipoPrecioSelect(),
                      ],
                    ),
                  if (vm.prices.isEmpty)
                    Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.notificacion,
                        'preciosNoEncontrados',
                      ),
                      style: StyleApp.normal,
                    ),
                  const SizedBox(height: 5),
                  if (vm.prices.isNotEmpty && docVM.editPrice())
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
                        hintStyle: StyleApp.normal,
                        labelText: AppLocalizations.of(context)!.translate(
                          BlockTranslate.calcular,
                          'precioU',
                        ),
                        labelStyle: StyleApp.normal,
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
                  if (vm.prices.isNotEmpty && !docVM.editPrice())
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.calcular,
                            'precioU',
                          ),
                          style: StyleApp.blueText,
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  if (vm.prices.isNotEmpty && !docVM.editPrice())
                    Text(
                      currencyFormat.format(vm.price),
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.calcular,
                          'total',
                        )}: ${currencyFormat.format(vm.total)}",
                        style: StyleApp.title,
                      ),
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
            color: AppNewTheme.isDark()
                ? AppNewTheme.darkBackroundColor
                : AppNewTheme.backroundColor,
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
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.notificacion,
                    'presioneCancelar',
                  ),
                );
              },
              onDoubleTap: () => vm.cancelButton(back, context),
              child: Container(
                margin: const EdgeInsets.all(10),
                color: AppTheme.color(
                  context,
                  Styles.primary,
                ),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'cancelar',
                    ),
                    style: StyleApp.whiteNormal,
                  ),
                ),
              ),
            ),
          ),
          //agregar transaccion
          if (vm.accion == 0)
            Expanded(
              child: GestureDetector(
                onTap: () => vm.addTransaction(
                  context,
                  product,
                  back,
                  0,
                ),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  color: AppTheme.color(
                    context,
                    Styles.primary,
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'agregar',
                      ),
                      style: StyleApp.whiteNormal,
                    ),
                  ),
                ),
              ),
            ),
          //modificar transaccion
          if (vm.accion == 1)
            Expanded(
              child: GestureDetector(
                onTap: () => vm.addTransaction(
                  context,
                  product,
                  back,
                  1,
                ),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  color: AppTheme.color(
                    context,
                    Styles.primary,
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'modificar',
                      ),
                      style: StyleApp.whiteNormal,
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
      dropdownColor: AppTheme.color(
        context,
        Styles.background,
      ),
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
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                ),
              ),
              hintText: AppLocalizations.of(context)!.translate(
                BlockTranslate.factura,
                'cantidad',
              ),
              hintStyle: StyleApp.normal,
              labelText: AppLocalizations.of(context)!.translate(
                BlockTranslate.factura,
                'cantidad',
              ),
              labelStyle: StyleApp.normal,
            ),
            controller: vm.controllerNum,
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'^(\d+)?\.?\d{0,2}'),
              ),
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

class ImageCarouselDialog extends StatelessWidget {
  final List<String> imageUrls;

  const ImageCarouselDialog({
    super.key,
    required this.imageUrls,
  });

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController(initialPage: 0);

    return Dialog(
      child: SizedBox(
        height: 350,
        child: PageView.builder(
          controller: pageController,
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Image.network(
                      imageUrls[index],
                      height: 300,
                    ),
                    Positioned(
                      bottom: 5,
                      left: 0, // Establece el margen izquierdo
                      right: 0, // Establece el margen derecho
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          color: AppTheme.color(
                            context,
                            Styles.grey,
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Text(
                            "${index + 1}/${imageUrls.length}",
                            style: StyleApp.normal,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
