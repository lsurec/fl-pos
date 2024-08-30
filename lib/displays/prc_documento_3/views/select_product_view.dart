// ignore_for_file: deprecated_member_use
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectProductView extends StatelessWidget {
  const SelectProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmProducto = Provider.of<ProductViewModel>(context);
    final vmDetalle = Provider.of<DetailsViewModel>(context);

    return WillPopScope(
      onWillPop: () => vmProducto.back(),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "${AppLocalizations.of(context)!.translate(
                      BlockTranslate.general,
                      'registro',
                    )} (${vmDetalle.products.length})",
                    style: AppTheme.style(
                      context,
                      Styles.bold,
                    ),
                  ),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    // +1 para el botón "Ver más"
                    itemCount: vmDetalle.products.length + 1,
                    separatorBuilder: (context, index) => Divider(
                      color: AppTheme.color(
                        context,
                        Styles.border,
                      ),
                    ),
                    itemBuilder: (context, index) {
                      if (index < vmDetalle.products.length) {
                        final ProductModel producto = vmDetalle.products[index];
                        return ProductWidget(
                          producto: producto,
                        );
                      } else {
                        // Botón "Ver más" al final de la lista
                        // Llama a la función que carga más productos
                        return TextButton(
                          onPressed: () => vmProducto.filtrarResultados(
                            context,
                          ),
                          child: Text(
                            "Ver más",
                            style: AppTheme.style(context, Styles.normal),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          if (vmProducto.isLoading)
            ModalBarrier(
              dismissible: false,
              color: AppTheme.color(
                context,
                Styles.loading,
              ),
            ),
          if (vmProducto.isLoading) const LoadWidget(),
        ],
      ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  const ProductWidget({
    super.key,
    required this.producto,
  });

  final ProductModel producto;

  @override
  Widget build(BuildContext context) {
    final vmProducto = Provider.of<ProductViewModel>(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 0,
        horizontal: 20,
      ),
      title: Text(
        producto.desProducto,
        style: AppTheme.style(
          context,
          Styles.normal,
        ),
      ),
      subtitle: Text(
        'SKU: ${producto.productoId} ',
        style: AppTheme.style(
          context,
          Styles.normal,
        ),
      ),
      onTap: () => vmProducto.navigateProduct(
        context,
        producto,
      ),
      trailing: IconButton(
        onPressed: () => vmProducto.viewProductImages(
          context,
          producto,
        ),
        icon: const Icon(
          Icons.image,
        ),
      ),
    );
  }
}
