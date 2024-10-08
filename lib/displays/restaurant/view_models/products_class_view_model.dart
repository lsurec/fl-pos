// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/product_restaurant_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/services.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class ProductsClassViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<ProductRestaurantModel> products = [];
  final List<List<ProductRestaurantModel>> menu = [];
  int totalLength = 0;
  ProductRestaurantModel? product;

  Future<void> navigateDetails(
    BuildContext context,
    ProductRestaurantModel pProduct,
  ) async {
    isLoading = true;

    product = pProduct;

    final vDetailsRestaurant =
        Provider.of<DetailsRestaurantViewModel>(context, listen: false);

    final ApiResModel resGarnish = await vDetailsRestaurant.loadGarnish(
      context,
      product!.producto,
      product!.unidadMedida,
    );

    if (!resGarnish.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resGarnish);
      return;
    }

    if (vDetailsRestaurant.garnishs.isNotEmpty) {
      vDetailsRestaurant.orederTreeGarnish();
    }

    final vmDetails = Provider.of<DetailsRestaurantViewModel>(
      context,
      listen: false,
    );

    final ApiResModel resBodega = await vmDetails.loadBodega(context);

    if (!resBodega.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resBodega);
      return;
    }

    //si no se encontrarin bodegas mostrar mensaje
    if (vmDetails.bodegas.isEmpty) {
      isLoading = false;
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinBodegaP',
        ),
      );

      return;
    }

    if (vmDetails.bodegas.length == 1) {
      vmDetails.bodega = vmDetails.bodegas.first;

      //cargar precios

      final ApiResModel resPrices = await vmDetails.loadPrecioUnitario(context);

      if (!resPrices.succes) {
        isLoading = false;
        NotificationService.showErrorView(context, resPrices);
        return;
      }
    }

    vmDetails.valueNum = 1;
    vmDetails.controllerNum.text = "1";

    final Map<String, dynamic> options = {
      'modify': false,
      'indexOrder': 0,
      'indexTra': 0,
    };

    Navigator.pushNamed(
      context,
      AppRoutes.detailsRestaurant,
      arguments: options,
    );

    isLoading = false;
  }

  Future<void> loadData(BuildContext context) async {
    isLoading = true;

    final ApiResModel resClassProduct = await loadProducts(context);

    isLoading = false;

    if (!resClassProduct.succes) {
      NotificationService.showErrorView(context, resClassProduct);
    }
  }

  orderMenu() {
    double rowsNum = 0; //Saber cuantas filas tengo

    //Dividir en 2 los items totales  pata obtener cuntas filas tengo
    if ((products.length / 2) % 1 == 0) {
      //Es entero
      rowsNum = products.length / 2; //Esa cantidad de filas
    } else {
      //es decimal
      rowsNum = ((products.length - 1) / 2) + 1; //sacar el entero y sumarle 1
    }

    menu.clear();
    //agreagr el numero de filas vacias
    for (var i = 0; i < rowsNum; i++) {
      menu.add([]);
    }

    //lenar las finlas
    //recorrer el numero de filas
    for (var i = 0; i < menu.length; i++) {
      //si de las lista inicial todavia hay algo
      if (products.isNotEmpty) {
        //si de la lista inicial ya solo hay uno
        if (products.length < 2) {
          //agrego ese item
          menu[i].add(products[0]);
          products.removeAt(0);
        } else {
          //si son mas de 2
          //Ibgreso los 2 primmeros
          menu[i].add(products[0]);
          menu[i].add(products[1]);
          //Eliminar los items que se igresaron a la fila
          products.removeAt(0);
          products.removeAt(0);
        }
      }
    }

    totalLength = 0;
    for (var sublist in menu) {
      totalLength += sublist.length;
    }
  }

  Future<ApiResModel> loadProducts(BuildContext context) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );
    final vmLocal = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );
    final vmClass = Provider.of<ClassificationViewModel>(
      context,
      listen: false,
    );

    final int estacion = vmLocal.selectedEstacion!.estacionTrabajo;
    final String user = vmLogin.user;
    final String token = vmLogin.token;

    final RestaurantService restaurantService = RestaurantService();

    final res = await restaurantService.getProducts(
      vmClass.classification!.clasificacion,
      estacion,
      user,
      token,
    );

    if (!res.succes) return res;

    product = null;
    products.clear();
    products.addAll(res.response);
    orderMenu();

    return res;
  }
}
