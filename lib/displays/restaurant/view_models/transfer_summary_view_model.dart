// ignore_for_file: use_build_context_synchronously

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/select_account_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class TransferSummaryViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  LocationModel? locationOrigin;
  LocationModel? locationDest;
  TableModel? tableOrigin;
  TableModel? tableDest;

  int indexOrderOrigin = -1;
  int indexOrderDest = -1;

  cancelAccount(BuildContext context) {
    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    tablesVM.restartTable();

    for (var element in orderVM.orders) {
      element.selected = false;
    }

    orderVM.isSelectedMode = false;

    Navigator.popUntil(
      context,
      ModalRoute.withName(AppRoutes.selectAccount),
    );
  }

  cancelTransfer(BuildContext context) {
    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    tablesVM.restartTable();

    for (var traInter in orderVM.orders[indexOrderOrigin].transacciones) {
      traInter.selected = false;
    }

    orderVM.isSelectedMode = false;

    Navigator.popUntil(
      context,
      ModalRoute.withName(AppRoutes.order),
    );
  }

  setLocationDest(LocationModel location) {
    locationDest = location;
  }

  setTableDest(TableModel table) {
    tableDest = table;
  }

  finishProcess(BuildContext context) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    for (var traInter in orderVM.orders[indexOrderOrigin].transacciones) {
      traInter.selected = false;
    }

    for (var traInter in orderVM.orders[indexOrderDest].transacciones) {
      traInter.selected = false;
    }

    orderVM.isSelectedMode = false;

    tablesVM.restartTable();

    NotificationService.showSnackbar(
        "Trnsacciones trsaladadas correctamente."); //TODO:Translate

    //si en dcouemnto rorigen hay transacciones regresar,
    if (orderVM.orders[indexOrderOrigin].transacciones.isNotEmpty) {
      Navigator.popUntil(context, ModalRoute.withName(AppRoutes.order));
      return;
    }
    //si no hay transacciones regresar a la pantalla de seleccion de orden
    //si solo hay una orden regresar a mesa

    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.tables));
    return;
  }

  Future<void> moveTable(BuildContext context) async {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    final SelectAccountViewModel selectAccountVM =
        Provider.of<SelectAccountViewModel>(
      context,
      listen: false,
    );

    //TODO:Espicidicar ordenes que no se pudieron actualizar
    int error = 0;

    isLoading = true;

    for (var i = 0; i < orderVM.orders.length; i++) {
      final OrderModel order = orderVM.orders[i];

      if (order.selected) {
        order.mesa = tableDest!;
        order.ubicacion = locationDest!;

        int contador = 0;

        for (var tra in order.transacciones) {
          if (tra.processed) {
            contador++;
          }
        }

        if (contador > 0) {
          //Actualizar documento
          final doc = await getDocumentoEstructura(context, i);

          final ApiResModel res = await updateEstructura(
            context,
            doc,
            order.consecutivo,
          );

          if (!res.succes) {
            error++;
          }
        }

        order.selected = false;
      }
    }

    isLoading = false;

    tablesVM.restartTable();
    tablesVM.updateOrdersTable(context);
    selectAccountVM.isSelectedMode = false;

    if (error > 0) {
      NotificationService.showSnackbar(
          "Algunas cuentas no se pudieron tranferir en el servidor.");
    } else {
      NotificationService.showSnackbar("Cuentas tranferidas con éxito");
    }

    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.tables));
  }

  Future<void> moveTransaction(BuildContext context) async {
    //buscar taransacciones que van a moverse
    //Buscar trasacciones totales de la orden en la que se estan moviendo
    //si hay una trabnsacion que se va a amover esta comandada crear nuevo dumcumento
    //sino sol oagregar

    //si la transaccion ya fue comandada eliminarla de estructura
    //si la transaccion no fue comandada agregarla a la estructura de la nueva (crear el documento )
    //si la transaccion no esta comandada no se envia a la doc estructura
    //---

    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    //Recorrer las transacciones
    //Si los cambios son solo locales
    int comandadas = 0;

    for (var element in orderVM.orders[indexOrderOrigin].transacciones) {
      if (element.selected && element.processed) {
        comandadas++;
      }
    }

    addTraToDoc(context, orderVM.orders[indexOrderOrigin].transacciones);

    if (comandadas == 0) {
      finishProcess(context);
    }

    //Generar documento estructura para origen y destino
    final DocEstructuraModel docOrigin =
        getDocumentoEstructura(context, indexOrderOrigin);
    final DocEstructuraModel docDestino =
        getDocumentoEstructura(context, indexOrderDest);

    //origen, destino
    int consOrigen = orderVM.orders[indexOrderOrigin].consecutivo;
    int consDest = orderVM.orders[indexOrderDest].consecutivo;

    isLoading = true;

    ApiResModel resOrigen =
        await updateEstructura(context, docOrigin, consOrigen);

    ApiResModel resDest;
    if (consDest > 0) {
      resDest = await updateEstructura(context, docDestino, consDest);
    } else {
      resDest = await createEstructura(context, docDestino);

      if (resDest.succes) {
        orderVM.orders[indexOrderDest].consecutivo = resDest.response["data"];
      }
    }

    if (!resDest.succes || !resOrigen.succes) {
      if (!resDest.succes && !resOrigen.succes) {
        NotificationService.showSnackbar(
            "El documento origen y destino no se actualizó.");
        return;
      }

      if (!resDest.succes) {
        NotificationService.showSnackbar(
            "El documento  destino no se actualizó.");
        return;
      }

      NotificationService.showSnackbar("El documento origen no se actualizó.");
      return;
    }

    finishProcess(context);
  }

  Future<ApiResModel> createEstructura(
    BuildContext context,
    DocEstructuraModel doc,
  ) async {
    final loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    //usuario token y cadena de conexion
    String user = loginVM.user;
    String tokenUser = loginVM.token;

    //objeto enviar documento
    PostDocumentModel document = PostDocumentModel(
      estructura: doc.toJson(),
      user: user,
      estado: 1, //1 sin mihrar 11 listo parta migrar
    );

    //instancia del servicio
    DocumentService documentService = DocumentService();

    //consumo del api
    ApiResModel res = await documentService.postDocument(document, tokenUser);

    return res;
  }

  Future<ApiResModel> updateEstructura(
    BuildContext context,
    DocEstructuraModel doc,
    int consecutivo,
  ) async {
    final loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    //usuario token y cadena de conexion
    String user = loginVM.user;
    String tokenUser = loginVM.token;

    final PostDocumentModel estructuraupdate = PostDocumentModel(
      estructura: doc.toJson(),
      user: user,
      estado: 1, //1 pemd 11 loisto para migrar
    );

    //Actualizar
    final DocumentService documentService = DocumentService();

    final ApiResModel res = await documentService.updateDocument(
      estructuraupdate,
      tokenUser,
      consecutivo,
    );

    return res;
  }

  getDocumentoEstructura(
    BuildContext context,
    int indexOrder,
  ) {
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

    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    //usuario token y cadena de conexion
    String user = loginVM.user;
    int tipoDocumento = menuVM.documento!;
    String serieDocumento = homeResVM.serieSelect!.serieDocumento!;
    int empresa = localVM.selectedEmpresa!.empresa;
    int estacion = localVM.selectedEstacion!.estacionTrabajo;

    double traTotal = 0;
    final List<DocTransaccion> transactions = [];

    // Generar dos números aleatorios de 7 dígitos cada uno
    var random = Random();

    int firstPart = 0;

    if (orderVM.orders[indexOrder].consecutivoRef != 0) {
      firstPart = orderVM.orders[indexOrder].consecutivoRef;
    } else {
      firstPart = random.nextInt(10000000);
    }

    int consecutivo = 1;

    //Buscar transacciones que van a comandarse
    for (var tra in orderVM.orders[indexOrder].transacciones) {
      if (tra.processed) {
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

    return DocEstructuraModel(
      docComanda: orderVM.orders[indexOrder].nombre,
      docFechaFin: null,
      docFechaIni: null,
      docRefDescripcion: null,
      docRefFechaFin: null,
      docRefFechaIni: null,
      docRefObservacion2: null,
      docRefObservacion3: null,
      docRefObservacion: null,
      docRefTipoReferencia: null,
      docMesa: orderVM.orders[indexOrder].mesa.elementoAsignado,
      docUbicacion: orderVM.orders[indexOrder].ubicacion.elementoAsignado,
      docLatitdud: null,
      docLongitud: null,
      consecutivoInterno: firstPart,
      docTraMonto: traTotal,
      docCaMonto: 0,
      docCuentaVendedor: orderVM.orders[indexOrder].mesero
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

  addTraToDoc(BuildContext context, List<TraRestaurantModel> transacciones) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    for (var i = 0; i < transacciones.length; i++) {
      final transaction = transacciones[i];

      //si la transacion esta seleccioonada
      if (transaction.selected) {
        //agreagr la transaccion a la nueva cueeta, eliminarla y recursividad
        orderVM.orders[indexOrderDest].transacciones.add(transaction);
        orderVM.orders[indexOrderOrigin].transacciones.removeAt(i);

        addTraToDoc(context, orderVM.orders[indexOrderOrigin].transacciones);

        break;
      }
    }
  }
}
