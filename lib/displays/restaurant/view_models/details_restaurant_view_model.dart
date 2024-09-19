// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/product_service.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/services.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
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

  final Map<String, dynamic> formValues = {'observacion': ''};

  final List<GarnishModel> garnishs = [];
  final List<GarnishTree> treeGarnish = [];

  final List<BodegaProductoModel> bodegas = [];
  BodegaProductoModel? bodega;

  Future<void> addProduct(
      BuildContext context, Map<String, dynamic> options) async {
    //si no hay bodega seleccionada
    if (bodega == null) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'seleccionaBodega',
        ),
      );
      return;
    }

    // si no hay precios seleccionados
    if (prices.isNotEmpty && selectedPrice == null) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'seleccionaTipoPrecio',
        ),
      );
      return;
    }

    //si el monto es 0 o menor a 0 mostar menaje
    if ((int.tryParse(controllerNum.text) ?? 0) == 0) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'cantidadMayorCero',
        ),
      );
      return;
    }

    if ((double.tryParse(controllerPrice.text) ?? 0) < price) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'precioNoMenorAutorizado',
        ),
      );
      return;
    }

    //TODO:Preguntar si se validan existencias con validar1
    // final vmProductRestaurant = Provider.of<ProductsClassViewModel>(
    //   context,
    //   listen: false,
    // );

    // ProductRestaurantModel product = vmProductRestaurant.product!;

    // //Validacion de producto

    // TipoTransaccionModel tipoTra =
    //     getTipoTransaccion(product.tipoProducto, context);

    // if (tipoTra.altCantidad) {
    //   //iniciar proceso

    //   ProductService productService = ProductService();

    //   //consumo del api
    //   ApiResModel res = await productService.getValidateProducts(
    //     user,
    //     serieDocumento,
    //     tipoDocumento,
    //     estacion,
    //     empresa,
    //     selectedBodega!.bodega,
    //     tipoTra.tipoTransaccion,
    //     product.unidadMedida,
    //     product.producto,
    //     (int.tryParse(controllerNum.text) ?? 0),
    //     8, //TODO:Parametrizar
    //     selectedPrice!.moneda,
    //     selectedPrice!.id,
    //     token,
    //   );

    //   //valid succes response
    //   if (!res.succes) {
    //     //si algo salio mal mostrar alerta

    //     await NotificationService.showErrorView(
    //       context,
    //       res,
    //     );
    //     return;
    //   }

    //   //agreagar bodegas encontradas

    //   final List<String> mensajes = res.response;

    //   if (mensajes.isNotEmpty) {
    //     NotificationService.showSnackbar(mensajes[0]);
    //     return;
    //   }
    // }

    //TODO:Buscar orden correspondinete
    final vmOrders = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

//     if (vmOrders.orders.isNotEmpty) {
//       int monedaDoc = 0;
//       int monedaTra = 0;

// //TODO:Buscar
//       TraInternaModel fistTra = detailsVM.traInternas.first;

//       monedaDoc = fistTra.precio!.moneda;

//       monedaTra = selectedPrice!.moneda;

//       if (monedaDoc != monedaTra) {
//         NotificationService.showSnackbar(
//           AppLocalizations.of(context)!.translate(
//             BlockTranslate.notificacion,
//             'monedaDistinta',
//           ),
//         );
//         return;
//       }
//     }

    //Validar guarniciones
    for (var i = 0; i < treeGarnish.length; i++) {
      final GarnishTree node = treeGarnish[i];

      if (node.children.isNotEmpty) {
        if (node.selected == null) {
          NotificationService.showSnackbar(
            "${AppLocalizations.of(context)!.translate(
              BlockTranslate.factura,
              'opcion',
            )} (${node.item?.descripcion})",
          );
          return;
        }
      }
    }

    final pinVM = Provider.of<PinViewModel>(context, listen: false);
    final locationVM = Provider.of<LocationsViewModel>(context, listen: false);
    final tableVM = Provider.of<TablesViewModel>(context, listen: false);
    final productRestaurantVM =
        Provider.of<ProductsClassViewModel>(context, listen: false);

    final List<GarnishTra> selectGarnishs = [];

    for (var element in treeGarnish) {
      final List<GarnishModel> routes = [];

      for (var item in element.route) {
        routes.add(item.item!);
      }

      selectGarnishs.add(
        GarnishTra(
          garnishs: routes,
          selected: element.selected!,
        ),
      );
    }

    TraRestaurantModel transaction = TraRestaurantModel(
      cantidad: int.tryParse(controllerNum.text) ?? 0,
      precio: selectedPrice!,
      producto: productRestaurantVM.product!,
      observacion: formValues["observacion"],
      guarniciones: selectGarnishs,
      selected: false,
      bodega: bodega!,
      processed: false,
    );

    if (options["modify"]) {
      vmOrders.modifyTra(context, options["indexOrder"], options["indexTra"]);

      formValues["observacion"] = "";

      Navigator.pop(context);
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'productoModificado',
        ),
      );

      return;
    }

    if (tableVM.table!.orders!.isEmpty) {
      vmOrders.addFirst(
        context,
        OrderModel(
          consecutivoRef: 0,
          consecutivo: 0,
          selected: false,
          mesero: pinVM.waitress!,
          nombre: "Cuenta 1", //TODO: Rebombrar
          ubicacion: locationVM.location!,
          mesa: tableVM.table!,
          transacciones: [transaction],
        ),
      );

      formValues["observacion"] = "";

      Navigator.pop(context);
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'productoAgregado',
        ),
      );

      return;
    }

    if (tableVM.table!.orders!.length == 1) {
      vmOrders.addTransactionFirst(transaction, tableVM.table!.orders!.first);

      formValues["observacion"] = "";

      Navigator.pop(context);
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'productoAgregado',
        ),
      );

      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.selectAccount,
      arguments: {
        "screen": 1,
        "transaction": transaction,
        "action": 0,
      },
    );

    formValues["observacion"] = "";
  }

  //devuelve el tipo de transaccion que se va a usar
  TipoTransaccionModel getTipoTransaccion(
    int tipo,
    BuildContext context,
  ) {
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

    for (var i = 0; i < docVM.tiposTransaccion.length; i++) {
      final TipoTransaccionModel tipoTra = docVM.tiposTransaccion[i];

      if (tipo == tipoTra.tipo) {
        return tipoTra;
      }
    }

    //si no encunetra el tipo
    return TipoTransaccionModel(
      tipoTransaccion: 0,
      descripcion: "descripcion",
      tipo: tipo,
      altCantidad: true,
    );
  }

  Future<void> loadData(BuildContext context) async {
    isLoading = true;

    final vmProductRestaurant = Provider.of<ProductsClassViewModel>(
      context,
      listen: false,
    );

    ProductRestaurantModel product = vmProductRestaurant.product!;

    final ApiResModel resGarnish = await loadGarnish(
      context,
      product.producto,
      product.unidadMedida,
    );

    if (!resGarnish.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resGarnish);
      return;
    }

    if (garnishs.isNotEmpty) orederTreeGarnish();

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

    isLoading = false;
  }

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

    final ApiResModel res = await restaurantService.getGarnish(
      product,
      um,
      user,
      token,
    );

    if (!res.succes) return res;

    treeGarnish.clear();
    garnishs.clear();
    garnishs.addAll(res.response);

    return res;
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

  //Cambiar rutas (Agragar)
  void changeRoute(
    int indexTree,
    int indexRoute,
  ) {
    treeGarnish[indexTree].route.removeRange(
          indexRoute + 1,
          treeGarnish[indexTree].route.length,
        );

    treeGarnish[indexTree].selected = null;

    notifyListeners();
  }

  changeGarnishActive(
    int index,
    GarnishTree node,
  ) {
    if (node.children.isNotEmpty) {
      treeGarnish[index].route.add(node);

      notifyListeners();
      return;
    }

    treeGarnish[index].selected = node.item;
    notifyListeners();
  }

  loadFirstharnish() {
    for (var element in treeGarnish) {
      element.route.add(element);
    }
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
        selected: null,
        route: [],
      );

      if (garnish.productoCaracteristicaPadre == null) {
        padres.add(item);
      } else {
        hijos.add(item);
      }
    }

    treeGarnish.clear();

    treeGarnish.addAll(ordenarNodos(padres, hijos));

    loadFirstharnish();
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

    if (!res.succes) return res;

    bodegas.clear();
    bodegas.addAll(res.response);

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
