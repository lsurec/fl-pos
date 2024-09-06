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
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentoViewModel extends ChangeNotifier {
  //control del proceso
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool editDoc = false;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  late TabController tabController;

  List<String> terminosyCondiciones = [
    "Esta Cotización no es reservación.",
    "Al confirmar su cotización se requiere de contrato firmado.",
    "Los precios cotizados están sujetos a cambios.",
    "Se cobrara Q 125.00 por cheque rechazado por cargos administrativos.",
    "Se solicitara cheque de garantía.",
    "Se cobrará por daños al mobiliario y equipo según contrato.",
  ];

  List<String> copiaTerminosyCondiciones = [
    "Esta Cotización no es reservación.",
    "Al confirmar su cotización se requiere de contrato firmado.",
    "Los precios cotizados están sujetos a cambios.",
    "Se cobrara Q 125.00 por cheque rechazado por cargos administrativos.",
    "Se solicitara cheque de garantía.",
    "Se cobrará por daños al mobiliario y equipo según contrato.",
  ];

  //Regresar a la pantalla anterior y limpiar
  Future<bool> back(BuildContext context) async {
    setValuesNewDoc(context);
    final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);
    //al momento de regresar de editar documento pasa a falso para que cuando vuelva
    //al modulo del pos pueda recuperar el documento que tenia pendiente de confirmar
    if (vmFactura.editDoc) {
      vmFactura.editDoc = false;
    }

    return true;
  }

  //nuevo documento
  Future<void> newDocument(BuildContext context) async {
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

    if (!result) return;

    setValuesNewDoc(context);
  }

  Future<bool> backTabs(BuildContext context) async {
    final vmConfirm = Provider.of<ConfirmDocViewModel>(context, listen: false);

    final vmPayment = Provider.of<PaymentViewModel>(
      context,
      listen: false,
    );

    if (!vmConfirm.showPrint) return true;

    setValuesNewDoc(context);

    if (vmPayment.paymentList.isEmpty) {
      Navigator.popUntil(
          context, ModalRoute.withName(AppRoutes.withoutPayment));

      return false;
    }

    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.withPayment));
    return false;
  }

  setValuesNewDoc(BuildContext context) {
    //view models externos
    final documentVM = Provider.of<DocumentViewModel>(context, listen: false);
    final detailsVM = Provider.of<DetailsViewModel>(context, listen: false);
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    final confirmVM = Provider.of<ConfirmDocViewModel>(context, listen: false);
    final vmConfirm = Provider.of<ConfirmDocViewModel>(context, listen: false);

    //limpiar pantalla documento
    documentVM.clearView();
    detailsVM.clearView(context);
    paymentVM.clearView(context);
    confirmVM.newDoc();

    vmConfirm.setIdDocumentoRef();
    terminosyCondiciones.clear();
    terminosyCondiciones.addAll(copiaTerminosyCondiciones);

    // Cambiar al primer tab al presionar el botón
    tabController.animateTo(0); // Cambiar al primer tab (índice 0)
  }

  //confirmar documento
  void sendDocumnet(
    BuildContext context,
    int screen,
  ) {
    //View models externos
    final documentVM = Provider.of<DocumentViewModel>(context, listen: false);
    final detailsVM = Provider.of<DetailsViewModel>(context, listen: false);
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    final menuVM = Provider.of<MenuViewModel>(context, listen: false);

    //Si no hay serie seleccionado mostrar mensaje
    if (documentVM.serieSelect == null) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinSerie',
        ),
      );
      return;
    }

    //Si no hay cliente seleccioando mostrar mensaje
    if (documentVM.clienteSelect == null) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinCliente',
        ),
      );
      return;
    }

    //si hay vendedores debe seleconarse uno
    if (documentVM.cuentasCorrentistasRef.isNotEmpty) {
      //si hay vendedor seleccionado mostrar mensaje
      if (documentVM.vendedorSelect == null) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'sinVendedor',
          ),
        );
        return;
      }
    }

    //verificar el tipo de referencia
    if (documentVM.valueParametro(58)) {
      if (documentVM.referenciaSelect == null) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'seleccioneTipoRef',
          ),
        );
        return;
      }
    }

    //verificar las fechas
    if (documentVM.valueParametro(44)) {
      if (!documentVM.validateDates()) {
        //Mostrar los mensajes indicando cual es la fecha incorrecta
        documentVM.notificacionFechas(context);
        return;
      }
    }

    //si no hay transacciones mostrar mensaje
    if (detailsVM.traInternas.isEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinTransacciones',
        ),
      );
      return;
    }

    //si hay formas de pago validar quye se agregue alguna

    if (paymentVM.paymentList.isNotEmpty) {
      //si no hay pagos agregados mostar mensaje
      if (paymentVM.amounts.isEmpty) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'sinPago',
          ),
        );
        return;
      }

      // si no se ha pagado el total mostrar mensaje
      if (paymentVM.saldo != 0) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'saldoPendiente',
          ),
        );
        return;
      }
    }

    //si el documento es cotizacion, consultar
    if (menuVM.documento == 20) {
      //Mostrar dialogo
      editTerms(
        context,
        screen,
      );
      return;
    }

    final vmConfirm = Provider.of<ConfirmDocViewModel>(context, listen: false);

    //Obtener latitude y longitud Si es necesario
    if (documentVM.getPosition()) {
      vmConfirm.setPosition();
    }

    //si todas las validaciones son correctas navegar a resumen del documento
    Navigator.pushNamed(
      context,
      "confirm",
      arguments: screen, //1 documento; 2 comanda
    );
  }

  //cargar datos necesarios
  Future<void> loadData(BuildContext context) async {
    //view model externo
    final vmDocument = Provider.of<DocumentViewModel>(context, listen: false);
    final vmPayment = Provider.of<PaymentViewModel>(context, listen: false);
    final vmMenu = Provider.of<MenuViewModel>(context, listen: false);

    if (vmMenu.documento == null) return;

    vmDocument.referencias.clear();
    vmDocument.cuentasCorrentistasRef.clear();

    //iniciar proceso
    isLoading = true;

    //cargar series
    await vmDocument.loadSeries(context, vmMenu.documento!);

    // si hay solo una serie buscar vendedores
    if (vmDocument.series.length == 1) {
      await vmDocument.loadSellers(
        context,
        vmDocument.series.first.serieDocumento!,
        vmMenu.documento!,
      );
      await vmDocument.loadTipoTransaccion(context);
      await vmDocument.loadParametros(context);
      await vmDocument.obtenerReferencias(context); //cargar referencias
    }

    await vmPayment.loadPayments(context);

    //limpiar la prefenncia del documentio
    Preferences.clearDocument();

    //finalizar proceso
    isLoading = false;
  }

  Future<void> loadNewData(
    BuildContext context,
    int opcion,
  ) async {
    //view model externo
    final vmMenu = Provider.of<MenuViewModel>(
      context,
      listen: false,
    );

    final vmPayment = Provider.of<PaymentViewModel>(
      context,
      listen: false,
    );

    final vmDoc = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final vmLocal = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    // final vmFactura = Provider.of<DocumentoViewModel>(
    //   context,
    //   listen: false,
    // );

    final vmConvert = Provider.of<ConvertDocViewModel>(
      context,
      listen: false,
    );

    final int empresa = vmLocal.selectedEmpresa!.empresa;
    final int estacion = vmLocal.selectedEstacion!.estacionTrabajo;
    final String user = vmLogin.user;
    final String token = vmLogin.token;

    //Verificar que extsa tipo de documento
    if (vmMenu.documento == null) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinDocumento',
        ),
      );
      return;
    }

    isLoading = true;
    //Load data

    TipoCambioService tipoCambioService = TipoCambioService();

    final ApiResModel resCambio = await tipoCambioService.getTipoCambio(
      empresa,
      user,
      token,
    );

    if (!resCambio.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resCambio);
      return;
    }

    final List<TipoCambioModel> cambios = resCambio.response;

    if (cambios.isNotEmpty) {
      vmMenu.tipoCambio = cambios[0].tipoCambio;
    } else {
      isLoading = false;

      resCambio.response = AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'sinTipoCambio',
      );

      NotificationService.showErrorView(context, resCambio);

      return;
    }

    //limpiar serie seleccionada
    vmDoc.serieSelect = null;
    //simpiar lista serie
    vmDoc.series.clear();

    terminosyCondiciones.clear();
    terminosyCondiciones.addAll(copiaTerminosyCondiciones);

    //instancia del servicio
    SerieService serieService = SerieService();

    //consumo del api
    ApiResModel resSeries = await serieService.getSerie(
      vmMenu.documento!, // documento,
      empresa, // empresa,
      estacion, // estacion,
      user, // user,
      token, // token,
    );

    //valid succes response
    if (!resSeries.succes) {
      //si algo salio mal mostrar alerta
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resSeries,
      );
      return;
    }

    //Agregar series encontradas
    vmDoc.series.addAll(resSeries.response);

    // si sololo hay una serie seleccionarla por defecto
    if (vmDoc.series.length == 1) {
      vmDoc.serieSelect = vmDoc.series.first;
    }

    //verificar que exista una serie
    if (editDoc) {
      OriginDocModel docOriginSlect = vmConvert.docOriginSelect!;

      for (int i = 0; i < vmDoc.series.length; i++) {
        SerieModel element = vmDoc.series[i];
        if (docOriginSlect.serieDocumento == element.serieDocumento) {
          vmDoc.serieSelect = element;
          break;
        }
      }
    }

    // si hay solo una serie buscar vendedores
    if (vmDoc.serieSelect != null) {
      //limpiar vendedor seleccionado
      vmDoc.vendedorSelect = null;

      //limmpiar lista vendedor
      vmDoc.cuentasCorrentistasRef.clear();

      //instancia del servicio
      CuentaService cuentaService = CuentaService();

      //Consummo del api
      ApiResModel resCuentRef = await cuentaService.getCeuntaCorrentistaRef(
        user, // user,
        vmMenu.documento!, // doc,
        vmDoc.serieSelect!.serieDocumento!, // serie,
        empresa, // empresa,
        token, // token,
      );

      //valid succes response
      if (!resCuentRef.succes) {
        //si algo salio mal mostrar alerta

        isLoading = false;
        await NotificationService.showErrorView(
          context,
          resCuentRef,
        );
        return;
      }

      //agregar vendedores
      vmDoc.cuentasCorrentistasRef.addAll(resCuentRef.response);

      //si solo hay un vendedor agregarlo por defecto
      if (vmDoc.cuentasCorrentistasRef.length == 1) {
        vmDoc.vendedorSelect = vmDoc.cuentasCorrentistasRef.first;
      }

      //instancia del servicio
      vmDoc.tiposTransaccion.clear();
      TipoTransaccionService tipoTransaccionService = TipoTransaccionService();

      //consumo del api
      ApiResModel resTiposTra = await tipoTransaccionService.getTipoTransaccion(
        vmMenu.documento!, // documento,
        vmDoc.serieSelect!.serieDocumento!, // serie,
        empresa, // empresa,
        token, // token,
        user, // user,
      );

      //valid succes response
      if (!resTiposTra.succes) {
        //si algo salio mal mostrar alerta
        isLoading = false;

        await NotificationService.showErrorView(
          context,
          resTiposTra,
        );
        return;
      }

      //Agregar series encontradas
      vmDoc.tiposTransaccion.addAll(resTiposTra.response);

      vmDoc.parametros.clear();

      ParametroService parametroService = ParametroService();

      ApiResModel resParams = await parametroService.getParametro(
        user,
        vmMenu.documento!,
        vmDoc.serieSelect!.serieDocumento!,
        empresa,
        estacion,
        token,
      );

      //valid succes response
      if (!resParams.succes) {
        //si algo salio mal mostrar alerta
        isLoading = false;

        await NotificationService.showErrorView(
          context,
          resParams,
        );
        return;
      }

      //Agregar series encontradas
      vmDoc.parametros.addAll(resParams.response);

      //evaluar el parametro 58
      TipoReferenciaService referenciaService = TipoReferenciaService();

      if (vmDoc.valueParametro(58)) {
        vmDoc.referencias.clear();
        vmDoc.referenciaSelect = null;

        //Consumo del servicio
        ApiResModel resTiposRef = await referenciaService.getTiposReferencia(
          user, //user
          token, // token,
        );

        //valid succes response
        if (!resTiposRef.succes) {
          //si algo salio mal mostrar alerta
          isLoading = false;

          await NotificationService.showErrorView(
            context,
            resTiposRef,
          );
          return;
        }

        //agregar formas de pago encontradas
        vmDoc.referencias.addAll(resTiposRef.response);

        if (editDoc) {
          OriginDocModel docOriginSlect = vmConvert.docOriginSelect!;

          for (int i = 0; i < vmDoc.referencias.length; i++) {
            TipoReferenciaModel element = vmDoc.referencias[i];
            if (docOriginSlect.tipoReferencia == element.tipoReferencia) {
              vmDoc.referenciaSelect = element;
              break;
            }
          }
        }
      }
    }

    //limpiar lista
    vmPayment.paymentList.clear();

    //si ahay varias series no se carga los pagos y no hay pagos
    if (vmDoc.serieSelect != null) {
      //instancia del servicio
      PagoService pagoService = PagoService();

      //Consumo del servicio
      ApiResModel resPayments = await pagoService.getFormas(
        vmMenu.documento!, // doc,
        vmDoc.serieSelect!.serieDocumento!, // serie,
        empresa, // empresa,
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
    }

    if (vmPayment.paymentList.isEmpty && opcion == 0) {
      Navigator.pushNamed(
        context,
        AppRoutes.withoutPayment,
      );
      isLoading = false;

      return;
    }

    if (vmPayment.paymentList.isNotEmpty && opcion == 0) {
      Navigator.pushNamed(
        context,
        AppRoutes.withPayment,
      );
      isLoading = false;
      return;
    }

    //limpiar la prefenncia del documentio
    if (opcion == 1) {
      Preferences.clearDocument();
      //Limpiar la cuenta
      // vmDoc.cf = false;
      // vmDoc.clienteSelect = null;
      // vmDetalle.traInternas.clear();
    }

    isLoading = false;
  }

  modifyDoc(
    BuildContext context,
  ) async {
    //View models
    final vmConvert = Provider.of<ConvertDocViewModel>(
      context,
      listen: false,
    );

    final vmMenu = Provider.of<MenuViewModel>(
      context,
      listen: false,
    );

    final vmDoc = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final vmConfirm = Provider.of<ConfirmDocViewModel>(
      context,
      listen: false,
    );

    final detalleVM = Provider.of<DetailsViewModel>(
      context,
      listen: false,
    );

    final String user = vmLogin.user;
    final String token = vmLogin.token;

    OriginDocModel docOriginSlect = vmConvert.docOriginSelect!;

    //verificar el tipo de referencia
    if (vmDoc.valueParametro(58)) {
      if (vmDoc.referenciaSelect == null) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'seleccioneTipoRef',
          ),
        );
        return;
      }
    }

    //verificar las fechas
    if (vmDoc.valueParametro(44)) {
      if (!vmDoc.validateDates()) {
        //Mostrar los mensajes indicando cual es la fecha incorrecta
        vmDoc.notificacionFechas(context);
        return;
      }
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
              'aplicaranCambios',
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

    // Suponiendo que fechaDocumento es de tipo String
    String fechaDocumento = docOriginSlect.fechaDocumento;

    // Divide la fecha en partes (día, mes, año)
    List<String> partesFecha = fechaDocumento.split('/');
    String dia = partesFecha[0];
    String mes = partesFecha[1];
    String anio = partesFecha[2];

    // Crea un objeto DateTime con el formato esperado ('YYYY-MM-DD')
    DateTime fechaFormateada = DateTime.parse('$anio-$mes-$dia');

    UpdateDocModel docModify = UpdateDocModel(
      consecutivoInterno: vmConvert.docOriginSelect!.consecutivoInterno,
      cuentaCorrentista: vmDoc.clienteSelect!.cuentaCorrentista,
      cuentaCorrentistaRef: vmDoc.vendedorSelect?.cuentaCorrentista,
      cuentaCuenta: vmDoc.clienteSelect!.cuentaCta,
      documentoDireccion: vmDoc.clienteSelect!.facturaDireccion,
      documentoNit: vmDoc.clienteSelect!.facturaNit,
      documentoNombre: vmDoc.clienteSelect!.facturaNombre,
      empresa: vmConvert.docOriginSelect!.empresa,
      estacionTrabajo: vmConvert.docOriginSelect!.estacionTrabajo,
      fechaDocumento: fechaFormateada,
      fechaFin: vmDoc.fechaFinal,
      fechaHora: DateTime.parse(vmConvert.docOriginSelect!.fechaHora),
      fechaIni: vmDoc.fechaInicial,
      idDocumento: vmConvert.docOriginSelect!.iDDocumento.toString(),
      localizacion: vmConvert.docOriginSelect!.localizacion,
      mUser: user,
      observacion: vmConfirm.observacion.text,
      referencia: vmConvert.docOriginSelect!.referencia ??
          vmDoc.referenciaSelect?.tipoReferencia,
      serieDocumento: vmConvert.docOriginSelect!.serieDocumento,
      tipoDocumento: vmConvert.docOriginSelect!.tipoDocumento,
      user: vmConvert.docOriginSelect!.usuario,
    );

    //TODO: Aqui ya no pasó! :(

//Migrar cotizaciones para que aparezcan enel listado de cotizaciones
//Mostrar el error

    ReceptionService receptionService = ReceptionService();

    ApiResModel resUpdateEncabezado = await receptionService.updateDoc(
      token,
      docModify,
    );

    if (!resUpdateEncabezado.succes) {
      isLoading = false;
      NotificationService.showErrorView(
        context,
        resUpdateEncabezado,
      );
      return;
    }

    UpdateRefModel refModify = UpdateRefModel(
      descripcion: vmDoc.refDescripcionParam383.text,
      empresa: vmConvert.docOriginSelect!.empresa,
      fechaFin: vmDoc.fechaRefFin,
      fechaIni: vmDoc.fechaRefIni,
      mUser: user,
      observacion: vmDoc.refObservacionParam384.text,
      observacion2: vmDoc.refContactoParam385.text,
      observacion3: vmDoc.refDirecEntregaParam386.text,
      referencia: vmConvert.docOriginSelect!.referencia!,
      referenciaID: '92144684365752', //TODO:Preguntar
      tipoReferencia: vmDoc.referenciaSelect?.tipoReferencia,
    );

    ApiResModel resRefUpdate = await receptionService.updateDocRef(
      token,
      refModify,
    );

    if (!resRefUpdate.succes) {
      isLoading = false;
      NotificationService.showErrorView(
        context,
        resRefUpdate,
      );
      return;
    }

    //eliminar transacciones
    for (TraInternaModel eliminar in detalleVM.transaccionesPorEliminar) {
      //

      NewTransactionModel transactionEliminar = NewTransactionModel(
        bodega: eliminar.bodega!.bodega,
        cantidad: eliminar.cantidad,
        documentoConsecutivoInterno:
            vmConvert.docOriginSelect!.consecutivoInterno,
        empresa: vmConvert.docOriginSelect!.empresa,
        estacionTrabajo: vmConvert.docOriginSelect!.estacionTrabajo,
        localizacion: vmConvert.docOriginSelect!.localizacion,
        moneda: eliminar.precio!.moneda,
        monto: eliminar.total,
        montoMoneda: eliminar.total / vmMenu.tipoCambio,
        producto: eliminar.producto.producto,
        tipoCambio: vmMenu.tipoCambio,
        tipoPrecio: eliminar.precio!.id,
        tipoTransaccion: vmConfirm.resolveTipoTransaccion(
          eliminar.producto.tipoProducto,
          context,
        ),
        transaccionConsecutivoInterno: eliminar.consecutivo,
        unidadMedida: eliminar.producto.unidadMedida,
        usuario: user,
      );

      ApiResModel resTransDelete = await receptionService.anularTransaccion(
        token,
        transactionEliminar,
      );

      if (!resTransDelete.succes) {
        isLoading = false;
        NotificationService.showErrorView(
          context,
          resTransDelete,
        );
        return;
      }
    } // fin for

    //limpiar lista de eliminados
    detalleVM.transaccionesPorEliminar.clear();

    int indexUpdate = 0;

    //Actualizar transacciones
    for (TraInternaModel actualizar in detalleVM.transaccionesPorEliminar) {
      //
      if (actualizar.estadoTra != 0 && actualizar.consecutivo != 0) {
        ///Anular y actualizar

        NewTransactionModel transactionActualizar = NewTransactionModel(
          bodega: actualizar.bodega!.bodega,
          cantidad: actualizar.cantidad,
          documentoConsecutivoInterno:
              vmConvert.docOriginSelect!.consecutivoInterno,
          empresa: vmConvert.docOriginSelect!.empresa,
          estacionTrabajo: vmConvert.docOriginSelect!.estacionTrabajo,
          localizacion: vmConvert.docOriginSelect!.localizacion,
          moneda: actualizar.precio!.moneda,
          monto: actualizar.total,
          montoMoneda: actualizar.total / vmMenu.tipoCambio,
          producto: actualizar.producto.producto,
          tipoCambio: vmMenu.tipoCambio,
          tipoPrecio: actualizar.precio!.id,
          tipoTransaccion: vmConfirm.resolveTipoTransaccion(
            actualizar.producto.tipoProducto,
            context,
          ),
          transaccionConsecutivoInterno: actualizar.consecutivo,
          unidadMedida: actualizar.producto.unidadMedida,
          usuario: user,
        );

        ApiResModel resTransDelete = await receptionService.anularTransaccion(
          token,
          transactionActualizar,
        );

        if (!resTransDelete.succes) {
          isLoading = false;
          NotificationService.showErrorView(
            context,
            resTransDelete,
          );
          return;
        }

        ApiResModel resActualizarTransaccion =
            await receptionService.insertarTransaccion(
          token,
          transactionActualizar,
        );

        if (!resActualizarTransaccion.succes) {
          isLoading = false;
          NotificationService.showErrorView(
            context,
            resActualizarTransaccion,
          );
          return;
        }

        detalleVM.traInternas[indexUpdate].consecutivo =
            resActualizarTransaccion.response;

        indexUpdate++;
      } //fin if
    } //fin for

    int indexInsert = 0;

    for (TraInternaModel nueva in detalleVM.transaccionesPorEliminar) {
      if (nueva.estadoTra != 0 && nueva.consecutivo != 0) {
        NewTransactionModel transactionNueva = NewTransactionModel(
          bodega: nueva.bodega!.bodega,
          cantidad: nueva.cantidad,
          documentoConsecutivoInterno:
              vmConvert.docOriginSelect!.consecutivoInterno,
          empresa: vmConvert.docOriginSelect!.empresa,
          estacionTrabajo: vmConvert.docOriginSelect!.estacionTrabajo,
          localizacion: vmConvert.docOriginSelect!.localizacion,
          moneda: nueva.precio!.moneda,
          monto: nueva.total,
          montoMoneda: nueva.total / vmMenu.tipoCambio,
          producto: nueva.producto.producto,
          tipoCambio: vmMenu.tipoCambio,
          tipoPrecio: nueva.precio!.id,
          tipoTransaccion: vmConfirm.resolveTipoTransaccion(
            nueva.producto.tipoProducto,
            context,
          ),
          transaccionConsecutivoInterno: nueva.consecutivo,
          unidadMedida: nueva.producto.unidadMedida,
          usuario: user,
        );

        ApiResModel resActualizarTransaccion =
            await receptionService.insertarTransaccion(
          token,
          transactionNueva,
        );

        if (!resActualizarTransaccion.succes) {
          isLoading = false;
          NotificationService.showErrorView(
            context,
            resActualizarTransaccion,
          );
          return;
        }

        detalleVM.traInternas[indexInsert].consecutivo =
            resActualizarTransaccion.response;

        indexInsert++;
      } //fin if
    } // fin for

    isLoading = false;

    NotificationService.showSnackbar(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'docEditado',
      ),
    );
  }

  //Cerrar sesion
  Future<void> editTerms(
    BuildContext context,
    int screen,
  ) async {
    //mostrar dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            textOk: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              "imprimir",
            ),
            textCancel: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              "modificar",
            ),
            title: "Modificar terminos y condiciones",
            description:
                "¿Desea modificar terminos y condiciones para este documento?. Podrá editar, eliminar y/o agregar terminos y condiciones.",
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;

    if (result) {
      //si todas las validaciones son correctas navegar a resumen del documento
      Navigator.pushNamed(
        context,
        AppRoutes.confirm,
        arguments: screen, //1 documento; 2 comanda
      );

      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.terms,
      arguments: screen, //1 documento; 2 comanda
    );
  }

  void editar(BuildContext context, int index) async {
    // Aquí asumimos que hay un método similar a _notificationsService.editTerm en Dart.
    // _notificationsService.editTerm(index);

    bool accion = await NotificationService.editTerm(
      context,
      index,
    );

    if (accion) {}
  }

  void eliminar(int index) {
    print(index);

    terminosyCondiciones.removeAt(index);
    notifyListeners();
  }

  modificar(
    BuildContext context,
    int index,
    String textModify,
  ) {
    if (index == -1) {
      terminosyCondiciones.add(textModify);
      notifyListeners();
    } else {
      // Guardar el nuevo valor y cerrar el diálogo
      terminosyCondiciones[index] = textModify;

      notifyListeners();
    }

    Navigator.of(context).pop(true);
  }

  Future<bool> backModify() async {
    terminosyCondiciones.clear();

    terminosyCondiciones.addAll(copiaTerminosyCondiciones);
    return true;
  }
}
