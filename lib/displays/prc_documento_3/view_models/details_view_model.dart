// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsViewModel extends ChangeNotifier {
  //llave global del scaffold
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  //Valores globales
  double subtotal = 0;
  double cargo = 0;
  double descuento = 0;
  double total = 0;
  double monto = 0;

  //Transacciones del docummento
  final List<TraInternaModel> traInternas = [];

  final List<TraInternaModel> transaccionesPorEliminar = [];

  //Contorlador input busqueda
  final TextEditingController searchController = TextEditingController();

  //productos encontrados
  final List<ProductModel> products = [];

  //checkbox marcar tas las transacciones agregadas
  bool selectAll = false;

  //checkbox maracr todos los montos agregados
  bool selectAllMontos = false;

  //opciones Monto/porcentaje
  String? selectedOption = "Porcentaje"; // Opción seleccionada

  //Key for form barra busqueda
  GlobalKey<FormState> formKeySearch = GlobalKey<FormState>();

  //Key for form cargo/descuento
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //Validar formulario cargo/descuento
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  //Validar formulario barra busqueda
  bool isValidFormCSearch() {
    return formKeySearch.currentState?.validate() ?? false;
  }

  //limpiar los campos de la vista del usuario
  void clearView(BuildContext context) {
    final vmProducto = Provider.of<ProductViewModel>(context, listen: false);

    vmProducto.controllerNum.text = "1";
    vmProducto.valueNum = 1;
    searchController.text = "";

    traInternas.clear(); //limpuar lista
    calculateTotales(context); //actualizar totales
  }

  //cambio del input monto
  void changeMonto(String value) {
    if (double.tryParse(value) == null) {
      //si el input es nulo o vacio agregar 0
      monto = 0;
    } else {
      monto = double.parse(value); //parse string to double
    }
    notifyListeners();
  }

  //Cambair valor ociones cargo o descuento
  void changeOption(String? value) {
    selectedOption = value; //asignar nuevo valor
    notifyListeners();
  }

  //declarar una propiedad de producto
  ProductModel? producto;

  int navegarProduct = 1;

  //Buscar con input
  Future<void> performSearch(BuildContext context) async {
    final docVM = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );
    //ocultar tecladp
    FocusScope.of(context).unfocus();

    //validar dormulario
    if (!isValidFormCSearch()) return;

    if (docVM.serieSelect == null) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'seleccionaSerie',
        ),
      );
      return;
    }

    //Limpiar lista de productros
    products.clear();

    //campo de texto input
    String searchText = searchController.text;

    searchText = searchText.trimRight();

    //view models extermos
    final loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    ); //login

    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    ); //home

    final productVM = Provider.of<ProductViewModel>(
      context,
      listen: false,
    ); //producto

    final vmPayment = Provider.of<PaymentViewModel>(
      context,
      listen: false,
    );

    final localVM = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    final menuVM = Provider.of<MenuViewModel>(
      context,
      listen: false,
    );

    final confirmVM = Provider.of<ConfirmDocViewModel>(
      context,
      listen: false,
    );

    final detailsVM = Provider.of<DetailsViewModel>(
      context,
      listen: false,
    );

    String token = loginVM.token;
    String user = loginVM.user;

    //Validar que el campo de cantidad que no sea nullo
    if (productVM.convertirTextNum(productVM.controllerNum.text) == null) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'cantidadPositiva',
        ),
      );
      return;
    }

    //Validar que el campo de cantidad sea una cantidad positiva
    if (productVM.convertirTextNum(productVM.controllerNum.text)! <= 0) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'cantidadNumerica',
        ),
      );
      return;
    }

    //instacia del servicio
    ProductService productService = ProductService();

    //load prosses
    vmFactura.isLoading = true;

    final ApiResModel resDesc = await productService.getProduct(
      searchText,
      token,
    );

    //valid succes response
    if (!resDesc.succes) {
      //si algo salio mal mostrar alerta
      vmFactura.isLoading = false;

      await NotificationService.showErrorView(
        context,
        resDesc,
      );

      return;
    }

    //añadir la repuesta
    products.addAll(resDesc.response);

    //si no hay coicncidencias de busqueda mostrar mensaje
    if (products.isEmpty) {
      vmFactura.isLoading = false;
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinCoincidencias',
        ),
      );
      return;
    }

    //si hay formas de pago agregadas mostrar mensaje
    if (vmPayment.amounts.isNotEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'eliminaFormaPago',
        ),
      );
      return;
    }

    //Reiniciar valores
    productVM.total = 0;
    productVM.selectedPrice = null;
    productVM.selectedBodega = null;
    productVM.bodegas.clear();
    productVM.prices.clear();
    // productVM.controllerNum.text = "1";
    // productVM.valueNum = 1;
    productVM.price = 0;

    //si solo hay uno seleccionarlo
    if (products.length == 1) {
      producto = products[0];
    } else {
      //cartar
      vmFactura.isLoading = false;

      //navegar a pantalla de coincidencias
      Navigator.pushNamed(
        context,
        AppRoutes.selectProduct,
        arguments: products,
      );

      vmFactura.isLoading = false;
      return;

      //el producto que se selecciona en la pantalla de coincidecias se asigna a producto
    }

    //ya teniendo producto seleccionado realizar la busqueda de bodega

    //consumo de bodegas

    //limpiar bodegas
    productVM.selectedBodega = null;
    productVM.bodegas.clear();

    //consumo del api
    ApiResModel resBodegas = await productService.getBodegaProducto(
      user, // user,
      localVM.selectedEmpresa!.empresa, // empresa,
      localVM.selectedEstacion!.estacionTrabajo, // estacion,
      producto!.producto, // producto,
      producto!.unidadMedida, // um,
      token, // token,
    );

    //valid succes response
    if (!resBodegas.succes) {
      //si algo salio mal mostrar alerta
      vmFactura.isLoading = false;
      await NotificationService.showErrorView(
        context,
        resBodegas,
      );
      return;
    }

    //agreagar bodegas encontradas
    productVM.bodegas.addAll(resBodegas.response);

    //si no se encontrarin bodegas mostrar mensaje
    if (productVM.bodegas.isEmpty) {
      vmFactura.isLoading = false;
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinBodegaP',
        ),
      );
      return;
    }

    //si solo hay una bodega seleccionarla por defecto
    if (productVM.bodegas.length == 1) {
      //evaluar los precios
      productVM.selectedBodega = productVM.bodegas.first;

      int bodega = productVM.bodegas.first.bodega;

      ApiResModel resPrecio = await productService.getPrecios(
        bodega,
        producto!.producto,
        producto!.unidadMedida,
        user,
        token,
        docVM.clienteSelect?.cuentaCorrentista ?? 0,
        docVM.clienteSelect?.cuentaCta ?? "0",
      );

      if (!resPrecio.succes) {
        vmFactura.isLoading = false;

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

        productVM.prices.add(unitario);
      }

      //si no hay precios buscar factor conversion
      if (productVM.prices.isEmpty) {
        ApiResModel resFactores = await productService.getFactorConversion(
          bodega,
          producto!.producto,
          producto!.unidadMedida,
          user,
          token,
        );

        if (!resFactores.succes) {
          vmFactura.isLoading = false;

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

          productVM.prices.add(unitario);
        }
      }

      //si solo existe un precio

      if (productVM.prices.length == 1) {
        //
        UnitarioModel precioU = productVM.prices.first;

        productVM.selectedPrice = precioU;
        productVM.total = precioU.precioU;
        productVM.price = precioU.precioU;
        productVM.controllerPrice.text = precioU.precioU.toString();
      } else if (productVM.prices.length > 1) {
        //
        for (var i = 0; i < productVM.prices.length; i++) {
          final UnitarioModel unit = productVM.prices[i];

          if (unit.orden != null) {
            productVM.selectedPrice = unit;
            total = unit.precioU;
            productVM.price = unit.precioU;
            productVM.controllerPrice.text = unit.precioU.toString();
            break;
          }
        }

        //si no se selecciono precio
        if (productVM.selectedPrice == null) {
          //obtener el primer registro y seleccionarlo
          UnitarioModel precioU = productVM.prices.first;

          productVM.selectedPrice = precioU;
          productVM.total = precioU.precioU;
          productVM.price = precioU.precioU;
          productVM.controllerPrice.text = precioU.precioU.toString();
        }
      }
    } //fin validacion de una bodega

    //si hay mas de una bodega, mas de un precio o existe e parametro 351

    if (productVM.bodegas.length > 1 ||
        productVM.prices.length > 1 ||
        docVM.valueParametro(351)) {
      //detener carga
      vmFactura.isLoading = false;
      productVM.accion = 0;

      //convertir cantidad de texto a numerica
      int cantidad = productVM.convertirTextNum(productVM.controllerNum.text)!;

      //Calcular el total (cantidad * precio seleccionado)
      productVM.total = cantidad * productVM.selectedPrice!.precioU;

      //navegar y verificar que ocurre

      Navigator.pushNamed(
        context,
        AppRoutes.product,
        arguments: [
          producto,
          1,
        ],
      );

      return;

      //si de vuelve errores de api o de las validaciones
    }

    //si no se abre el dialogo agregar ka transaccon directammente
    //Hacer validaciones y agreagr transaccion

    if (!productVM.selectedBodega!.poseeComponente) {
      //validar el producto

      //consumo del api
      ApiResModel resDisponibiladProducto =
          await productService.getValidaProducto(
        user,
        docVM.serieSelect!.serieDocumento!,
        menuVM.documento!,
        localVM.selectedEstacion!.estacionTrabajo,
        localVM.selectedEmpresa!.empresa,
        productVM.selectedBodega!.bodega,
        confirmVM.resolveTipoTransaccion(
          producto!.tipoProducto,
          context,
        ),
        producto!.unidadMedida,
        producto!.producto,
        (int.tryParse(productVM.controllerNum.text) ?? 0),
        menuVM.tipoCambio.toInt(),
        productVM.selectedPrice!.moneda,
        productVM.selectedPrice!.id,
        token,
      );

      if (!resDisponibiladProducto.succes) {
        vmFactura.isLoading = false;

        //si algo salio mal mostrar alerta
        await NotificationService.showErrorView(
          context,
          resDisponibiladProducto,
        );
        return;
      }

      //almacenar los mensajes
      List<String> mensajes = resDisponibiladProducto.response;

      if (mensajes.isNotEmpty) {
        //Lista para agregar las validaciones
        List<ValidateProductModel> validaciones = [];
        //detener carga
        vmFactura.isLoading = false;

        ValidateProductModel validacion = ValidateProductModel(
          sku: producto!.productoId,
          productoDesc: producto!.desProducto,
          bodega:
              "${productVM.selectedBodega!.nombre} (${productVM.selectedBodega!.bodega})",
          tipoDoc: "${menuVM.name} (${menuVM.documento!})",
          serie:
              "${docVM.serieSelect!.descripcion!} (${docVM.serieSelect!.serieDocumento!})",
          mensajes: mensajes,
        );

        //insertar registros
        validaciones.add(validacion);

        //aqui abre un dialogo con notificacion
        await NotificationService.showMessageValidations(
          context,
          validaciones,
        );

        return;
      }
    }

    //Calcular totral de la transaccion
    //SI no hau precio seleccionado no calcular
    if (productVM.price == 0) {
      productVM.total = 0;
      return;
    }

    //convertir cantidad de texto a numerica
    int cantidad = productVM.convertirTextNum(productVM.controllerNum.text)!;

    //Calcular el total (cantidad * precio seleccionado)
    productVM.total = cantidad * productVM.selectedPrice!.precioU;

    double precioDias = 0;
    int cantidadDias = 0;

    //Si el docuemnto tiene fecha inicio y fecha fin, parametro 44, calcular el precio por dias
    if (docVM.valueParametro(44)) {
      //vobtener fechas

      if (Utilities.fechaIgualOMayorSinSegundos(
        docVM.fechaFinal,
        docVM.fechaInicial,
      )) {
        //formular precios por dias
        ApiResModel resFormPrecio = await productService.getFormulaPrecioU(
          token,
          docVM.fechaInicial,
          docVM.fechaFinal,
          productVM.total.toString(),
        );

        //valid succes response
        if (!resFormPrecio.succes) {
          vmFactura.isLoading = false;

          //si algo salio mal mostrar alerta

          await NotificationService.showErrorView(
            context,
            resFormPrecio,
          );
          return;
        }

        List<PrecioDiaModel> preciosDia = resFormPrecio.response;

        if (preciosDia.isEmpty) {
          vmFactura.isLoading = false;

          resFormPrecio.response =
              'No fue posible obtner los valores calculados para el precio dia';

          NotificationService.showErrorView(context, resFormPrecio);

          return;
        }
        //asignar valores
        precioDias = preciosDia[0].montoCalculado;
        cantidadDias = preciosDia[0].cantidadDia;
      } else {
        vmFactura.isLoading = false;

        precioDias = productVM.total;
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
        bodega: productVM.selectedBodega!,
        cantidad: (int.tryParse(productVM.controllerNum.text) ?? 0),
        cantidadDias: docVM.valueParametro(44) ? cantidadDias : 0,
        cargo: 0,
        consecutivo: 0,
        descuento: 0,
        estadoTra: 1,
        isChecked: false,
        operaciones: [],
        precio: productVM.selectedPrice,
        precioCantidad: docVM.valueParametro(44) ? productVM.total : null,
        precioDia: docVM.valueParametro(44) ? precioDias : null,
        producto: producto!,
        total: docVM.valueParametro(44) ? precioDias : productVM.total,
      ),
      context,
    );

    //campo de cantidad = "1"
    productVM.controllerNum.text = "1";
    productVM.valueNum = 1;
    productVM.accion = 0;

    //mensaje de confirmacion
    NotificationService.showSnackbar(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'transaccionAgregada',
      ),
    );

    //detener carga
    vmFactura.isLoading = false;

    DocumentService.saveDocumentLocal(context);
  }

  //Obtener y escanear codico de barras
  Future<void> scanBarcode(BuildContext context) async {
    //Escanear codigo de barras
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#FF0000',
      AppLocalizations.of(context)!.translate(
        BlockTranslate.botones,
        'cancelar',
      ),
      true,
      ScanMode.BARCODE,
    );

    //si se escane algun resultado
    if (barcodeScanRes != '-1') {
      //aiganr codigo escaneado a input
      searchController.text = barcodeScanRes;
      //Buscar producto
      performSearch(context);
    }
  }

  //agreagar transaccion al documento
  void addTransaction(
    TraInternaModel transaction,
    BuildContext context,
  ) {
    //asiganr valores
    transaction.isChecked = selectAll;
    traInternas.add(transaction); //agregar a lista
    searchController.text = "";
    calculateTotales(context); //calcular totales
  }

  //Cambiar valor de checkbox de las transacciones
  void changeChecked(
    bool? value,
    int index,
  ) {
    traInternas[index].isChecked = value!;
    notifyListeners();
  }

  //cammbiar check de los montos agegados
  void changeCheckedMonto(
    bool? value,
    int indexTransaction,
    int index,
  ) {
    //cambiar valorss
    traInternas[indexTransaction].operaciones[index].isChecked = value!;
    notifyListeners();
  }

  //seleccioanr todos los montos (cargo descuento)
  void selectAllMonto(bool? value, int index) {
    selectAllMontos = value!;

    //marcar todos
    for (var element in traInternas[index].operaciones) {
      element.isChecked = selectAllMontos;
    }
    notifyListeners();
  }

  //seleccionar todas las transacciones del documento
  void selectAllTransactions(bool? value) {
    selectAll = value!;

    //marcar todos
    for (var element in traInternas) {
      element.isChecked = selectAll;
    }
    notifyListeners();
  }

  //elimminar transacciones sleccionadas
  Future<void> deleteTransaction(BuildContext context) async {
    //view model externo
    final vmPayment = Provider.of<PaymentViewModel>(context, listen: false);

    //si hay formas de pago agregadas mostrar mensaje
    if (vmPayment.amounts.isNotEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'eliminaFormaPago',
        ),
      );
      return;
    }

    //contador
    int numSelected = 0;

    //bsucar las transacciones que están sleccionadas
    for (var element in traInternas) {
      if (element.isChecked) {
        numSelected += 1;
      }
    }

    //si no hay transacciones seleccionadas mostar mensaje
    if (numSelected == 0) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'seleccionaTrans',
        ),
      );
      return;
    }

    //mostatr dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'confirmar',
            ),
            description: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'perder',
            ),
            textOk: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              "aceptar",
            ),
            textCancel: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              "cancelar",
            ),
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;

    //cancelar
    if (!result) return;

    //elimminar las transacciones seleccionadas
    traInternas.removeWhere((document) => document.isChecked == true);
    //calcular totoles
    calculateTotales(context);

    selectAll = false;
  }

  //eliminar cargo descuento sleccionado
  Future<void> deleteMonto(BuildContext context, int indexDocument) async {
    //view model externo
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);

    //buscar operaciones seleccionadas
    int numSelected = 0;
    for (var element in traInternas[indexDocument].operaciones) {
      if (element.isChecked) {
        numSelected += 1;
      }
    }

    //si no hay seleccioandas mostrar mensaje
    if (numSelected == 0) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'seleccionaMonto',
        ),
      );
      return;
    }

    //si hay formas de pago agregadas mostrar mensaje
    if (paymentVM.amounts.isNotEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'eliminaFormaPago',
        ),
      );
      return;
    }

    //Dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'confirmar',
            ),
            description: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'perder',
            ),
            textOk: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              "aceptar",
            ),
            textCancel: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              "cancelar",
            ),
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;

    //Cncelar
    if (!result) return;

    //eliminar los elemntos seleccionados
    traInternas[indexDocument]
        .operaciones
        .removeWhere((document) => document.isChecked == true);

    //calcular totales
    calculateTotales(context);
  }

  //agregar cargo o descueno
  void cargoDescuento(int operacion, BuildContext context) {
    //ocultar teclado
    FocusScope.of(context).unfocus();

    //operacion 1: cargo
    //operacion 2: descuento
    if (!isValidForm()) return;

    //view model externo
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);

    //si hay formas de pago agregadas mostrar mensaje
    if (paymentVM.amounts.isNotEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'eliminaFormaPago',
        ),
      );
      return;
    }

    //reicniar valores
    double prorrateo = 0;
    int numSelected = 0;
    double totalTransactions = 0;

    //contar itemes seleccionados
    for (var element in traInternas) {
      if (element.isChecked) {
        numSelected += 1;
      }
    }

    //si no hay items seleccionados mmostrar mensaje
    if (numSelected == 0) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'seleccionaTrans',
        ),
      );
      return;
    }

    // Filtrar los elementos seleccionados (isChecked = true) de la lista
    List<TraInternaModel> selectedTransactions =
        traInternas.where((document) => document.isChecked == true).toList();

    //total de las transacciones seleccionadas
    for (var element in selectedTransactions) {
      totalTransactions += element.total;
    }

    // si es por monto
    if (selectedOption == "Monto") prorrateo = monto / totalTransactions;

    //si es por porcentaje
    if (selectedOption == "Porcentaje") {
      double porcentaje = 0;
      porcentaje = totalTransactions * monto;
      porcentaje = porcentaje / 100;
      prorrateo = porcentaje / totalTransactions;
    }

    //multiplicar valores
    for (var element in traInternas) {
      double cargoDescuento = prorrateo * element.total;

      //Elemento que se va a agregar
      if (element.isChecked) {
        TraInternaModel transaction = TraInternaModel(
          cantidadDias: 0,
          consecutivo: 0,
          estadoTra: 0,
          precioCantidad: null,
          precioDia: null,
          isChecked: false,
          producto: element.producto,
          precio: null,
          bodega: null,
          cantidad: 0,
          total: 0,
          cargo: operacion == 1 ? cargoDescuento : 0,
          descuento: operacion == 2 ? cargoDescuento * -1 : 0,
          operaciones: [],
        );

        //agregar cargo o descuento
        element.operaciones.add(transaction);
      }
    }

    //mensaje de verificacion
    NotificationService.showSnackbar(
      operacion == 1
          ? AppLocalizations.of(context)!.translate(
              BlockTranslate.calcular,
              'cargoAgregado',
            )
          : AppLocalizations.of(context)!.translate(
              BlockTranslate.calcular,
              'descAgregado',
            ),
    );

    //calcular totales
    calculateTotales(context);
  }

  //Calcular totales
  void calculateTotales(BuildContext context) {
    //Borré la funcion que guarda el documento

    //Reiniciar valores
    subtotal = 0;
    cargo = 0;
    descuento = 0;
    total = 0;

    //recorrer todas las transacciones
    for (var element in traInternas) {
      //reiniciar valores
      element.cargo = 0;
      element.descuento = 0;

      //clacular total
      for (var tra in element.operaciones) {
        element.cargo += tra.cargo;
        element.descuento += tra.descuento;
      }
    }

    //agreagar totales globales
    for (var element in traInternas) {
      subtotal += element.total;
      cargo += element.cargo;
      descuento += element.descuento;
    }

    //calcular total documento
    total = cargo + descuento + subtotal;

    //view mmodel externo
    final vmPayment = Provider.of<PaymentViewModel>(context, listen: false);

    //calcular saldo y toal (Formas de pago)
    vmPayment.calculateTotales(context);

    notifyListeners();
  }

  //Navegar a pantalla de cargos y descuentos
  void navigatorDetails(BuildContext context, int index) {
    //si hay cargos o descuentos navegar a pantalla
    if (traInternas[index].operaciones.isNotEmpty) {
      Navigator.pushNamed(
        context,
        "cargoDescuento",
        arguments: index,
      );
    } else {
      //si la transaccion no tiene cargos o abonos mostrar mensaje
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinCargDesc',
        ),
      );
    }
  }

  //elimminar transaccion (deslizar)
  void dismissItem(BuildContext context, int index) {
    // Referencia al Timer para cancelarlo si es necesario
    Timer? timer;

    // Copia del elemento eliminado para el deshacer
    final TraInternaModel deletedItem = traInternas.removeAt(index);

    //view model externo
    final vmPayment = Provider.of<PaymentViewModel>(context, listen: false);

    //si hay formas de pago agregadas mostrar mensaje
    if (vmPayment.amounts.isNotEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinPagoONuevoDoc',
        ),
      );

      // Acción de deshacer: Restaurar el elemento eliminado
      traInternas.insert(index, deletedItem);
      calculateTotales(context);
      // Cancelar el Timer si el usuario deshace
      return;
    }

    // Mostrar el SnackBar con la opción de deshacer
    final snackBar = SnackBar(
      backgroundColor: AppTheme.color(
        context,
        Styles.primary,
      ),
      duration: const Duration(seconds: 5),
      content: Row(
        children: [
          //contador regresivo
          CountdownCircleWidget(
            duration: 5,
            onAnimationEnd: () {
              //eliminar transaxxion
              traInternas.remove(deletedItem);
              //calcular totales
              calculateTotales(context);
            },
          ),
        ],
      ),
      action: SnackBarAction(
        label: AppLocalizations.of(context)!.translate(
          BlockTranslate.botones,
          'deshacer',
        ),
        textColor: AppTheme.color(
          context,
          Styles.white,
        ),
        onPressed: () {
          // Acción de deshacer: Restaurar el elemento eliminado
          traInternas.insert(index, deletedItem);
          calculateTotales(context);
          // Cancelar el Timer si el usuario deshace
          timer?.cancel();
        },
      ),
    );

    // Mostrar el SnackBar
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Programar la eliminación permanente después de 5 segundos
    timer = Timer(const Duration(seconds: 5), () {
      traInternas.remove(deletedItem);
      calculateTotales(context);
    });

    //Calcular totales
    calculateTotales(context);
  }
}
