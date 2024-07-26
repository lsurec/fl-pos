// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
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
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinBodegaP',
        ),
      );
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
        NotificationService.showErrorView(
          context,
          precios,
        );
        return;
      }

      prices = precios.response;

      if (prices.isEmpty) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'sinPrecioP',
          ),
        );
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
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);

    String token = loginVM.token;
    String user = loginVM.user;

    ProductService productService = ProductService();

    ApiResModel resPrecio = await productService.getPrecios(
      bodega,
      product,
      um,
      user,
      token,
      docVM.clienteSelect?.cuentaCorrentista ?? 0,
      docVM.clienteSelect?.cuentaCta ?? "0",
    );

    if (!resPrecio.succes) {
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resPrecio.response,
        url: resPrecio.url,
        storeProcedure: resPrecio.storeProcedure,
      );

      return ApiResModel(
        succes: false,
        response: error,
        url: "",
        storeProcedure: null,
      );
    }

    final List<PrecioModel> precios = resPrecio.response;

    final List<UnitarioModel> unitarios = [];

    if (precios.isNotEmpty) {
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

      return ApiResModel(
        succes: true,
        response: unitarios,
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
        description: resFactores.response,
        url: resFactores.url,
        storeProcedure: resFactores.storeProcedure,
      );

      return ApiResModel(
        succes: false,
        response: error,
        url: "",
        storeProcedure: null,
      );
    }

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

    return ApiResModel(
      succes: true,
      response: unitarios,
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
      loginVM.user, // user,
      localVM.selectedEmpresa!.empresa, // empresa,
      localVM.selectedEstacion!.estacionTrabajo, // estacion,
      product, // producto,
      um, // um,
      loginVM.token, // token,
    );

    //valid succes response
    if (!res.succes) {
      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    //agreagar bodegas encontradas
    bodegas.addAll(res.response);

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
      NotificationService.showErrorView(
        context,
        precios,
      );
      return;
    }

    prices = precios.response;

    if (prices.isEmpty) {
      calculateTotal();
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinPrecioP',
        ),
      );
    }
  }

  //agregar la transaccion a al documento
  Future<void> addTransaction(
    BuildContext context,
    ProductModel product,
    int back,
  ) async {
    //vire model externo
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    final detailsVM = Provider.of<DetailsViewModel>(context, listen: false);
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);
    final menuVM = Provider.of<MenuViewModel>(context, listen: false);

    String serieDocumento = docVM.serieSelect!.serieDocumento!;
    int tipoDocumento = menuVM.documento!;
    final String user = loginVM.user;
    final String token = loginVM.token;
    int estacion = localVM.selectedEstacion!.estacionTrabajo;
    int empresa = localVM.selectedEmpresa!.empresa;

    //Si hay formas de pago mostrar mensaje
    if (paymentVM.amounts.isNotEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'eliminaFormaPago',
        ),
      );
      return;
    }

    //si no hay bodega seleccionada
    if (selectedBodega == null) {
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

    // if (selectedBodega!.existencia == 0) {
    //   NotificationService.showSnackbar(
    //     AppLocalizations.of(context)!.translate(
    //       BlockTranslate.notificacion,
    //       'existenciaInsuficiente',
    //     ),
    //   );
    //   return;
    // }

    //TODO:Validacion de producto

    TipoTransaccionModel tipoTra =
        getTipoTransaccion(product.tipoProducto, context);
    ProductService productService = ProductService();

    if (tipoTra.altCantidad) {
      //iniciar proceso

      //consumo del api
      ApiResModel res = await productService.getValidateProducts(
        user,
        serieDocumento,
        tipoDocumento,
        estacion,
        empresa,
        selectedBodega!.bodega,
        tipoTra.tipoTransaccion,
        product.unidadMedida,
        product.producto,
        (int.tryParse(controllerNum.text) ?? 0),
        8, //TODO:Parametrizar
        selectedPrice!.moneda,
        selectedPrice!.id,
        token,
      );

      //valid succes response
      if (!res.succes) {
        //si algo salio mal mostrar alerta

        await NotificationService.showErrorView(
          context,
          res,
        );
        return;
      }

      //agreagar bodegas encontradas

      final List<String> mensajes = res.response;

      if (mensajes.isNotEmpty) {
        NotificationService.showSnackbar(mensajes[0]);
        return;
      }
    }

    if (detailsVM.traInternas.isNotEmpty) {
      int monedaDoc = 0;
      int monedaTra = 0;

      TraInternaModel fistTra = detailsVM.traInternas.first;

      monedaDoc = fistTra.precio!.moneda;

      monedaTra = selectedPrice!.moneda;

      if (monedaDoc != monedaTra) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'monedaDistinta',
          ),
        );
        return;
      }
    }

    //calcular precio por dias

    double precioDias = 0;
    int cantidadDias = 0;

    if (docVM.valueParametro(44)) {
      if (Utilities.fechaIgualOMayorSinSegundos(
          docVM.fechaFinal, docVM.fechaInicial)) {
        //formular precios por dias
        ApiResModel resFormPrecio = await productService.getFormulaPrecioU(
          token,
          user,
          docVM.fechaInicial,
          docVM.fechaFinal,
          total.toString(),
        );

        //valid succes response
        if (!resFormPrecio.succes) {
          //si algo salio mal mostrar alerta

          await NotificationService.showErrorView(
            context,
            resFormPrecio,
          );
          return;
        }

        List<PrecioDiaModel> preciosDia = resFormPrecio.response;

        if (preciosDia.isEmpty) {
          isLoading = false;
          resFormPrecio.response =
              'No fue posible obtner los valores calculados para el precio dia';

          NotificationService.showErrorView(context, resFormPrecio);

          return;
        }

        precioDias = preciosDia[0].montoCalculado;
        cantidadDias = preciosDia[0].cantidadDia;
      } else {
        isLoading = false;
        precioDias = total;
        cantidadDias = 1;

        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'precioDiasNoCalculado',
          ),
        );
      }
    }

//aqui termina lo que agregue..

    //agregar transacion al documento
    detailsVM.addTransaction(
      TraInternaModel(
        consecutivo: 0,
        estadoTra: 1,
        isChecked: false,
        bodega: selectedBodega!,
        producto: product,
        precio: selectedPrice,
        cantidad: (int.tryParse(controllerNum.text) ?? 0),
        total: total,
        cargo: 0,
        descuento: 0,
        operaciones: [],
        precioCantidad: docVM.valueParametro(44) ? total : null,
        cantidadDias: docVM.valueParametro(44) ? cantidadDias : 0,
        precioDia: docVM.valueParametro(44) ? precioDias : null,
      ),
      context,
    );

    //mensaje de confirmacion
    NotificationService.showSnackbar(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'transaccionAgregada',
      ),
    );

    //regresar a pantallas anteriroeres
    if (back == 2) {
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
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
}
