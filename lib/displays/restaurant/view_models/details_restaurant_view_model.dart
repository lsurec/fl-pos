// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/product_service.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/services.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/views/views.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class DetailsRestaurantViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //valores globales
  double total = 0; //total transaccion
  double price = 0; //Precio unitario seleccionado
  //controlador input cantidad, valor inicial = 0
  final TextEditingController controllerNum = TextEditingController(text: '1');
  final TextEditingController controllerPrice =
      TextEditingController(text: '0');

  final List<PrecioModel> prices = [];
  final List<UnitarioModel> unitarios = [];
  UnitarioModel? selectedPrice;

  final Map<String, dynamic> formValues = {
    'observacion': '',
  };

  final List<GarnishModel> garnishs = [];
  final List<GarnishTree> treeGarnish = [];

  final List<BodegaProductoModel> bodegas = [];
  BodegaProductoModel? bodega;

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

  //valor del input en numero
  int valueNum = 0;
  //incrementrar cantidad
  void incrementNum() {
    valueNum++;
    controllerNum.text = valueNum.toString();
    calculateTotal();
  }

  //disminuir cantidad del input
  void decrementNum() {
    //La cantidad no puede ser menor a 0
    if (valueNum > 0) {
      valueNum--;
      controllerNum.text = valueNum.toString();
      calculateTotal(); //Calcualr total
    }
  }

  changeGarnish(
    int index,
    GarnishModel garnish,
  ) {
    treeGarnish[index].selected = garnish;
    notifyListeners();
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
          selected: null);

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

  Future<ApiResModel> loadBodega(BuildContext context) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final vmProduct = Provider.of<ProductsClassViewModel>(
      context,
      listen: false,
    );

    final vmLocal = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    final int empresa = vmLocal.selectedEmpresa!.empresa;
    final int estacion = vmLocal.selectedEstacion!.estacionTrabajo;
    final String user = vmLogin.user;
    final String token = vmLogin.token;
    final ProductRestaurantModel product = vmProduct.product!;

    final ProductService productService = ProductService();

    final ApiResModel res = await productService.getBodegaProducto(
      user,
      empresa,
      estacion,
      product.producto,
      product.unidadMedida,
      token,
    );

    return res;
  }

  Future<ApiResModel> loadPrecioUnitario(
    BuildContext context,
  ) async {
    selectedPrice = null;

    final loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final productRestaurantVM = Provider.of<ProductsClassViewModel>(
      context,
      listen: false,
    );

    final docVM = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

    final ProductRestaurantModel product = productRestaurantVM.product!;
    String token = loginVM.token;
    String user = loginVM.user;

    ProductService productService = ProductService();

    ApiResModel resPrices = await productService.getPrecios(
      bodega!.bodega,
      product.producto,
      product.unidadMedida,
      user,
      token,
      docVM.clienteSelect?.cuentaCorrentista ?? 0,
      docVM.clienteSelect?.cuentaCta ?? "0",
    );

    if (!resPrices.succes) return resPrices;

    final List<PrecioModel> precios = resPrices.response;

    selectedPrice = null;
    unitarios.clear();

    for (var precio in precios) {
      final UnitarioModel unitario = UnitarioModel(
        id: precio.tipoPrecio,
        precioU: precio.precioUnidad,
        descripcion: precio.desTipoPrecio,
        precio: true, //true Tipo precio; false Factor conversion
        moneda: precio.moneda,
        orden: precio.tipoPrecioOrden,
      );

      unitarios.add(unitario);
    }

    if (unitarios.length == 1) {
      selectedPrice = unitarios.first;
      total = selectedPrice!.precioU;
      price = selectedPrice!.precioU;
      controllerPrice.text = "$price";
    } else if (unitarios.length > 1) {
      for (var i = 0; i < unitarios.length; i++) {
        final UnitarioModel unit = unitarios[i];

        if (unit.orden != null) {
          selectedPrice = unit;
          total = unit.precioU;
          price = unit.precioU;
          controllerPrice.text = unit.precioU.toString();
          break;
        }
      }
    }

    if (unitarios.isNotEmpty) return resPrices;

    ApiResModel resFactores = await productService.getFactorConversion(
      bodega!.bodega,
      product.producto,
      product.unidadMedida,
      user,
      token,
    );

    if (!resFactores.succes) return resFactores;

    final List<FactorConversionModel> factores = resFactores.response;

    for (var factor in factores) {
      final UnitarioModel unitario = UnitarioModel(
        id: factor.factorConversion,
        precioU: factor.precioUnidad,
        descripcion: factor.presentacion,
        precio: false, //true Tipo precio; false Factor conversion
        moneda: factor.moneda,
        orden: factor.tipoPrecioOrden,
      );

      unitarios.add(unitario);
    }

    if (unitarios.length == 1) {
      selectedPrice = unitarios.first;
      total = selectedPrice!.precioU;
      price = selectedPrice!.precioU;
      controllerPrice.text = "$price";
    } else if (unitarios.length > 1) {
      for (var i = 0; i < unitarios.length; i++) {
        final UnitarioModel unit = unitarios[i];

        if (unit.orden != null) {
          selectedPrice = unit;
          total = unit.precioU;
          price = unit.precioU;
          controllerPrice.text = unit.precioU.toString();
          break;
        }
      }
    }

    return resFactores;
  }

  //Seleccioanr bodega
  void changeBodega(
    BodegaProductoModel? value,
    BuildContext context,
  ) async {
    //agregar bodega seleccionada
    bodega = value;

    //iniciar proceso
    isLoading = true;

    ApiResModel precios = await loadPrecioUnitario(context);

    isLoading = false;

    if (!precios.succes) {
      NotificationService.showErrorView(
        context,
        precios,
      );
      return;
    }

    if (unitarios.isEmpty) {
      calculateTotal();
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinPrecioP',
        ),
      );
    }
  }

  //calcular total transaccion
  void calculateTotal() {
    //si no hay cantidad seleccioanda
    if (selectedPrice == null) {
      total = 0;
      notifyListeners();
      return;
    }

    //str to int
    int parsedValue = int.tryParse(controllerNum.text) ?? 0;

    //calcular total
    total = parsedValue * selectedPrice!.precioU;

    notifyListeners();
  }

  void chanchePrice(String value) {
    double parsedValue = double.tryParse(value) ?? 0;

    selectedPrice!.precioU = parsedValue;
    calculateTotal();
  }

  //Seleccioanr tipo rpecio
  void changePrice(UnitarioModel? value) {
    selectedPrice = value;
    price = selectedPrice!.precioU;
    controllerPrice.text = "$price";
    calculateTotal(); //calcular total
  }
}
