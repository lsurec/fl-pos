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
    //llamar a load data

    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );

    final vmDocumento = Provider.of<DocumentViewModel>(
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
    // int estacion = localVM.selectedEstacion!.estacionTrabajo;
    String user = loginVM.user;
    String token = loginVM.token;

    vmFactura.editDoc = true;

    isLoading = true;

    await vmFactura.loadNewData(
      context,
      0,
    );

    //Cargar datos del docuemnto origen

    OriginDocModel docOrigin = originalDoc;

    int existRef = -1;

    for (int i = 0; i < vmDocumento.referencias.length; i++) {
      TipoReferenciaModel element = vmDocumento.referencias[i];
      if (element.tipoReferencia == docOrigin.tipoReferencia) {
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

    int existCuentaRef = -1;

    for (int i = 0; i < vmDocumento.cuentasCorrentistasRef.length; i++) {
      SellerModel element = vmDocumento.cuentasCorrentistasRef[i];
      if (element.cuentaCorrentista == docOrigin.cuentaCorrentista) {
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

    //Servicios
    CuentaService cuentaService = CuentaService();

    //--EMpiezan datos
    //Cargar cliente
    ApiResModel resClient = await cuentaService.getCuentaCorrentista(
      empresa,
      docOrigin.nit,
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
      if (element.cuentaCorrentista == docOrigin.cuentaCorrentista) {
        existClient = i;
        break;
      }
    }

    if (existClient == -1) {
      vmDocumento.clienteSelect = ClientModel(
        cuentaCorrentista: 1,
        cuentaCta: docOrigin.cuentaCta,
        facturaNombre: docOrigin.cliente,
        facturaNit: docOrigin.nit,
        facturaDireccion: docOrigin.direccion,
        cCDireccion: docOrigin,
        desCuentaCta: docOrigin.nit,
        direccion1CuentaCta: docOrigin.direccion,
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
    vmDocumento.fechaRefIni = docOrigin.referenciaDFechaIni ?? dateDefault;
    vmDocumento.fechaRefFin = docOrigin.referenciaDFechaFin ?? dateDefault;
    vmDocumento.fechaInicial = docOrigin.fechaIni ?? dateDefault;
    vmDocumento.fechaFinal = docOrigin.fechaFin ?? dateDefault;

    //Observaciones
    String refContactoParam385 = docOrigin.referenciaDObservacion2 ?? "";
    String refDescripcionParam383 = docOrigin.referenciaDDescripcion ?? "";
    String refDirecEntregaParam386 = docOrigin.referenciaDObservacion3 ?? "";
    String refObservacionParam384 = docOrigin.referenciaDObservacion ?? "";
    String observacion = docOrigin.observacion1 ?? "";

    //Asignar observaciones
    vmDocumento.refContactoParam385.text = refContactoParam385;
    vmDocumento.refDescripcionParam383.text = refDescripcionParam383;
    vmDocumento.refDirecEntregaParam386.text = refDirecEntregaParam386;
    vmDocumento.refObservacionParam384.text = refObservacionParam384;
    confimlVM.observacion.text = observacion;

//___________________________________

    isLoading = false;
  }
}
