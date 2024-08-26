// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ConvertDocViewModel extends ChangeNotifier {
  //llave global del scaffold
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  //Documento origen
  OriginDocModel? docOriginSelect;

  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Seleccionar transacciones para autorizar
  bool _selectAllTra = false;
  bool get selectAllTra => _selectAllTra;

  set selectAllTra(bool value) {
    _selectAllTra = value;

    //Contador de transacciones no seleccionada
    int cont = 0;

    for (var element in detailsOrigin) {
      if (element.detalle.disponible == 0) {
        //no seleccionar si no hay cantidad disponible
        cont++;
      } else {
        //Seleccionar
        element.checked = _selectAllTra;
      }
    }

    //mensaje si no se seleccioanron transacciones
    if (cont != 0 && _selectAllTra) {
      NotificationService.showSnackbar(
        AppLocalizations.of(scaffoldKey.currentContext!)!.translate(
          BlockTranslate.notificacion,
          'enCeroNoSelec',
        ),
      );
    }

    notifyListeners();
  }

  //Detalles del documeto origen
  final List<OriginDetailInterModel> detalles = [];
  //Detalles dle docuemtno origen
  List<DetailOriginDocInterModel> detailsOrigin = [];

  //Input para la cantidad que se autoriza
  String textoInput = "";

  //Cargar datos importantes
  Future<void> loadData(BuildContext context, OriginDocModel docOrigin) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    //datos de la sesion
    final String token = loginVM.token;
    final String user = loginVM.user;

    //Recivicio que se va a utilizar
    final ReceptionService receptionService = ReceptionService();

    //Limpiar detalles del documento que haya previamente
    detalles.clear();

    //si estan seleccioandos todos
    selectAllTra = false;

    //iniciar proceso
    isLoading = true;

    //connsummo del servicio para obtener detalles
    final ApiResModel res = await receptionService.getDetallesDocOrigen(
      token, // token,
      user, // user,
      docOrigin.documento, // documento,
      docOrigin.tipoDocumento, // tipoDocumento,
      docOrigin.serieDocumento, // serieDocumento,
      docOrigin.empresa, // epresa,
      docOrigin.localizacion, // localizacion,
      docOrigin.estacionTrabajo, // estacion,
      docOrigin.fechaReg, // fechaReg,
    );

    //detener  la carga
    isLoading = false;

    //si el consumo salió mal
    if (!res.succes) {
      NotificationService.showErrorView(
        context,
        res,
      );

      return;
    }

    //Asiganr detalles encontrados
    List<OriginDetailModel> details = res.response;

    detailsOrigin.clear();

    //Recorrer todos los detalles para crear una nueva lista
    // Crear nuevos objetos para los detalles para poder seleccionarlos
    for (var element in details) {
      detailsOrigin.add(
        DetailOriginDocInterModel(
          checked: false,
          detalle: element,
          disponibleMod: element.disponible,
        ),
      );
    }

    // for (var element in details) {
    //   //Detalles
    //   detalles.add(
    //     //Nuevo objeto con datos para el control interno
    //     OriginDetailInterModel(
    //       consecutivoInterno: element.consecutivoInterno,
    //       disponible: element.disponible,
    //       clase: element.clase,
    //       marca: element.marca,
    //       id: element.id,
    //       producto: element.producto,
    //       bodega: element.bodega,
    //       cantidad: element.cantidad,
    //       disponibleMod: element.disponible,
    //       checked: false,
    //     ),
    //   );
    // }
  }

  //seleccioanr una transaccion
  selectTra(
    BuildContext context,
    int index, //indice seleccioando
    bool value, //valor asignado
  ) {
    //si la transaccion no tioene cantidad siponoble no se selecciona
    if (detailsOrigin[index].detalle.disponible == 0) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'noMarcarSiEsCero',
        ),
      );
      return;
    }

    //selccioanr transaccion
    detailsOrigin[index].checked = value;
    notifyListeners();
  }

  //modificar monto que se autoriza
  modificarDisponible(
    BuildContext context,
    int index,
  ) {
    //monto numerico
    double monto = 0;

    //convertir string a numero
    if (double.tryParse(textoInput) == null) {
      //si el input es nulo o vacio agregar 0
      monto = 0;
    } else {
      monto = double.parse(textoInput); //parse string to double
    }

    //si el monto es menor o igual a 0 mostrar mensaje
    if (monto <= 0) {
      Navigator.of(context).pop(); // Cierra el diálogo

      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'noCero',
        ),
      );
      return;
    }

    //si el mmonto es mayor a la cantidad disponible
    if (monto > detalles[index].disponible) {
      Navigator.of(context).pop(); // Cierra el diálogo

      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'noMayorADisponible',
        ),
      );
      return;
    }

    //Asiganr nuevo monto modificado
    detalles[index].disponibleMod = monto;
    //seleciconar transaccion
    selectTra(context, index, true);

    Navigator.of(context).pop(); // Cierra el diálogo

    notifyListeners();
  }

  //Conversion de transacciones
  Future<void> convertirDocumento(
    BuildContext context,
    OriginDocModel origen, //docuento origen
    DestinationDocModel destino, //documento destino
  ) async {
    //Buscar transacciones seleccioandas
    List<OriginDetailInterModel> elementosCheckTrue =
        detalles.where((elemento) => elemento.checked).toList();

    //si no hay transacciones seleccionadas
    if (elementosCheckTrue.isEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'seleccionaTrans',
        ),
      );
      return;
    }

    //mostrar dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'confirmar',
            ),
            description: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'confirmarTransaccion',
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

    if (!result) return;

    //datos externos de la sesion
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.user;

    //servicio que se va a utilizar
    final ReceptionService receptionService = ReceptionService();

    //iniiar pantalla de carga
    isLoading = true;

    //Recorrer transacciones seleccionadas
    for (var element in elementosCheckTrue) {
      //Autorizar cantidad
      final ApiResModel resUpdate = await receptionService.postActualizar(
        user,
        token,
        element.consecutivoInterno, // consecutivo,
        element.disponibleMod, // cantidad,
      );

      //si el consumo salió mal
      if (!resUpdate.succes) {
        isLoading = false;

        NotificationService.showErrorView(
          context,
          resUpdate,
        );

        return;
      }
    }

    //Iniciar proceso de conversion

    //parametros para la conversion
    final ParamConvertDocModel param = ParamConvertDocModel(
      pUserName: user,
      pODocumento: origen.documento,
      pOTipoDocumento: origen.tipoDocumento,
      pOSerieDocumento: origen.serieDocumento,
      pOEmpresa: origen.empresa,
      pOEstacionTrabajo: origen.estacionTrabajo,
      pOFechaReg: origen.fechaReg,
      pDTipoDocumento: destino.fTipoDocumento,
      pDSerieDocumento: destino.fSerieDocumento,
      pDEmpresa: origen.empresa,
      pDEstacionTrabajo: origen.estacionTrabajo,
    );

    //Consumo del api para convertir
    final ApiResModel resConvert = await receptionService.postConvertir(
      token,
      param,
    );

    //si el consumo salió mal
    if (!resConvert.succes) {
      isLoading = false;

      NotificationService.showErrorView(
        context,
        resConvert,
      );

      return;
    }

    //Respuesta docummento destino procesado
    DocConvertModel objDest = resConvert.response;

    // volver a cargar datos
    await loadData(context, origen);

    //Documento encontrado
    final DocDestinationModel doc = DocDestinationModel(
      tipoDocumento: destino.fTipoDocumento,
      desTipoDocumento: destino.documento,
      serie: destino.fSerieDocumento,
      desSerie: destino.serie,
      data: objDest,
    );

    //Proveedor de datos externo
    final vmDetailsDestVM = Provider.of<DetailsDestinationDocViewModel>(
      context,
      listen: false,
    );

    //Cargar detalles del documento encontrado
    await vmDetailsDestVM.loadData(context, doc);

    //navegar a pantalla para visualizar detalles
    Navigator.pushNamed(
      context,
      AppRoutes.detailsDestinationDoc,
      arguments: doc,
    );

    //Detener proceso
    isLoading = false;
  }

  int tipoDocEdit = 0;
  String serieDocEdit = "";
  String descSerieDocEdit = "";
  int empresaDocEdit = 0;
  int estacionDocEdit = 0;

  ClientModel? cliente;

  editarDocumento(
    BuildContext context,
    OriginDocModel originalDoc,
  ) async {
    isLoading = true;

    //View models externos
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final vmPayment = Provider.of<PaymentViewModel>(
      context,
      listen: false,
    );

    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );

    final vmDoc = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

    vmFactura.editDoc = true;

    // final String user = vmLogin.user;
    final String token = vmLogin.token;

    //Navegar a POS

    //Tipo del documento
    tipoDocEdit = originalDoc.tipoDocumento;
    serieDocEdit = originalDoc.serieDocumento;
    empresaDocEdit = originalDoc.empresa;
    descSerieDocEdit = originalDoc.serie;
    estacionDocEdit = originalDoc.estacionTrabajo;

    //asignar valores

    vmDoc.serieSelect?.serieDocumento = serieDocEdit;

    cliente = ClientModel(
      cuentaCorrentista: originalDoc.cuentaCorrentista,
      cuentaCta: originalDoc.cuentaCta,
      facturaNombre: originalDoc.cliente,
      facturaNit: originalDoc.nit,
      facturaDireccion: originalDoc.direccion,
      cCDireccion: null,
      desCuentaCta: "",
      direccion1CuentaCta: null,
      eMail: null,
      telefono: null,
      permitirCxC: false,
      limiteCredito: 0,
      celular: null,
      desGrupoCuenta: null,
      grupoCuenta: 0,
    );

    vmDoc.clienteSelect = cliente;

    //Si la cuenta es Consumidor Final activar el swich
    if (vmDoc.clienteSelect?.facturaNit.toLowerCase() == "c/f") {
      vmDoc.cf = true;
    }

    //instancia del servicio
    PagoService pagoService = PagoService();

    //Consumo del servicio
    ApiResModel resPayments = await pagoService.getFormas(
      tipoDocEdit, // doc,
      serieDocEdit, // serie,
      empresaDocEdit, // empresa,
      token, // token,
    );

    //valid succes response
    if (!resPayments.succes) {
      //si algo salio mal mostrar alerta
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resPayments,
      );
      return;
    }

    //agregar formas de pago encontradas
    vmPayment.paymentList.addAll(resPayments.response);

    if (vmPayment.paymentList.isEmpty) {
      Navigator.pushNamed(context, AppRoutes.withoutPayment);
      isLoading = false;

      return;
    }

    Navigator.pushNamed(context, AppRoutes.withPayment);
    //-----------------------------------
    //Detener carga
    isLoading = false;
    return;
  }

  editarNewDocumento(
    BuildContext context,
    OriginDocModel originalDoc,
  ) async {
    docOriginSelect = originalDoc;

    //llamar a load data

    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );

    final vmDocumento = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

    final detalleVM = Provider.of<DetailsViewModel>(
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

    final confimlVM = Provider.of<ConfirmDocViewModel>(
      context,
      listen: false,
    );

    //Datos necesarios
    int empresa = localVM.selectedEmpresa!.empresa;
    int estacion = localVM.selectedEstacion!.estacionTrabajo;
    String user = loginVM.user;
    String token = loginVM.token;

    vmFactura.editDoc = true;

    isLoading = true;

    await vmFactura.loadNewData(
      context,
      0,
    );

    //Cargar datos del docuemnto origen

    //si la referencia es distinta de null
    if (docOriginSelect!.tipoReferencia != null) {
      int existRef = -1;

      //recorrer lista de vendedores
      for (int i = 0; i < vmDocumento.referencias.length; i++) {
        TipoReferenciaModel element = vmDocumento.referencias[i];
        if (element.tipoReferencia == docOriginSelect!.tipoReferencia) {
          existRef = i;
          break;
        }
      }

      //No se encontró la referencia
      if (existRef == -1) {
        //Traducir
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'tipoRefNoEncontrado',
          ),
        );
      } else {
        //Guardar la referencia
        vmDocumento.referenciaSelect = vmDocumento.referencias[existRef];
      }
    }

    //si la lista de vendedores no está vacia
    if (vmDocumento.cuentasCorrentistasRef.isNotEmpty) {
      int existCuentaRef = -1;

      for (int i = 0; i < vmDocumento.cuentasCorrentistasRef.length; i++) {
        SellerModel element = vmDocumento.cuentasCorrentistasRef[i];
        if (element.cuentaCorrentista == docOriginSelect!.cuentaCorrentista) {
          existCuentaRef = i;
          break;
        }
      }

      if (existCuentaRef == -1) {
        //Traducir
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'cuentaNoEncontrada',
          ),
        );
      } else {
        //Guardar el vendedor
        vmDocumento.vendedorSelect =
            vmDocumento.cuentasCorrentistasRef[existCuentaRef];
      }
    }

    //Servicios
    CuentaService cuentaService = CuentaService();

    //--EMpiezan datos
    //Cargar cliente
    ApiResModel resClient = await cuentaService.getCuentaCorrentista(
      empresa,
      docOriginSelect!.nit,
      user,
      token,
    );

    //si algo salio mal
    if (!resClient.succes) {
      isLoading = false;

      NotificationService.showErrorView(
        context,
        resClient,
      );

      return;
    }

    //Buscar cliente y asiganrlo
    List<ClientModel> clients = resClient.response;

    int existClient = -1;

    for (int i = 0; i < clients.length; i++) {
      ClientModel element = clients[i];
      if (element.cuentaCorrentista == docOriginSelect!.cuentaCorrentista) {
        existClient = i;
        break;
      }
    }

    if (existClient == -1) {
      vmDocumento.clienteSelect = ClientModel(
        cuentaCorrentista: 1,
        cuentaCta: docOriginSelect!.cuentaCta,
        facturaNombre: docOriginSelect!.cliente,
        facturaNit: docOriginSelect!.nit,
        facturaDireccion: docOriginSelect!.direccion,
        cCDireccion: docOriginSelect!,
        desCuentaCta: docOriginSelect!.nit,
        direccion1CuentaCta: docOriginSelect!.direccion,
        eMail: "",
        telefono: "",
        permitirCxC: false,
        limiteCredito: 0,
        celular: null,
        desGrupoCuenta: null,
        grupoCuenta: 0,
      );
    } else {
      vmDocumento.clienteSelect = clients[existClient];
    }

    DateTime dateDefault = DateTime.now();

    //load dates
    vmDocumento.fechaRefIni =
        docOriginSelect!.referenciaDFechaIni ?? dateDefault;
    vmDocumento.fechaRefFin =
        docOriginSelect!.referenciaDFechaFin ?? dateDefault;
    vmDocumento.fechaInicial = docOriginSelect!.fechaIni ?? dateDefault;
    vmDocumento.fechaFinal = docOriginSelect!.fechaFin ?? dateDefault;

    //Observaciones
    String refContactoParam385 = docOriginSelect!.referenciaDObservacion2 ?? "";
    String refDescripcionParam383 =
        docOriginSelect!.referenciaDDescripcion ?? "";
    String refDirecEntregaParam386 =
        docOriginSelect!.referenciaDObservacion3 ?? "";
    String refObservacionParam384 =
        docOriginSelect!.referenciaDObservacion ?? "";
    String observacion = docOriginSelect!.observacion1 ?? "";

    //Asignar observaciones
    vmDocumento.refContactoParam385.text = refContactoParam385;
    vmDocumento.refDescripcionParam383.text = refDescripcionParam383;
    vmDocumento.refDirecEntregaParam386.text = refDirecEntregaParam386;
    vmDocumento.refObservacionParam384.text = refObservacionParam384;
    confimlVM.observacion.text = observacion;

//___________________________________

    for (var tra in detailsOrigin) {
      //instacia del servicio
      ProductService productService = ProductService();

      ApiResModel resProduct = await productService.getProduct(
        tra.detalle.id,
        token,
      );

      if (!resProduct.succes) {
        isLoading = false;

        NotificationService.showErrorView(
          context,
          resProduct,
        );

        return;
      }

      List<ProductModel> productSearch = resProduct.response;

      int iProd = -1;

      for (int i = 0; i < productSearch.length; i++) {
        ProductModel element = productSearch[i];

        if (element.productoId == tra.detalle.id) {
          iProd = i;
          break;
        }
      } //fin for

      if (iProd == -1) {
        isLoading = false;

        resProduct.response =
            "Error al cargar las transacciones, no se encontró un producto";

        NotificationService.showErrorView(
          context,
          resProduct,
        );

        return;
      }

      ProductModel prod = productSearch[iProd];

      //buscar bodegas del producto
      ApiResModel resBodega = await productService.getBodegaProducto(
        user,
        empresa,
        estacion,
        prod.producto,
        prod.unidadMedida,
        token,
      );

      if (!resBodega.succes) {
        isLoading = false;

        NotificationService.showErrorView(
          context,
          resBodega,
        );

        return;
      }

      List<BodegaProductoModel> bodegas = resBodega.response;

      int existBodega = -1;

      //Search bodega
      for (int i = 0; i < bodegas.length; i++) {
        BodegaProductoModel element = bodegas[i];
        if (element.bodega == tra.detalle.bodega) {
          existBodega = i;
          break;
        }
      }

      BodegaProductoModel bodega;

      if (existBodega == -1) {
        //No hay bodegas
        bodega = BodegaProductoModel(
          bodega: tra.detalle.bodega,
          existencia: 0,
          nombre: tra.detalle.bodegaDescripcion,
          poseeComponente: false,
        );
      } else {
        //Asignar la bodega
        bodega = bodegas[existBodega];
      }

      //buscar precios
      ApiResModel resPrecio = await productService.getPrecios(
        bodega.bodega,
        prod.producto,
        prod.unidadMedida,
        user,
        token,
        vmDocumento.clienteSelect?.cuentaCorrentista ?? 0,
        vmDocumento.clienteSelect?.cuentaCta ?? "0",
      );

      if (!resPrecio.succes) {
        isLoading = false;

        NotificationService.showErrorView(
          context,
          resPrecio,
        );

        return;
      }

      List<PrecioModel> precios = resPrecio.response;

      int existPrecio = -1;

      for (int i = 0; i < precios.length; i++) {
        PrecioModel element = precios[i];
        if (element.tipoPrecio == tra.detalle.tipoPrecio) {
          existPrecio = i;
          break;
        }
      }

      UnitarioModel precioSelect;

      if (existPrecio == -1) {
        //Seacrh factor de conversion

        precioSelect = UnitarioModel(
          descripcion: "Precio",
          id: tra.detalle.tipoPrecio,
          moneda: 1,
          orden: 1,
          precio: true,
          precioU: tra.detalle.disponible > 0
              ? 0
              : tra.detalle.monto / tra.detalle.disponible,
        );
      } else {
        precioSelect = UnitarioModel(
          descripcion: precios[existPrecio].desTipoPrecio,
          id: precios[existPrecio].tipoPrecio,
          moneda: precios[existPrecio].moneda,
          orden: precios[existPrecio].precioOrden,
          precio: true,
          precioU: precios[existPrecio].precioUnidad,
        );
      }

      double precioDias = 0;
      int cantidadDias = 0;

      if (vmDocumento.valueParametro(351)) {
        ApiResModel resFormulaPrecio = await productService.getFormulaPrecioU(
          token,
          vmDocumento.fechaInicial,
          vmDocumento.fechaFinal,
          precioSelect.precioU.toString(),
        );

        if (!resFormulaPrecio.succes) {
          //Traducir
          NotificationService.showSnackbar(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'noCalculoDias',
            ),
          );

          NotificationService.showErrorView(
            context,
            resFormulaPrecio,
          );

          return;
        }

        List<PrecioDiaModel> calculoDias = resFormulaPrecio.response;

        if (calculoDias.isEmpty) {
          resFormulaPrecio.response =
              "No se pudo obtener los resultados al hacer el calculo de precio por dias, verifica el procedimeinto.";

          //Traducir
          NotificationService.showSnackbar(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'noCalculoDias',
            ),
          );

          NotificationService.showErrorView(
            context,
            resFormulaPrecio,
          );

          return;
        }

        precioDias = calculoDias[0].montoCalculado;
        cantidadDias = calculoDias[0].cantidadDia;
      }

      //Agregar las transacciones

      detalleVM.traInternas.add(
        //Agregar montos por dia

        TraInternaModel(
          consecutivo: tra.detalle.transaccionConsecutivoInterno,
          estadoTra: 0,
          precioCantidad: precioSelect.precioU * tra.detalle.disponible,
          precioDia: precioDias,
          isChecked: false,
          bodega: bodega,
          producto: prod,
          precio: precioSelect,
          cantidad: tra.detalle.disponible.toInt(),
          total: tra.detalle.monto,
          cargo: 0,
          cantidadDias: cantidadDias,
          descuento: 0,
          operaciones: [],
        ),
      );
    } //Fin For

    //limpiar transacciones pendientes
    detalleVM.transaccionesPorEliminar.clear();

    isLoading = false;
  }
}
