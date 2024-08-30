// ignore_for_file: deprecated_member_use
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
            appBar: AppBar(),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Row(
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
                Expanded(
                  child: ListView.separated(
                    itemCount: vmDetalle.products.length,
                    separatorBuilder: (context, index) => Divider(
                      color: AppTheme.color(
                        context,
                        Styles.border,
                      ),
                    ), // Agregar el separador
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 20,
                        ),
                        title: Text(
                          vmDetalle.products[index].desProducto,
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                          ),
                        ),
                        subtitle: Text(
                          'SKU: ${vmDetalle.products[index].productoId} ',
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                          ),
                        ),
                        onTap: () => vmProducto.navigateProduct(
                          context,
                          vmDetalle.products[index],
                        ),
                        trailing: IconButton(
                          onPressed: () => vmProducto.viewProductImages(
                            context,
                            vmDetalle.products[index],
                          ),
                          icon: const Icon(
                            Icons.image,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          if (vmProducto.isLoading)
            ModalBarrier(
              dismissible: false,
              // color: Colors.black.withOpacity(0.3),
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
