// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/menu_view_model.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class OrderViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isSelectedMode = false;
  bool get isSelectedMode => _isSelectedMode;

  monitorPrint(
    BuildContext context,
    int indexOrder,
  ) {
    final MenuViewModel menuVM = Provider.of<MenuViewModel>(
      context,
      listen: false,
    );

    final docVM = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

    final localVM = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    final loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    //usuario token y cadena de conexion
    String user = loginVM.user;
    String tokenUser = loginVM.token;
    int tipoDocumento = menuVM.documento!;
    String serieDocumento = docVM.serieSelect!.serieDocumento!;
    int empresa = localVM.selectedEmpresa!.empresa;
    int estacion = localVM.selectedEstacion!.estacionTrabajo;

    double traTotal = 0;
    final List<DocTransaccion> transactions = [];

    // Generar dos números aleatorios de 7 dígitos cada uno
    var random = Random();

    int firstPart = random.nextInt(10000000);

    //Buscar transacciones que van a comandarse
    for (var tra in orders[indexOrder].transacciones) {
      int consecutivo = random.nextInt(10000000);
      if (!tra.processed) {
        transactions.add(
          DocTransaccion(
            traGuarniciones: tra.guarniciones.map((e) => e.selected).toList(),
            traObservacion: tra.observacion,
            traConsecutivoInterno: firstPart,
            traConsecutivoInternoPadre: 0,
            dConsecutivoInterno: consecutivo,
            traBodega: tra.bodega.bodega,
            traProducto: tra.producto.producto,
            traUnidadMedida: tra.producto.unidadMedida,
            traCantidad: tra.cantidad,
            traTipoCambio: menuVM.tipoCambio,
            traMoneda: tra.precio.moneda,
            traTipoPrecio: tra.precio.precio ? tra.precio.id : null,
            traFactorConversion: !tra.precio.precio ? tra.precio.id : null,
            traTipoTransaccion: 1, //TODO:Hace falta
            traMonto: (tra.cantidad * tra.precio.precioU),
          ),
        );

        traTotal += (tra.cantidad * tra.precio.precioU);
      }
    }

// Combinar los dos números para formar uno de 14 dígitos

    DateTime dateConsecutivo = DateTime.now();
    int randomNumber1 = Random().nextInt(900) + 100;

    String strNum1 = randomNumber1.toString();
    String combinedStr = strNum1 +
        dateConsecutivo.day.toString().padLeft(2, '0') +
        dateConsecutivo.month.toString().padLeft(2, '0') +
        dateConsecutivo.year.toString() +
        dateConsecutivo.hour.toString().padLeft(2, '0') +
        dateConsecutivo.minute.toString().padLeft(2, '0') +
        dateConsecutivo.second.toString().padLeft(2, '0');

    // ref id
    final int idDocumentoRef = int.parse(combinedStr);

    DateTime myDateTime = DateTime.now();
    String serializedDateTime = myDateTime.toIso8601String();

    final DocEstructuraModel doc = DocEstructuraModel(
      docMesa: orders[indexOrder].mesa.elementoAsignado,
      docUbicacion: orders[indexOrder].ubicacion.elementoAsignado,
      docLatitdud: null,
      docLongitud: null,
      consecutivoInterno: firstPart,
      docTraMonto: traTotal,
      docCaMonto: 0,
      docCuentaVendedor: orders[indexOrder]
          .mesero
          .cuentaCorrentista, //Preguntar si es el mesero
      docIdCertificador: 0,
      docIdDocumentoRef: idDocumentoRef,
      docFelNumeroDocumento: null,
      docFelSerie: null,
      docFelUUID: null,
      docFelFechaCertificacion: null,
      docFechaDocumento: serializedDateTime,
      docCuentaCorrentista: 1,
      docCuentaCta: "1",
      docTipoDocumento: tipoDocumento,
      docSerieDocumento: serieDocumento,
      docEmpresa: empresa,
      docEstacionTrabajo: estacion,
      docUserName: user,
      docObservacion1: "",
      docTipoPago: 1, //TODO:preguntar
      docElementoAsignado: 1, //TODO:Preguntar
      docTransaccion: transactions,
      docCargoAbono: [],
    );
  }

  set isSelectedMode(bool value) {
    _isSelectedMode = value;
    notifyListeners();
  }

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<OrderModel> orders = [];
  final List<int> selectedTra = [];

  Future<void> modifyTra(
    BuildContext context,
    int indexOrder,
    int indexTra,
  ) async {
    final ProductsClassViewModel productClassVM =
        Provider.of<ProductsClassViewModel>(
      context,
      listen: false,
    );

    isLoading = true;

    productClassVM.product =
        orders[indexOrder].transacciones[indexTra].producto;

    final DetailsRestaurantViewModel vmDetails =
        Provider.of<DetailsRestaurantViewModel>(
      context,
      listen: false,
    );

    final ApiResModel resGarnish = await vmDetails.loadGarnish(
      context,
      productClassVM.product!.producto,
      productClassVM.product!.unidadMedida,
    );

    if (!resGarnish.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resGarnish);
      return;
    }

    if (vmDetails.garnishs.isNotEmpty) {
      vmDetails.orederTreeGarnish();
    }

    //buscar guarniciones
    for (var element
        in orders[indexOrder].transacciones[indexTra].guarniciones) {
      for (var nodo in vmDetails.treeGarnish) {
        if (element.garnish.productoCaracteristica ==
            nodo.item!.productoCaracteristica) {
          for (var i = 0; i < nodo.children.length; i++) {
            if (nodo.children[i].item!.productoCaracteristica ==
                element.selected.productoCaracteristica) {
              nodo.selected = nodo.children[i].item!;
              break;
            }
          }
        }
      }
    }

    final ApiResModel resBodega = await vmDetails.loadBodega(context);

    if (!resBodega.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resBodega);
      return;
    }

    //si no se encontrarin bodegas mostrar mensaje
    if (vmDetails.bodegas.isEmpty) {
      isLoading = false;
      NotificationService.showSnackbar(AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'sinBodegaP',
      ));
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
    } else {
      for (var i = 0; i < vmDetails.bodegas.length; i++) {
        if (vmDetails.bodegas[i].bodega ==
            orders[indexOrder].transacciones[indexTra].bodega.bodega) {
          vmDetails.bodega = vmDetails.bodegas[i];
          break;
        }
      }

      final ApiResModel resPrices = await vmDetails.loadPrecioUnitario(context);

      if (!resPrices.succes) {
        isLoading = false;
        NotificationService.showErrorView(context, resPrices);
        return;
      }
    }

    for (var i = 0; i < vmDetails.unitarios.length; i++) {
      if (vmDetails.unitarios[i].id ==
          orders[indexOrder].transacciones[indexTra].precio.id) {
        vmDetails.selectedPrice = vmDetails.unitarios[i];

        vmDetails.selectedPrice = vmDetails.unitarios[i];
        vmDetails.total = vmDetails.selectedPrice!.precioU;
        vmDetails.price = vmDetails.selectedPrice!.precioU;
        vmDetails.controllerPrice.text = "${vmDetails.price}";
        break;
      }
    }

    vmDetails.valueNum = orders[indexOrder].transacciones[indexTra].cantidad;
    vmDetails.controllerNum.text =
        orders[indexOrder].transacciones[indexTra].cantidad.toString();
    vmDetails.formValues["observacion"] =
        orders[indexOrder].transacciones[indexTra].observacion;

    vmDetails.calculateTotal();

    final Map<String, dynamic> options = {
      'modify': true,
      'indexOrder': indexOrder,
      'indexTra': indexTra,
    };

    Navigator.pushNamed(
      context,
      AppRoutes.detailsRestaurant,
      arguments: options,
    );

    isLoading = false;
  }

  //Salir de la pantalla
  Future<bool> backPage(
    BuildContext context,
    int indexOrder,
  ) async {
    if (!isSelectedMode) return true;

    isSelectedMode = false;

    for (var element in orders[indexOrder].transacciones) {
      element.selected = false;
    }

    notifyListeners();

    return false;
  }

  selectedAll(int indexOrder) {
    if (orders[indexOrder].transacciones.length ==
        getSelectedItems(indexOrder)) {
      for (var element in orders[indexOrder].transacciones) {
        element.selected = false;
      }

      // isSelectedMode = false;
    } else {
      for (var element in orders[indexOrder].transacciones) {
        element.selected = true;
      }
    }

    notifyListeners();
  }

  sleectedItem(int indexOrder, indexTra) {
    orders[indexOrder].transacciones[indexTra].selected =
        !orders[indexOrder].transacciones[indexTra].selected;

    notifyListeners();

    if (getSelectedItems(indexOrder) == 0) isSelectedMode = false;
  }

  onLongPress(int indexOrder, indexTra) {
    orders[indexOrder].transacciones[indexTra].selected = true;

    isSelectedMode = true;
  }

  getSelectedItems(int indexOrder) {
    return orders[indexOrder]
        .transacciones
        .where((order) => order.selected)
        .toList()
        .length;
  }

  //incrementa la cantidad de la transaccion
  increment(int indexOrder, int indexTra) {
    orders[indexOrder].transacciones[indexTra].cantidad++;

    notifyListeners();
  }

  //decrementa la cantidad de la transaccion
  decrement(BuildContext context, int indexOrder, int indexTra) {
    if (orders[indexOrder].transacciones[indexTra].cantidad == 1) {
      delete(context, indexOrder, indexTra);
      return;
    }

    orders[indexOrder].transacciones[indexTra].cantidad--;
    notifyListeners();
  }

  deleteSelectRecursive(int indexOrder) {
    for (var i = 0; i < orders[indexOrder].transacciones.length; i++) {
      if (orders[indexOrder].transacciones[i].selected) {
        orders[indexOrder].transacciones.removeAt(i);
        deleteSelectRecursive(indexOrder);
        break;
      }
    }
  }

  deleteSelected(int indexOrder, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertWidget(
        title: "¿Estás seguro?",
        description:
            "Estas a punto de eliminar las transacciones seleccionadas. Esta accion no se puede deshacer.",
        onOk: () {
          //Cerrar sesión, limpiar datos
          Navigator.of(context).pop();

          deleteSelectRecursive(indexOrder);

          if (orders[indexOrder].transacciones.isEmpty) {
            Navigator.of(context).pop();
          }

          isSelectedMode = false;
          NotificationService.showSnackbar("Transacciones eliminadas");
          notifyListeners();
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  //Eliminar transaccion
  delete(BuildContext context, int indexOrder, int indexTra) {
    //eliminar transaccion
    showDialog(
      context: context,
      builder: (context) => AlertWidget(
        title: "¿Estás seguro?",
        description:
            "Estas a punto de eliminar la transaccion. Esta accion no se puede deshacer.",
        onOk: () {
          //Cerrar sesión, limpiar datos
          Navigator.of(context).pop();

          orders[indexOrder].transacciones.removeAt(indexTra);

          if (orders[indexOrder].transacciones.isEmpty) {
            Navigator.of(context).pop();
            isSelectedMode = false;
          }

          NotificationService.showSnackbar("Transaccion eliminada");
          notifyListeners();
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  addFirst(
    BuildContext context,
    OrderModel item,
  ) {
    final vmTable = Provider.of<TablesViewModel>(context, listen: false);
    orders.add(item);
    vmTable.updateOrdersTable(context);
    notifyListeners();
  }

  editTra(
    int indexOrder,
    int indexTra,
    TraRestaurantModel transaction,
  ) {
    orders[indexOrder].transacciones[indexTra] = transaction;
    notifyListeners();
  }

  addTransactionFirst(
    TraRestaurantModel transaction,
    int indexOrder,
  ) {
    orders[indexOrder].transacciones.add(transaction);
    notifyListeners();
  }

  addTransactionToOrder(
    BuildContext context,
    TraRestaurantModel transaction,
    int idexOrder,
  ) {
    orders[idexOrder].transacciones.add(transaction);
    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.productsClass));
    NotificationService.showSnackbar("Producto agregado");

    notifyListeners();
  }

  getGuarniciones(int indexOrder, int indexTra) {
    return orders[indexOrder]
        .transacciones[indexTra]
        .guarniciones
        .map(
          (guarnicion) =>
              "${guarnicion.garnish.descripcion} ${guarnicion.selected.descripcion}",
        )
        .join(", ");
  }

  getTotal(int idexOrder) {
    double total = 0;

    for (var element in orders[idexOrder].transacciones) {
      total += (element.cantidad * element.precio.precioU);
    }

    return total;
  }
}
