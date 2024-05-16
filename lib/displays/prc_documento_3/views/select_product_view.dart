import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectProductView extends StatelessWidget {
  const SelectProductView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<ProductModel> products =
        ModalRoute.of(context)!.settings.arguments as List<ProductModel>;

    final vm = Provider.of<ProductViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'registro',
                      )} (${products.length})",
                      style: AppTheme.normalBoldStyle,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: products.length,
                  separatorBuilder: (context, index) =>
                      const Divider(), // Agregar el separador
                  itemBuilder: (context, index) {
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 0,
                        horizontal: 20,
                      ),
                      title: Text(
                        products[index].desProducto,
                        style: AppTheme.normalStyle,
                      ),
                      subtitle: Text(
                        'SKU: ${products[index].productoId} ',
                        style: AppTheme.normalStyle,
                      ),
                      onTap: () => vm.navigateProduct(
                        context,
                        products[index],
                      ),
                    );
                  },
                ),
              ),
            ],
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
