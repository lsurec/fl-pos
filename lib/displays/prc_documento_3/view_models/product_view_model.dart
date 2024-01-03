// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductViewModel extends ChangeNotifier {
  //valores globales
  double total = 0; //total transaccion
  double price = 0; //Precio unitario seleccionado

  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //precios disponibles
  List<UnitarioModel> prices = [];
  //bodegas disponibles
  final List<BodegaProductoModel> bodegas = [];

  //Precio seleccioando
  UnitarioModel? selectedPrice;
  //bodega seleccionada
  BodegaProductoModel? selectedBodega;

  //controlador input cantidad, valor inicial = 0
  final TextEditingController controllerNum = TextEditingController(text: '1');
  final TextEditingController controllerPrice =
      TextEditingController(text: '0');

  //valor del input en numero
  int valueNum = 0;

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

  //cancelar
  void cancelButton(int back, BuildContext context) {
    Navigator.pop(context);
  }

  //navegar a pantalla producto
  void navigateProduct(
    BuildContext context,
    ProductModel product,
  ) async {
    //reiniciar valores
    total = 0;
    selectedPrice = null;
    controllerNum.text = "1";
    valueNum = 1;
    price = 0;
    controllerPrice.text = "$price";

    //inciiar proceso
    isLoading = true;

    //cargar podegas del producto seleccionado
    await loadBodegaProducto(
      context,
      product.producto,
      product.unidadMedida,
    );

    // si no hay bodegas mostrar mensaje
    if (bodegas.isEmpty) {
      isLoading = false;
      NotificationService.showSnackbar("No hay bodegas para este producto");
      return;
    }

    //si solo hay una bodega buscar precios
    if (bodegas.length == 1) {
      //consumir api

      ApiResModel precios = await loadPrecioUnitario(
        context,
        product.producto,
        product.unidadMedida,
        bodegas.first.bodega,
      );

      isLoading = false;

      if (!precios.succes) {
        ErrorModel error = precios.message;

        NotificationService.showErrorView(
          context,
          error,
        );
        return;
      }

      prices = precios.message;

      if (prices.isEmpty) {
        NotificationService.showSnackbar("No hay precios para este producto");
        return;
      }
    }

    //finalizar proceso
    isLoading = false;

    //navegar a pantalla pregunta
    Navigator.pushNamed(
      context,
      "product",
      arguments: [product, 2],
    );
  }

  Future<ApiResModel> loadPrecioUnitario(
    BuildContext context,
    int product,
    int um,
    int bodega,
  ) async {
    selectedPrice = null;

    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    String token = loginVM.token;
    String user = loginVM.nameUser;

    ProductService productService = ProductService();

    ApiResModel resPrecio = await productService.getPrecios(
      bodega,
      product,
      um,
      user,
      token,
    );

    if (!resPrecio.succes) {
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resPrecio.message,
        url: resPrecio.url,
        storeProcedure: resPrecio.storeProcedure,
      );

      return ApiResModel(
        succes: false,
        message: error,
        url: "",
        storeProcedure: null,
      );
    }

    final List<PrecioModel> precios = resPrecio.message;

    final List<UnitarioModel> unitarios = [];

    if (precios.isNotEmpty) {
      for (var precio in precios) {
        final UnitarioModel unitario = UnitarioModel(
          id: precio.tipoPrecio,
          precioU: precio.precioUnidad,
          descripcion: precio.desTipoPrecio,
          precio: true, //true Tipo precio; false Factor conversion
          moneda: precio.moneda,
        );

        unitarios.add(unitario);
      }

      if (unitarios.length == 1) {
        selectedPrice = unitarios.first;
        total = selectedPrice!.precioU;
        price = selectedPrice!.precioU;
        controllerPrice.text = "$price";
      }

      return ApiResModel(
        succes: true,
        message: unitarios,
        url: "",
        storeProcedure: null,
      );
    }

    ApiResModel resFactores = await productService.getFactorConversion(
      bodega,
      product,
      um,
      user,
      token,
    );

    if (!resFactores.succes) {
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resFactores.message,
        url: resFactores.url,
        storeProcedure: resFactores.storeProcedure,
      );

      return ApiResModel(
        succes: false,
        message: error,
        url: "",
        storeProcedure: null,
      );
    }

    final List<FactorConversionModel> factores = resFactores.message;

    for (var factor in factores) {
      final UnitarioModel unitario = UnitarioModel(
        id: factor.factorConversion,
        precioU: factor.precioUnidad,
        descripcion: factor.presentacion,
        precio: false, //true Tipo precio; false Factor conversion
        moneda: factor.moneda,
      );

      unitarios.add(unitario);
    }

    if (unitarios.length == 1) {
      selectedPrice = unitarios.first;
      total = selectedPrice!.precioU;
      price = selectedPrice!.precioU;
      controllerPrice.text = "$price";
    }

    return ApiResModel(
      succes: true,
      message: unitarios,
      url: "",
      storeProcedure: null,
    );
  }

  //bsucar bodega del producto
  Future<void> loadBodegaProducto(
    BuildContext context,
    int product,
    int um,
  ) async {
    //limpiar bodegas
    selectedBodega = null;
    bodegas.clear();

    //view model externo
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);

    //instancia del servicio
    ProductService productService = ProductService();

    //consumo del api
    ApiResModel res = await productService.getBodegaProducto(
      loginVM.nameUser, // user,
      localVM.selectedEmpresa!.empresa, // empresa,
      localVM.selectedEstacion!.estacionTrabajo, // estacion,
      product, // producto,
      um, // um,
      loginVM.token, // token,
    );

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        url: res.url,
        storeProcedure: res.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    //agreagar bodegas encontradas
    bodegas.addAll(res.message);

    //si solo hay una bodega seleccionarla por defecto
    if (bodegas.length == 1) {
      selectedBodega = bodegas.first;
    }
    notifyListeners();
  }

  //cambiar el texto dek input cantidad
  void changeTextNum(String value) {
    //asiganar valores
    int parsedValue = int.tryParse(value) ?? 0;
    valueNum = parsedValue;
    calculateTotal(); //calcuar total
  }

  void chanchePrice(String value) {
    double parsedValue = double.tryParse(value) ?? 0;

    selectedPrice!.precioU = parsedValue;
    calculateTotal();
  }

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

  //Seleccioanr tipo rpecio
  void changePrice(UnitarioModel? value) {
    selectedPrice = value;
    price = selectedPrice!.precioU;
    controllerPrice.text = "$price";
    calculateTotal(); //calcular total
  }

  //Seleccioanr bodega
  void changeBodega(
    BodegaProductoModel? value,
    BuildContext context,
    ProductModel product,
  ) async {
    //agregar bodega seleccionada
    selectedBodega = value;
    notifyListeners();

    //iniciar proceso
    isLoading = true;

    ApiResModel precios = await loadPrecioUnitario(
      context,
      product.producto,
      product.unidadMedida,
      value!.bodega,
    );

    isLoading = false;

    if (!precios.succes) {
      ErrorModel error = precios.message;

      NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    prices = precios.message;

    if (prices.isEmpty) {
      NotificationService.showSnackbar("No hay precios para este producto.");
    }
  }

  //agregar la transaccion a al documento
  void addTransaction(
    BuildContext context,
    ProductModel product,
    int back,
  ) {
    //vire model externo
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    final detailsVM = Provider.of<DetailsViewModel>(context, listen: false);

    //Si hay formas de pago mostrar mensaje
    if (paymentVM.amounts.isNotEmpty) {
      NotificationService.showSnackbar("Elimina primero las formas de pago.");
      return;
    }

    //si no hay bodega seleccionada
    if (selectedBodega == null) {
      NotificationService.showSnackbar("Selecciona una bodega");
      return;
    }

    // si no hay precios seleccionados
    if (prices.isNotEmpty && selectedPrice == null) {
      NotificationService.showSnackbar("Selecciona un tipo precio");
      return;
    }

    //si el monto es 0 o menor a 0 mostar menaje
    if ((int.tryParse(controllerNum.text) ?? 0) == 0) {
      NotificationService.showSnackbar("La cantidad debe ser mayor a 0");
      return;
    }

    if ((double.tryParse(controllerPrice.text) ?? 0) < price) {
      NotificationService.showSnackbar(
        "El precio no puede ser menor al precio autorizado. Comuniquese con el encargo de inventarios.",
      );
      return;
    }

    if (selectedBodega!.existencia == 0) {
      NotificationService.showSnackbar(
          "No es posible agregar la transaccion porque la existencia es insuficiente.");
      return;
    }

    if (detailsVM.document.isNotEmpty) {
      int monedaDoc = 0;
      int monedaTra = 0;

      TraInternaModel fistTra = detailsVM.document.first;

      monedaDoc = fistTra.precio!.moneda;

      monedaTra = selectedPrice!.moneda;

      if (monedaDoc != monedaTra) {
        NotificationService.showSnackbar(
            "No se puede agregar la transacción porque la moneda es distinta a las transacciones existentes.");
        return;
      }
    }

    //agregar transacion al documento
    detailsVM.addTransaction(
      TraInternaModel(
        isChecked: false,
        bodega: selectedBodega!,
        producto: product,
        precio: selectedPrice,
        cantidad: (int.tryParse(controllerNum.text) ?? 0),
        total: total,
        cargo: 0,
        descuento: 0,
        operaciones: [],
      ),
      context,
    );

    //mensaje de confirmacion
    NotificationService.showSnackbar("Transaccion agregada");

    //regresar a pantallas anteriroeres
    if (back == 2) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }
}
