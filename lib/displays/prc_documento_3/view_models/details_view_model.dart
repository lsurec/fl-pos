// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsViewModel extends ChangeNotifier {
  //Valores globales
  double subtotal = 0;
  double cargo = 0;
  double descuento = 0;
  double total = 0;
  double monto = 0;

  //Transacciones del docummento
  final List<TraInternaModel> traInternas = [];

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

  //Filtro seleccionado SKU/Descripcion
  String? filterOption = "SKU"; // Opción seleccionada

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

  //Cambair valor ociones filtros
  void changeOptionFilter(String? value) {
    filterOption = value; //asignar nuevo valor
    notifyListeners();
  }

  //Buscar con input
  Future<void> performSearch(BuildContext context) async {
    //ocultar tecladp
    FocusScope.of(context).unfocus();

    //validar dormulario
    if (!isValidFormCSearch()) return;

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

    //instacia del servicio
    ProductService productService = ProductService();

    //respuesta del servixio
    ApiResModel? res;

    //load prosses
    vmFactura.isLoading = true;

    //si el filtro es  sku
    if (filterOption == "SKU") {
      //Consumir api
      res = await productService.getProductId(searchText, loginVM.token);
    }

    //si el filtro es descripcion
    if (filterOption == "Descripcion") {
      //consumir api
      res = await productService.getProductDesc(searchText, loginVM.token);
    }

    //valid succes response
    if (!res!.succes) {
      //si algo salio mal mostrar alerta
      vmFactura.isLoading = false;

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

    //Agregar productos encontrados
    products.addAll(res.message);

    //si no hay coicncidencias de busqueda mostrar mensaje
    if (products.isEmpty) {
      vmFactura.isLoading = false;
      NotificationService.showSnackbar("No se encontraron coincidencias");
      return;
    }

    //Reiniciar valores
    productVM.total = 0;
    productVM.selectedPrice = null;
    productVM.selectedBodega = null;
    productVM.bodegas.clear();
    productVM.prices.clear();
    productVM.controllerNum.text = "1";
    productVM.valueNum = 1;
    productVM.price = 0;

    //si solo hay una concidencia (producto encontrado)
    if (products.length == 1) {
      //Buscar bodegas del producto
      await productVM.loadBodegaProducto(
        context,
        products[0].producto,
        products[0].unidadMedida,
      );

      //si no se encontrarin bodegas mostrar mensaje
      if (productVM.bodegas.isEmpty) {
        vmFactura.isLoading = false;
        NotificationService.showSnackbar("No hay bodegas para este producto.");
        return;
      }

      //si hay mas de 1 bodega no buscar precios
      if (productVM.bodegas.length == 1) {
        ApiResModel precios = await productVM.loadPrecioUnitario(
          context,
          products[0].producto,
          products[0].unidadMedida,
          productVM.bodegas.first.bodega,
        );

        vmFactura.isLoading = false;

        if (!precios.succes) {
          ErrorModel error = precios.message;

          NotificationService.showErrorView(
            context,
            error,
          );
          return;
        }
        productVM.prices = precios.message;

        if (productVM.prices.isEmpty) {
          NotificationService.showSnackbar("No hay precios para este producto");
          return;
        }
      }

      //finalizar proceso
      vmFactura.isLoading = false;

      //Navegar a vista producto
      Navigator.pushNamed(
        context,
        "product",
        arguments: [
          products[0],
          1, //de que pantalla se navego (1: detalles, 2: seleccionar producto)
        ],
      );

      return;
    }

    //finalizar proceso
    vmFactura.isLoading = false;

    //navegar a lista sleccionar productos si hay varias coincidencias
    Navigator.pushNamed(context, "selectProduct", arguments: products);
  }

  //Obtener y escanear codico de barras
  Future<void> scanBarcode(BuildContext context) async {
    //Escanear codigo de barras
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      '#FF0000',
      'Cancelar',
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
          "Elimina primero las formas de pago o crea un nuevo documento.");
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
          "Seleccione por lo menos una transacción.");
      return;
    }

    //mostatr dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: "¿Estás seguro?",
            description:
                "Si no se han guardado los cambios, los perderás para siempre.",
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
      NotificationService.showSnackbar("Seleccione por lo menos un monto.");
      return;
    }

    //si hay formas de pago agregadas mostrar mensaje
    if (paymentVM.amounts.isNotEmpty) {
      NotificationService.showSnackbar("Elimina primero las formas de pago");
      return;
    }

    //Dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: "¿Estás seguro?",
            description:
                "Si no se han guardado los cambios, los perderás para siempre.",
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
      NotificationService.showSnackbar("Elimina primero las formas de pago");
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
          "Seleccione por lo menos una transacción.");
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
        operacion == 1 ? "Cargo agregado." : "Descuento agregado.");

    //calcular totales
    calculateTotales(context);
  }

  //Calcular totales
  void calculateTotales(BuildContext context) {
    DocumentService.saveDocumentLocal(context);

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
      NotificationService.showSnackbar("No hay cargos o descuentos agregados");
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
          "Elimina primero las formas de pago o crea un nuevo documento.");

      // Acción de deshacer: Restaurar el elemento eliminado
      traInternas.insert(index, deletedItem);
      calculateTotales(context);
      // Cancelar el Timer si el usuario deshace
      return;
    }

    // Mostrar el SnackBar con la opción de deshacer
    final snackBar = SnackBar(
      backgroundColor: AppTheme.primary,
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
        label: 'Deshacer',
        textColor: Colors.white,
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
