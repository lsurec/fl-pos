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
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailsRestaurantView extends StatelessWidget {
  const DetailsRestaurantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final homeVM = Provider.of<HomeViewModel>(
      context,
    );

    // Crear una instancia de NumberFormat para el formato de moneda
    final currencyFormat = NumberFormat.currency(
      symbol: homeVM
          .moneda, // Símbolo de la moneda (puedes cambiarlo según tu necesidad)
      decimalDigits: 2, // Número de decimales a mostrar
    );

    final vmProduct = Provider.of<ProductsClassViewModel>(
      context,
    );

    final docVM = Provider.of<DocumentViewModel>(context);
    final vm = Provider.of<DetailsRestaurantViewModel>(context);
    final ProductRestaurantModel product = vmProduct.product!;

    return Stack(
      children: [
        Scaffold(
          // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Color.fromARGB(255, 228, 225, 225),
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
                      style: AppTheme.style(
                        context,
                        Styles.title,
                      ),
                    ),
                    Text(
                      currencyFormat.format(vm.total),
                      style: AppTheme.style(
                        context,
                        Styles.title,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () => vm.decrementNum(),
                              icon: const Icon(Icons.remove),
                            ),
                            Text(
                              vm.controllerNum.text,
                              style: AppTheme.style(context, Styles.bold),
                            ),
                            IconButton(
                              onPressed: () => vm.incrementNum(),
                              icon: const Icon(Icons.add),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => vm.addProduct(context),
                          style: AppTheme.button(
                            context,
                            Styles.buttonStyle,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "Agregar", //TODO:Translate
                                style: AppTheme.style(
                                  context,
                                  Styles.whiteBoldStyle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),

          body: RefreshIndicator(
            onRefresh: () => vm.loadData(context),
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
                          Styles.bold,
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
                                Styles.bold,
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
                                Styles.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      if (vm.unitarios.isNotEmpty && !docVM.editPrice())
                        Text(currencyFormat.format(vm.price)),
                    ],
                  ),
                ),
                if (vm.treeGarnish.isNotEmpty)
                  Container(
                    color: const Color.fromARGB(255, 227, 226, 226),
                    height: 10,
                  ),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: vm.treeGarnish.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return Container(
                      color: const Color.fromARGB(255, 227, 226, 226),
                      height: 10,
                    );
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final GarnishTree garnishNode = vm.treeGarnish[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            garnishNode.item!.descripcion,
                            style: AppTheme.style(
                              context,
                              Styles.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Elige una opcion",
                            style: AppTheme.style(context, Styles.normal),
                          ),
                          const SizedBox(height: 5),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: garnishNode.children.length,
                            itemBuilder: (BuildContext context, int j) {
                              final GarnishModel garnish =
                                  garnishNode.children[j].item!;
                              return RadioListTile(
                                activeColor: AppTheme.primary,
                                contentPadding: EdgeInsets.zero,
                                title: Text(garnish.descripcion),
                                value: garnish,
                                groupValue: vm.treeGarnish[index].selected,
                                onChanged: (value) => vm.changeGarnish(
                                  index,
                                  value!,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                Container(
                  color: const Color.fromARGB(255, 227, 226, 226),
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Notas para este producto", //TODO:Translate
                        style: AppTheme.style(context, Styles.bold),
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                        maxLines: 2,
                        formProperty: vm.formValues["observacion"],
                        formValues: vm.formValues,
                        hintText:
                            "Escriba las instrucciones necesarias.", //TODO:Translate
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.color(
              context,
              Styles.loading,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
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
