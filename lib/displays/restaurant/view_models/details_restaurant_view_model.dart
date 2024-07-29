import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/product_service.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/product_restaurant_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/views/views.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class DetailsRestaurantViewModel extends ChangeNotifier {
  final List<PrecioModel> prices = [];
  final List<TypePriceModel> types = [];

  final Map<String, dynamic> formValues = {
    'observacion': '',
  };

  //Increment number of products
  increment(int index) {
    types[index].cantidad++;
    notifyListeners();
  }

  //Decrement number of products
  decrement(int index) {
    if (types[index].cantidad <= 0) return;
    types[index].cantidad--;

    notifyListeners();
  }

  setTypePrices() {
    types.clear();

    for (var price in prices) {
      types.add(
        TypePriceModel(
          cantidad: 0,
          precio: price,
        ),
      );
    }
  }

  Future<ApiResModel> loadPrice(BuildContext context) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final vmProduct = Provider.of<ProductsClassViewModel>(
      context,
      listen: false,
    );

    final ProductRestaurantModel product = vmProduct.product!;
    final String user = vmLogin.user;
    final String token = vmLogin.token;

    ProductService productService = ProductService();

    final ApiResModel res = await productService.getPrecios(
      1, //TODO:Preguntar
      product.producto,
      product.unidadMedida,
      user,
      token, //TODO:Preguntar sobre lacuenta
      0, "0",
    );

    return res;
  }
}
