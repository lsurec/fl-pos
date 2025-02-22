// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/views/product_view.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
// import 'package:flutter_post_printer_example/routes/app_routes.dart';
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

  int indexEdit = -1;

  int accion = 0; // Agregar = 0; Editar = 1;

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
    // total = parsedValue * selectedPrice!.precioU;

    total =
        double.parse((parsedValue * selectedPrice!.precioU).toStringAsFixed(2));

    notifyListeners();
  }

  //cancelar
  void cancelButton(int back, BuildContext context) {
    Navigator.pop(context);
  }

  String addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  //navegar a pantalla producto
  void navigateProduct(
    BuildContext context,
    ProductModel product,
  ) async {
    accion = 0;
    //View models a utilizar

    final docVM = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

    final detailsVM = Provider.of<DetailsViewModel>(
      context,
      listen: false,
    );

    final loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    ); //lo

    String token = loginVM.token;
    // String user = loginVM.user;

    //instacia del servicio
    ProductService productService = ProductService();

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

    //print(bodegas.length);
    //print(prices.length);
    //print(docVM.valueParametro(351));

    //si hay mas de una bodega, mas de un precio o existe e parametro 351
    if (bodegas.length > 1 || prices.length > 1 || docVM.valueParametro(351)) {
      //Calcular totral de la transaccion
      //SI no hau precio seleccionado no calcular
      if (price == 0) {
        total = 0;
        return;
      }

      //convertir cantidad de texto a numerica
      int cantidad = convertirTextNum(controllerNum.text)!;

      //Calcular el total (cantidad * precio seleccionado)
      // total = cantidad * selectedPrice!.precioU;
      total =
          double.parse((cantidad * selectedPrice!.precioU).toStringAsFixed(2));

      //detener carga
      isLoading = false;

      //navegar y verificar que ocurre

      Navigator.pushNamed(
        context,
        AppRoutes.product,
        arguments: [
          product,
          2,
        ],
      );

      return;

      //si de vuelve errores de api o de las validaciones
    }

    if (!selectedBodega!.poseeComponente) {
      //realizar las validaciones
    }

    //Calcular totral de la transaccion
    //SI no hau precio seleccionado no calcular
    if (price == 0) {
      total = 0;
      return;
    }

    //convertir cantidad de texto a numerica
    int cantidad = convertirTextNum(controllerNum.text)!;

    //Calcular el total (cantidad * precio seleccionado)
    // total = cantidad * selectedPrice!.precioU;
    total =
        double.parse((cantidad * selectedPrice!.precioU).toStringAsFixed(2));

    double precioDias = 0;
    int cantidadDias = 0;

    //Si el docuemnto tiene fecha inicio y fecha fin, parametro 44, calcular el precio por dias
    if (docVM.valueParametro(44) && product.tipoProducto != 2) {
      //vobtener fechas

      if (Utilities.fechaIgualOMayorSinSegundos(
        docVM.fechaFinal,
        docVM.fechaInicial,
      )) {
        DateTime fechaIni = docVM.fechaInicial;
        DateTime fechaFin = docVM.fechaFinal;

        String startDate = addLeadingZero(fechaIni.day);
        String startMonth = addLeadingZero(fechaIni.month);
        String endDate = addLeadingZero(fechaFin.day);
        String endMonth = addLeadingZero(fechaFin.month);

        String dateStart = "${fechaIni.year}$startMonth$startDate "
            "${addLeadingZero(fechaIni.hour)}:${addLeadingZero(fechaIni.minute)}:${addLeadingZero(fechaIni.second)}";

        String dateEnd = "${fechaFin.year}$endMonth$endDate "
            "${addLeadingZero(fechaFin.hour)}:${addLeadingZero(fechaFin.minute)}:${addLeadingZero(fechaFin.second)}";

        //formular precios por dias
        ApiResModel resFormPrecio = await productService.getFormulaPrecioU(
          token,
          dateStart,
          dateEnd,
          total.toString(),
        );

        //valid succes response
        if (!resFormPrecio.succes) {
          isLoading = false;

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
        //asignar valores
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

    //agregar transacion al documento
    detailsVM.addTransaction(
      TraInternaModel(
        bodega: selectedBodega!,
        cantidad: (int.tryParse(controllerNum.text) ?? 0),
        cantidadDias: docVM.valueParametro(44) ? cantidadDias : 0,
        cargo: 0,
        consecutivo: 0,
        descuento: 0,
        estadoTra: 1,
        isChecked: false,
        operaciones: [],
        precio: selectedPrice,
        precioCantidad: docVM.valueParametro(44) ? total : null,
        precioDia: docVM.valueParametro(44) ? precioDias : null,
        producto: product,
        total: docVM.valueParametro(44) ? precioDias : total,
      ),
      context,
    );

    //campo de cantidad = "1"
    controllerNum.text = "1";
    valueNum = 1;

    //mensaje de confirmacion
    NotificationService.showSnackbar(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'transaccionAgregada',
      ),
    );

    DocumentService.saveDocumentLocal(context);

    //regresar a detalle
    Navigator.pop(context);

    //detener carga
    isLoading = false;

    //valor para regresae
    detailsVM.navegarProduct = 2;
  }

  //editar la transaccion
  editarTran(BuildContext context, int indexTra) async {
    accion = 1;
    //View Models a utilizar
    final detailsVM = Provider.of<DetailsViewModel>(
      context,
      listen: false,
    );

    final docVM = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

    final loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final localVM = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    String token = loginVM.token;
    String user = loginVM.user;

    //limpiar bodegas
    bodegas.clear();
    //Limpiar precios
    prices.clear();

    //Asignar cantidad de la transaccion a las variables correspondientes
    controllerNum.text = detailsVM.traInternas[indexTra].cantidad.toString();
    valueNum = detailsVM.traInternas[indexTra].cantidad;

    //obtener el producto
    ProductModel productoTra = detailsVM.traInternas[indexTra].producto;
    //obtener la bodega
    BodegaProductoModel bodegaTra = detailsVM.traInternas[indexTra].bodega!;
    //obtener el precio
    UnitarioModel precioTra = detailsVM.traInternas[indexTra].precio!;

    //inciiar proceso
    isLoading = true;

    //cargar podegas del producto seleccionado
    //instancia del servicio
    ProductService productService = ProductService();

    //consumo del api
    ApiResModel resBodega = await productService.getBodegaProducto(
      user,
      localVM.selectedEmpresa!.empresa,
      localVM.selectedEstacion!.estacionTrabajo,
      productoTra.producto,
      productoTra.unidadMedida,
      token,
    );

    //valid succes response
    if (!resBodega.succes) {
      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        resBodega,
      );
      return;
    }

    //agreagar bodegas encontradas
    bodegas.addAll(resBodega.response);

    //si solo hay una bodega seleccionarla por defecto
    if (bodegas.length == 1) {
      selectedBodega = bodegas.first;
    }

    // si no hay bodegas mostrar mensaje
    if (bodegas.isEmpty) {
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
      //evaluar los precios
      selectedBodega = bodegas.first;

      int bodega = bodegas.first.bodega;

      ApiResModel resPrecio = await productService.getPrecios(
        bodega,
        productoTra.producto,
        productoTra.unidadMedida,
        user,
        token,
        docVM.clienteSelect?.cuentaCorrentista ?? 0,
        docVM.clienteSelect?.cuentaCta ?? "0",
      );

      if (!resPrecio.succes) {
        isLoading = false;

        //si algo salio mal mostrar alerta
        await NotificationService.showErrorView(
          context,
          resPrecio,
        );
        return;
      }

      //almacenar respuesta de precios

      final List<PrecioModel> precios = resPrecio.response;

      if (precios.isEmpty) {
        //"no hay precios
        return;
      }

      for (var precio in precios) {
        final UnitarioModel unitario = UnitarioModel(
          id: precio.tipoPrecio,
          precioU: precio.precioUnidad,
          descripcion: precio.desTipoPrecio,
          precio: true, //true Tipo precio; false Factor conversion
          moneda: precio.moneda,
          orden: precio.tipoPrecioOrden,
        );

        prices.add(unitario);
      }

      //si no hay precios buscar factor conversion
      if (prices.isEmpty) {
        ApiResModel resFactores = await productService.getFactorConversion(
          bodega,
          productoTra.producto,
          productoTra.unidadMedida,
          user,
          token,
        );

        if (!resFactores.succes) {
          isLoading = false;

          //si algo salio mal mostrar alerta
          await NotificationService.showErrorView(
            context,
            resFactores,
          );
          return;
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

          prices.add(unitario);
        }
      }

      //si solo existe un precio

      if (prices.length == 1) {
        //
        UnitarioModel precioU = prices.first;

        selectedPrice = precioU;
        total = precioU.precioU;
        price = precioU.precioU;
        controllerPrice.text = precioU.precioU.toString();
      } else if (prices.length > 1) {
        //
        for (var i = 0; i < prices.length; i++) {
          final UnitarioModel unit = prices[i];

          if (unit.orden != null) {
            selectedPrice = unit;
            total = unit.precioU;
            price = unit.precioU;
            controllerPrice.text = unit.precioU.toString();
            break;
          }
        }
      }
    } //fin validacion de una bodega

    //detener carga
    isLoading = false;

    //buscar bodega de la transaccion
    int existBodega = -1;

    for (int i = 0; i < bodegas.length; i++) {
      final BodegaProductoModel traBodega = bodegas[i];
      if (traBodega.bodega == selectedBodega!.bodega) {
        existBodega = i;
        break;
      }
    }

    //si no se ecnotro la bodega crearla internamente y asiganrla
    if (existBodega == -1) {
      bodegas.add(bodegaTra);
      selectedBodega = bodegas[bodegas.length - 1];
    } else {
      //asiganar bodega de la transaccion
      selectedBodega = bodegas[existBodega];
    }

    //buscar precio del producto de la transaccion
    int existPrecio = -1;

    //si no se encontro el procuto crearlo unetnamente
    if (existPrecio == -1) {
      prices.add(precioTra);
      selectedPrice = prices[prices.length - 1];
    } else {
      //asignar precio del producto de la transaccion
      selectedPrice = prices[existPrecio];
    }

    //enviar indice de la transaccion para poder editarla despues
    indexEdit = indexTra;

    //calcular el total
    total = valueNum * selectedPrice!.precioU;

    //abrir pantalla producto con lo datos cargados

    Navigator.pushNamed(
      detailsVM.scaffoldKey.currentState!.context,
      AppRoutes.product,
      arguments: [
        productoTra,
        1,
      ],
    );

    //aun no pasa aqui
    return;
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

  //obtener imagenes

  Future<List<ObjetoProductoModel>> obtenerImagenesProductos(
    BuildContext context,
    ProductModel product,
  ) async {
    List<ObjetoProductoModel> urls = [];

    urls.clear(); //Limpiar lista de imagenes

    //View model de login para obtener usuario y token
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;

    //View model para obtenerla empresa
    EmpresaModel empresa = vmLocal.selectedEmpresa!;

    //Instancia del servico
    ProductService productService = ProductService();

    isLoading = true; //cargar pantalla

    //Consumo de api
    final ApiResModel res = await productService.getObjetosProducto(
      token,
      product.producto,
      product.unidadMedida,
      empresa.empresa,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      //retornar false si algo salio mal
      return [];
    }

    //Agregar respuesta de api a la lista de tipos de tarea
    urls.addAll(res.response);

    isLoading = false; //detener carga

    //retorar true si todo está correcto
    return urls;
  }

  //cambiar el texto dek input cantidad
  void changeTextNum(String value) {
    //asiganar valores
    int parsedValue = int.tryParse(value) ?? 0;
    valueNum = parsedValue;
    calculateTotal(); //calcuar total
  }

  int convertirTextNum2(String value) {
    // Convertir el texto a número
    int parsedValue = int.tryParse(value) ?? 0;

    // Retornar el valor numérico
    return parsedValue;
  }

  // Convierte un string a número entero si es válido
  int? convertirTextNum(String texto) {
    // Verificar si la cadena es un número entero
    final esNumeroEntero = RegExp(r'^\d+$').hasMatch(texto);

    if (esNumeroEntero) {
      // Realizar la conversión a número entero
      return int.parse(texto);
    } else {
      // Retornar null si la cadena no es un número entero
      return null;
    }
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
    int opcion,
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

    //Validacion de producto

    TipoTransaccionModel tipoTra = getTipoTransaccion(
      product.tipoProducto,
      context,
    );
    ProductService productService = ProductService();

    if (tipoTra.altCantidad) {
      //iniciar proceso

      //consumo del api
      ApiResModel res = await productService.getValidaProducto(
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
        menuVM.tipoCambio.toInt(),
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

      //aqui abre una norificacion
      if (mensajes.isNotEmpty) {
        //Lista para agregar las validaciones
        List<ValidateProductModel> validaciones = [];

        //detener carga
        isLoading = false;

        ValidateProductModel validacion = ValidateProductModel(
          sku: product.productoId,
          productoDesc: product.desProducto,
          bodega: "${selectedBodega!.nombre} (${selectedBodega!.bodega})",
          tipoDoc: "${menuVM.name} (${menuVM.documento!})",
          serie:
              "${docVM.serieSelect!.descripcion!} (${docVM.serieSelect!.serieDocumento!})",
          mensajes: mensajes,
        );

        validaciones.add(validacion);

        //aqui abre un dialogo con notificacion
        await NotificationService.showMessageValidations(
          context,
          validaciones,
        );

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

    if (docVM.valueParametro(44) && product.tipoProducto != 2) {
      if (Utilities.fechaIgualOMayorSinSegundos(
          docVM.fechaFinal, docVM.fechaInicial)) {
        DateTime fechaIni = docVM.fechaInicial;
        DateTime fechaFin = docVM.fechaFinal;

        String startDate = addLeadingZero(fechaIni.day);
        String startMonth = addLeadingZero(fechaIni.month);
        String endDate = addLeadingZero(fechaFin.day);
        String endMonth = addLeadingZero(fechaFin.month);

        String dateStart = "${fechaIni.year}$startMonth$startDate "
            "${addLeadingZero(fechaIni.hour)}:${addLeadingZero(fechaIni.minute)}:${addLeadingZero(fechaIni.second)}";

        String dateEnd = "${fechaFin.year}$endMonth$endDate "
            "${addLeadingZero(fechaFin.hour)}:${addLeadingZero(fechaFin.minute)}:${addLeadingZero(fechaFin.second)}";

        //formular precios por dias
        ApiResModel resFormPrecio = await productService.getFormulaPrecioU(
          token,
          dateStart,
          dateEnd,
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

//Opcion 1 = Agregar nueva transaccion
    if (opcion == 0) {
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
          total: docVM.valueParametro(44) ? precioDias : total,
          cargo: 0,
          descuento: 0,
          operaciones: [],
          precioCantidad: docVM.valueParametro(44) ? total : null,
          cantidadDias: docVM.valueParametro(44) ? cantidadDias : 0,
          precioDia: docVM.valueParametro(44) ? precioDias : null,
        ),
        context,
      );

      //actualizar el campo cantidad

      controllerNum.text = "1";

      //mensaje de confirmacion
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'transaccionAgregada',
        ),
      );

      DocumentService.saveDocumentLocal(context);
    }

    if (opcion == 1) {
      detailsVM.traInternas[indexEdit] = TraInternaModel(
        consecutivo: 0,
        estadoTra: 1,
        isChecked: false,
        bodega: selectedBodega!,
        producto: product,
        precio: selectedPrice,
        cantidad: (int.tryParse(controllerNum.text) ?? 0),
        total: docVM.valueParametro(44) ? precioDias : total,
        cargo: 0,
        descuento: 0,
        operaciones: [],
        precioCantidad: docVM.valueParametro(44) ? total : null,
        cantidadDias: docVM.valueParametro(44) ? cantidadDias : 0,
        precioDia: docVM.valueParametro(44) ? precioDias : null,
      );

      detailsVM.calculateTotales(context);

      //campo de cantidad = "1"
      controllerNum.text = "1";
      valueNum = 1;

      notifyListeners();

      //mensaje de confirmacion
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'traModificada',
        ),
      );
    }

    // //agregar transacion al documento
    // detailsVM.addTransaction(
    //   TraInternaModel(
    //     consecutivo: 0,
    //     estadoTra: 1,
    //     isChecked: false,
    //     bodega: selectedBodega!,
    //     producto: product,
    //     precio: selectedPrice,
    //     cantidad: (int.tryParse(controllerNum.text) ?? 0),
    //     total: docVM.valueParametro(44) ? precioDias : total,
    //     cargo: 0,
    //     descuento: 0,
    //     operaciones: [],
    //     precioCantidad: docVM.valueParametro(44) ? total : null,
    //     cantidadDias: docVM.valueParametro(44) ? cantidadDias : 0,
    //     precioDia: docVM.valueParametro(44) ? precioDias : null,
    //   ),
    //   context,
    // );

    // //actualizar el campo cantidad

    // controllerNum.text = "1";

    // //mensaje de confirmacion
    // NotificationService.showSnackbar(
    //   AppLocalizations.of(context)!.translate(
    //     BlockTranslate.notificacion,
    //     'transaccionAgregada',
    //   ),
    // );

    //regresar a pantallas anteriroeres
    if (back == 2) {
      // Navigator.popUntil(context, ModalRoute.withName(AppRoutes.detailsDoc));

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

  //ver imagenes
  Future<void> viewProductImages(
    BuildContext context,
    ProductModel product,
  ) async {
    List<ObjetoProductoModel> imageUrls = await obtenerImagenesProductos(
      context,
      product,
    );

    // Verificar si se obtuvieron imágenes
    if (imageUrls.isEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinImagenes',
        ),
      );
      return;
    }

    bool result = await showDialog<bool>(
          context: context,
          builder: (context) => ImageCarouselDialog(
            imageUrls: imageUrls
                .map(
                  (e) => e.urlImg,
                )
                .toList(), // Mapear a una lista de URLs si es necesario
          ),
        ) ??
        true;

    // Si quiere verse el error
    if (!result) {
      // Aquí puedes agregar la lógica para el botón de regresar si es necesario
    }
  }

  Future<void> viewImages(
    BuildContext context,
    List<String> imageUrls,
  ) async {
    if (imageUrls.isEmpty) {
      return;
    }

    bool result = await showDialog<bool>(
          context: context,
          builder: (context) => ImageCarouselDialog(
            imageUrls: imageUrls,
          ),
        ) ??
        true;

    //Si quiere verse el error
    if (!result) {
      //boton para regresar
      // Aquí puedes agregar la lógica para el botón de regresar si es necesario
    }
  }

  //Regresar a la pantalla anterior y limpiar
  Future<bool> back(
    BuildContext context,
  ) async {
    final vmDetalle = Provider.of<DetailsViewModel>(context, listen: false);
    vmDetalle.searchController.clear();
    return true;
  }

  //filtrar tareas
  Future<void> filtrarResultados(
    BuildContext context,
  ) async {
    //

    //obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    final vmDetalle = Provider.of<DetailsViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);

    String token = vmLogin.token;
    String user = vmLogin.user;
    EstacionModel station = localVM.selectedEstacion!;

    //campo de texto input
    String searchText = vmDetalle.searchController.text;

    searchText = searchText.trimRight();

    //instacia del servicio
    ProductService productService = ProductService();

    //Validar formulario
    if (vmDetalle.isValidFormCSearch() == false) return;

    //si tareas está vacio, reestablecer los rangos
    if (vmDetalle.products.isEmpty) {
      vmDetalle.rangoIni = 1;
      vmDetalle.rangoFin = vmDetalle.intervaloRegistros;
    }

    // Realiza la búsqueda
    //si ver mas es = 1 aumenta los rangos
    isLoading = true; //cargar pantalla

    //consumo de api
    final ApiResModel resDesc = await productService.getProduct(
      searchText,
      token,
      user,
      station.estacionTrabajo,
      vmDetalle.rangoIni,
      vmDetalle.rangoFin,
    );

    //si el consumo salió mal
    if (!resDesc.succes) {
      isLoading = false;
      NotificationService.showErrorView(
        context,
        resDesc,
      );
      return;
    }

    vmDetalle.products.addAll(resDesc.response);

    isLoading = false; //detener cargar pantalla

    vmDetalle.rangoIni = vmDetalle.products.length + 1;
    vmDetalle.rangoFin = vmDetalle.rangoIni + vmDetalle.intervaloRegistros;
  }
}
