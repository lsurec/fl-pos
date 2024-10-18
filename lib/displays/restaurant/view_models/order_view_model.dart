// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/restaurant_service.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_post_printer_example/libraries/app_data.dart'
    as AppData;

class OrderViewModel extends ChangeNotifier {
  final PrinterManager instanceManager = PrinterManager.instance;

  //manejar flujo del procesp
  bool _isSelectedMode = false;
  bool get isSelectedMode => _isSelectedMode;

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

  navigatePermisionView(
    BuildContext context,
    int indexOrder,
  ) {
    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    final LocationsViewModel locVM = Provider.of<LocationsViewModel>(
      context,
      listen: false,
    );

    final TransferSummaryViewModel transerVM =
        Provider.of<TransferSummaryViewModel>(
      context,
      listen: false,
    );

    transerVM.indexOrderOrigin = indexOrder;
    transerVM.tableOrigin = tablesVM.table;
    transerVM.locationOrigin = locVM.location;

    Navigator.pushNamed(
      context,
      AppRoutes.permisions,
      arguments: 45, // 32 trasladar mesa
    );
  }

  Future<void> monitorPrint(
    BuildContext context,
    int indexOrder,
  ) async {
    final MenuViewModel menuVM = Provider.of<MenuViewModel>(
      context,
      listen: false,
    );

    final homeResVM = Provider.of<HomeRestaurantViewModel>(
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
    String serieDocumento = homeResVM.serieSelect!.serieDocumento!;
    int empresa = localVM.selectedEmpresa!.empresa;
    int estacion = localVM.selectedEstacion!.estacionTrabajo;

    double traTotal = 0;
    final List<DocTransaccion> transactions = [];

    // Generar dos números aleatorios de 7 dígitos cada uno
    var random = Random();

    int firstPart = 0;

    if (orders[indexOrder].consecutivoRef != 0) {
      firstPart = orders[indexOrder].consecutivoRef;
    } else {
      firstPart = random.nextInt(10000000);
    }

    int consecutivo = 1;

    //Buscar transacciones que van a comandarse
    for (var tra in orders[indexOrder].transacciones) {
      int padre = consecutivo;

      //guarniciones

      for (var element in tra.guarniciones) {
        consecutivo++;

        int fBodega = 0;
        int fProducto = 0;
        int fUnidadMedida = 0;
        int fCantidad = 0;

        if (element.selected.fProducto != null) {
          fBodega = element.selected.fBodega!;
          fProducto = element.selected.fProducto!;
          fUnidadMedida = element.selected.fUnidadMedida!;
          fCantidad = element.selected.cantidad?.toInt() ?? 0;
        } else {
          for (var i = 0; i < element.garnishs.length; i++) {
            if (element.garnishs[i].fProducto != null) {
              fBodega = element.garnishs[i].fBodega!;
              fProducto = element.garnishs[i].fProducto!;
              fUnidadMedida = element.garnishs[i].fUnidadMedida!;
              fCantidad = element.garnishs[i].cantidad?.toInt() ?? 0;
              break;
            }
          }
        }

        transactions.add(
          DocTransaccion(
              traObservacion:
                  "${element.garnishs.map((e) => e.descripcion).join(" ")} ${element.selected.descripcion}",
              traConsecutivoInterno: consecutivo,
              traConsecutivoInternoPadre: padre,
              dConsecutivoInterno: firstPart,
              traBodega: fBodega,
              traProducto: fProducto,
              traUnidadMedida: fUnidadMedida,
              traCantidad: fCantidad,
              traTipoCambio: menuVM.tipoCambio,
              traMoneda: tra.precio.moneda,
              traTipoPrecio:
                  tra.precio.precio ? tra.precio.id : null, //TODO:Preguntar
              traFactorConversion:
                  !tra.precio.precio ? tra.precio.id : null, //TODO:Preguntar
              traTipoTransaccion: 1, //TODO:Hace falta,
              traMonto: (tra.cantidad * tra.precio.precioU), //pregunatr
              traMontoDias: null),
        );
      }

      transactions.add(
        DocTransaccion(
          traMontoDias: null,
          traObservacion: tra.observacion,
          traConsecutivoInterno: padre,
          traConsecutivoInternoPadre: null,
          dConsecutivoInterno: firstPart,
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

      consecutivo++;
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
      docConfirmarOrden: false,
      docComanda: orders[indexOrder].nombre,
      docFechaFin: null,
      docFechaIni: null,
      docRefDescripcion: null,
      docRefFechaFin: null,
      docRefFechaIni: null,
      docRefObservacion2: null,
      docRefObservacion3: null,
      docRefObservacion: null,
      docRefTipoReferencia: null,
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

    // if (true) {
    if (orders[indexOrder].consecutivo == 0) {
      //objeto enviar documento
      PostDocumentModel document = PostDocumentModel(
        estructura: doc.toJson(),
        user: user,
        estado: 1, //1 sin mihrar 11 listo parta migrar
      );

      //instancia del servicio
      DocumentService documentService = DocumentService();

      isLoading = true;

      //consumo del api
      ApiResModel res = await documentService.postDocument(document, tokenUser);

      if (!res.succes) {
        isLoading = false;

        NotificationService.showErrorView(context, res);

        return;
      }

      orders[indexOrder].consecutivo = res.response["data"];
    } else {
      final PostDocumentModel estructuraupdate = PostDocumentModel(
        estructura: doc.toJson(),
        user: user,
        estado: 1, //1 pemd 11 loisto para migrar
      );

      //Actualizar
      final DocumentService documentService = DocumentService();

      isLoading = true;

      final ApiResModel resUpdateEstructura =
          await documentService.updateDocument(
        estructuraupdate,
        tokenUser,
        orders[indexOrder].consecutivo,
      );

      if (!resUpdateEstructura.succes) {
        isLoading = false;

        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'docEstrucNoActualizado',
          ),
        );

        return;
      }
    }

    for (var element in orders[indexOrder].transacciones) {
      element.processed = true;
    }

    isLoading = false;

    final RestaurantService restaurantService = RestaurantService();

    SenOrderModel order = SenOrderModel(
      userId: "111", //TODO:Armar user id empresa raiz, empresa, estacion
      order: orders[indexOrder].toJson(),
    );

    //TODO:notificar cambios a clientes escuchamado
    final ApiResModel resPostComanda = await restaurantService.notifyComanda(
      order,
      tokenUser,
    );

    // NotificationService.showSnackbar(resPostComanda.response);

    await printNetwork(context, indexOrder);

    NotificationService.showSnackbar(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'comandaEnviada',
      ),
    );
  }

  printNetwork(
    BuildContext context,
    int indexOrder,
  ) async {
    //Proveedor de datos externo
    final loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    //usuario token y cadena de conexion
    String user = loginVM.user;
    String tokenUser = loginVM.token;

    isLoading = true;

    final DocumentService documentService = DocumentService();

    final ApiResModel res = await documentService.getDataComanda(
      user, // user,
      tokenUser, // token,
      orders[indexOrder].consecutivo, // consecutivo,
    );

    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(
        context,
        res,
      );

      return;
    }

    final List<PrintDataComandaModel> detalles = res.response;

    final List<FormatoComanda> formats = [];

    for (var detalle in detalles) {
      if (formats.isEmpty) {
        formats.add(
          FormatoComanda(
            ipAdress: detalle.printerName,
            bodega: detalle.bodega,
            detalles: [detalle],
          ),
        );
      } else {
        int indexBodega = -1;

        for (var i = 0; i < formats.length; i++) {
          final FormatoComanda formato = formats[i];
          if (detalle.bodega == formato.bodega) {
            indexBodega = i;
            break;
          }
        }

        if (indexBodega == -1) {
          formats.add(
            FormatoComanda(
              ipAdress: detalle.printerName,
              bodega: detalle.bodega,
              detalles: [detalle],
            ),
          );
        } else {
          formats[indexBodega].detalles.add(detalle);
        }
      }
    }

    int paperDefault = 80; //58 //72 //80

    PosStyles center = const PosStyles(
      align: PosAlign.center,
    );

    // final ByteData data = await rootBundle.load('assets/logo_demosoft.png');
    // final Uint8List bytesImg = data.buffer.asUint8List();
    // final img.Image? image = decodeImage(bytesImg);

    for (var element in formats) {
      try {
        List<int> bytes = [];
        final generator = Generator(
          AppData.paperSize[paperDefault],
          await CapabilityProfile.load(),
        );

        bytes += generator.setGlobalCodeTable('CP1252');

        // bytes += generator.image(
        //   img.copyResize(image!, height: 200, width: 250),
        // );
        bytes += generator.text(
          element.detalles[0].desUbicacion,
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
          ),
        );

        bytes += generator.text(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'mesa',
          )}: ${element.detalles[0].desMesa.toUpperCase()}",
          styles: center,
        );

        bytes += generator.text(
          "${element.detalles[0].desSerieDocumento} - ${element.detalles[0].iDDocumentoRef}",
          styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
          ),
        );

        bytes += generator.emptyLines(1);

        //Incio del formato
        bytes += generator.row(
          [
            PosColumn(
              text: AppLocalizations.of(context)!.translate(
                BlockTranslate.tiket,
                'cantidad',
              ),
              width: 2,
              styles: const PosStyles(
                align: PosAlign.right,
              ),
            ),
            PosColumn(
              text: '',
              width: 1,
              styles: const PosStyles(
                align: PosAlign.left,
              ),
            ),
            PosColumn(
              text: AppLocalizations.of(context)!.translate(
                BlockTranslate.general,
                'descripcion',
              ),
              width: 9,
              styles: const PosStyles(
                align: PosAlign.left,
              ),
            ),
          ],
        );

        for (var tra in element.detalles) {
          bytes += generator.row(
            [
              PosColumn(
                text: "${tra.cantidad}",
                width: 2,
                styles: const PosStyles(
                  height: PosTextSize.size2,
                  align: PosAlign.right,
                ),
              ),
              PosColumn(
                text: "",
                width: 1,
              ), // Anc/ Ancho 2
              PosColumn(
                text:
                    "${tra.desProducto} ${tra.observacion.isNotEmpty ? '(${tra.observacion})' : ''}",
                width: 9,
                styles: const PosStyles(
                  height: PosTextSize.size2,
                  align: PosAlign.left,
                ),
              ), // Ancho 6
            ],
          );
        }

        bytes += generator.emptyLines(1);

        bytes += generator.text(
          "${AppLocalizations.of(context)!.translate(
            BlockTranslate.tiket,
            'atencion',
          )}: ${element.detalles[0].userName.toUpperCase()}",
          styles: center,
        );

        final now = element.detalles[0].fechaHora;

        bytes += generator.text(
          "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}",
          styles: center,
        );

        bytes += generator.emptyLines(2);

        bytes += generator.text(
          "----------------------------",
          styles: center,
        );

        bytes += generator.text(
          "Powered By:",
          styles: center,
        );

        bytes += generator.text(
          "Desarrollo Moderno de Software S.A.",
          styles: center,
        );
        bytes += generator.text(
          "www.demosoft.com.gt",
          styles: center,
        );

        bytes += generator.cut();

        await PrinterManager.instance.connect(
          type: PrinterType.network,
          model: TcpPrinterInput(
            //TODO:Cambiar a ip de la base de datos
            // ipAddress: element.ipAdress,
            ipAddress: "192.168.0.10",
          ),
        );

        await instanceManager.send(
          type: PrinterType.network,
          bytes: bytes,
        );
      } catch (e) {
        isLoading = false;
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'noImprimio',
          ),
        );

        return;
      }
    }

    isLoading = false;
  }

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
    // for (var element
    //     in orders[indexOrder].transacciones[indexTra].guarniciones) {
    //   for (var nodo in vmDetails.treeGarnish) {
    //     if (element.garnish.productoCaracteristica ==
    //         nodo.item!.productoCaracteristica) {
    //       for (var i = 0; i < nodo.children.length; i++) {
    //         if (nodo.children[i].item!.productoCaracteristica ==
    //             element.selected.productoCaracteristica) {
    //           nodo.selected = nodo.children[i].item!;
    //           break;
    //         }
    //       }
    //     }
    //   }
    // }

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
      if (orders[indexOrder].transacciones[i].selected &&
          !orders[indexOrder].transacciones[i].processed) {
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

          int comandadas = 0;

          for (var element in orders[indexOrder].transacciones) {
            if (element.processed && element.selected) {
              comandadas++;
            }
          }

          deleteSelectRecursive(indexOrder);

          if (orders[indexOrder].transacciones.isEmpty) {
            Navigator.of(context).pop();
          }

          for (var element in orders[indexOrder].transacciones) {
            element.selected = false;
          }

          isSelectedMode = false;

          notifyListeners();
          if (comandadas != 0) {
            NotificationService.showSnackbar(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.notificacion,
                'comandadasNoModificar',
              ),
            );
            return;
          }

          NotificationService.showSnackbar(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'traEliminadas',
            ),
          );
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

          NotificationService.showSnackbar(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'traEliminada',
            ),
          );

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
    NotificationService.showSnackbar(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'productoAgregado',
      ),
    );

    notifyListeners();
  }

  getGuarniciones(int indexOrder, int indexTra) {
    return orders[indexOrder]
        .transacciones[indexTra]
        .guarniciones
        .map((e) =>
            "${e.garnishs.map((guarnicion) => guarnicion.descripcion).join(" ")} ${e.selected.descripcion}")
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
