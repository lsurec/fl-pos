import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/views/views.dart';
import 'package:flutter_post_printer_example/displays/restaurant/widgets/widgets.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/product_restaurant_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductClassView extends StatelessWidget {
  const ProductClassView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmLoc = Provider.of<LocationsViewModel>(context);
    final vmTables = Provider.of<TablesViewModel>(context);
    final vmClass = Provider.of<ClassificationViewModel>(context);
    final vm = Provider.of<ProductsClassViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          bottomNavigationBar: vmTables.table!.orders!.isEmpty
              ? null
              : const ButtonDetailsWidget(),
          appBar: AppBar(
            title: Text(
              vmClass.classification!.desClasificacion,
              style: StyleApp.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => vmLoc.backLocationsView(context),
                              child: Text(
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.restaurante,
                                  'ubicaciones',
                                ),
                                style: StyleApp.normal,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => vmTables.backTablesView(context),
                              child: Text(
                                "${vmLoc.location!.descripcion}/",
                                style: StyleApp.normal,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                "${vmTables.table!.descripcion}/",
                                style: StyleApp.normal,
                              ),
                            ),
                            Text(
                              vmClass.classification!.desClasificacion,
                              style: StyleApp.normalBold,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      RegisterCountWidget(count: vm.totalLength),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => vm.loadData(context),
                    child: ListView.builder(
                      itemCount: vm.menu.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _RowMenu(
                          products: vm.menu[index],
                        );
                      },
                    ),
                  ),
                ),
              ],
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
    );
  }
}

class _RowMenu extends StatelessWidget {
  const _RowMenu({
    Key? key,
    required this.products,
  }) : super(key: key);

  final List<ProductRestaurantModel> products;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductsClassViewModel>(context, listen: false);

    return Row(
      children: [
        CardImageWidget(
          onTap: () => vm.navigateDetails(context, products[0]),
          description: products[0].desProducto,
          srcImage:
              "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png",
          // srcImage: options[0].image,
        ),
        if (products.length == 2)
          CardImageWidget(
            onTap: () => vm.navigateDetails(context, products[1]),
            description: products[1].desProducto,
            srcImage:
                "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png",
            // srcImage: options[1].image,
          ),
        if (products.length == 1) Expanded(child: Container()),
      ],
    );
  }
}
