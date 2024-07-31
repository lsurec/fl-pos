import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/product_service.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/services.dart';
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

  final List<GarnishModel> garnishs = [];
  final List<GarnishTree> treeGarnish = [];

  Future<ApiResModel> loadGarnish(
    BuildContext context,
    int product,
    int um,
  ) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final String user = vmLogin.user;
    final String token = vmLogin.token;

    final RestaurantService restaurantService = RestaurantService();

    final ApiResModel apiResModel = await restaurantService.getGarnish(
      product,
      um,
      user,
      token,
    );

    return apiResModel;
  }

  orederTreeGarnish() {
    //nodo 1 (displays)
    List<GarnishTree> padres = [];
    //nodos sin ordenar (displays)
    List<GarnishTree> hijos = [];
    for (var garnish in garnishs) {
      final GarnishTree item = GarnishTree(
        idChild: garnish.productoCaracteristica,
        idFather: garnish.productoCaracteristicaPadre,
        children: [],
        item: garnish,
      );

      if (garnish.productoCaracteristicaPadre == null) {
        padres.add(item);
      } else {
        hijos.add(item);
      }
    }

    treeGarnish.clear();

    treeGarnish.addAll(ordenarNodos(padres, hijos));
  }

  // Función recursiva para ordenar nodos infinitos, recibe nodos principales y nodos a ordenar
  List<GarnishTree> ordenarNodos(
      List<GarnishTree> padres, List<GarnishTree> hijos) {
    // Recorrer los nodos principales
    for (var i = 0; i < padres.length; i++) {
      // Item padre de la iteración
      GarnishTree padre = padres[i];

      // Recorrer todos los hijos en orden inverso para evitar problemas al eliminar
      for (var j = hijos.length - 1; j >= 0; j--) {
        // Item hijo de la iteración
        GarnishTree hijo = hijos[j];

        // Si coinciden (padre > hijo), agregar ese hijo al padre
        if (padre.idChild == hijo.idFather) {
          padre.children.add(hijo); // Agregar hijo al padre
          // Eliminar al hijo que ya se usó para evitar repetirlo
          hijos.removeAt(j);
          // Llamar a la misma función (recursividad) se detiene cuando ya no hay hijos
          ordenarNodos(padre.children, hijos);
        }
      }
    }

    // Retornar nodos ordenados
    return padres;
  }

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
