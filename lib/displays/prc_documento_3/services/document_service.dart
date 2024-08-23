// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class DocumentService {
  // Url del servidor
  final String _baseUrl = Preferences.urlApi;

  Future<ApiResModel> getDataComanda(
    String user,
    String token,
    int consecutivo,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Printer/comanda/$user/$consecutivo");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "Authorization": "bearer $token",
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //series disponibñes
      List<PrintDataComandaModel> detalles = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = PrintDataComandaModel.fromMap(item);
        //agregar item a la lista
        detalles.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: detalles,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }

//actualizar documento

  Future<ApiResModel> getEncabezados(
    int doc,
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Documento/encabezados");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "consecutivo": doc.toString(),
          "user": user,
          "Authorization": "bearer $token",
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //series disponibñes
      List<EncabezadoModel> encabezados = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = EncabezadoModel.fromMap(item);
        //agregar item a la lista
        encabezados.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: encabezados,
        storeProcedure: res.storeProcedure,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }

  Future<ApiResModel> getDetalles(
    int doc,
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Documento/detalles");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "consecutivo": doc.toString(),
          "user": user,
          "Authorization": "bearer $token",
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //series disponibñes
      List<DetalleModel> detalles = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = DetalleModel.fromMap(item);
        //agregar item a la lista
        detalles.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: detalles,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        storeProcedure: null,
        response: e.toString(),
      );
    }
  }

  Future<ApiResModel> getPagos(
    int doc,
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Documento/pagos");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "consecutivo": doc.toString(),
          "user": user,
          "Authorization": "bearer $token",
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //series disponibñes
      List<PagoModel> pagos = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = PagoModel.fromMap(item);
        //agregar item a la lista
        pagos.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: pagos,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }

  Future<ApiResModel> getDocument(
    int doc,
    String user,
    String token,
  ) async {
    Uri url = Uri.parse("${_baseUrl}Documento");
    try {
      //url completa

      //Configuracion del api
      final response = await http.get(
        url,
        headers: {
          "consecutivo": doc.toString(),
          "user": user,
          "Authorization": "bearer $token",
        },
      );
      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          storeProcedure: res.storeProcedure,
          response: res.data,
        );
      }

      //series disponibñes
      List<GetDocModel> documentos = [];

      //recorrer lista api Y  agregar a lista local
      for (var item in res.data) {
        //Tipar a map
        final responseFinally = GetDocModel.fromMap(item);
        //agregar item a la lista
        documentos.add(responseFinally);
      }

      //respuesta corecta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: documentos,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //Enviar documento al servidor
  Future<ApiResModel> updateDocument(
    PostDocumentModel document,
    String token,
    int consecutivo,
  ) async {
    //manejo de errores
    Uri url = Uri.parse("${_baseUrl}Documento/update/estructura/$consecutivo");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: document.toJson(),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer $token",
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: res.data,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //Enviar documento al servidor
  Future<ApiResModel> postDocument(
    PostDocumentModel document,
    String token,
  ) async {
    //manejo de errores
    Uri url = Uri.parse("${_baseUrl}Documento");
    try {
      //url completa

      // Configurar Api y consumirla
      final response = await http.post(
        url,
        body: document.toJson(),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "bearer $token",
        },
      );

      ResponseModel res = ResponseModel.fromMap(jsonDecode(response.body));

      //si el api no responde
      if (response.statusCode != 200 && response.statusCode != 201) {
        return ApiResModel(
          url: url.toString(),
          succes: false,
          response: res.data,
          storeProcedure: res.storeProcedure,
        );
      }

      //respuesta correcta
      return ApiResModel(
        url: url.toString(),
        succes: true,
        response: res.data,
        storeProcedure: null,
      );
    } catch (e) {
      //respuesta incorrecta
      return ApiResModel(
        url: url.toString(),
        succes: false,
        response: e.toString(),
        storeProcedure: null,
      );
    }
  }

  //Permanencia del documento despues de cerrada la aplicacion
  static saveDocumentLocal(BuildContext context) {
    //view models ecternos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);
    final menuVM = Provider.of<MenuViewModel>(context, listen: false);
    final detailsVM = Provider.of<DetailsViewModel>(context, listen: false);
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);

    //Documento que se guarda en Preferences
    final saveDocument = SaveDocModel(
      user: loginVM.user,
      empresa: localVM.selectedEmpresa!,
      estacion: localVM.selectedEstacion!,
      cliente: docVM.clienteSelect,
      vendedor: docVM.vendedorSelect,
      serie: docVM.serieSelect,
      tipoDocumento: menuVM.documento!,
      detalles: detailsVM.traInternas,
      pagos: paymentVM.amounts,
      tipoRef: docVM.valueParametro(58) ? docVM.referenciaSelect : null,
      refFechaEntrega: docVM.valueParametro(381)
          ? docVM.fechaRefIni.toIso8601String()
          : null,
      refFechaRecoger: docVM.valueParametro(382)
          ? docVM.fechaRefFin.toIso8601String()
          : null,
      refFechaInicio: docVM.valueParametro(44)
          ? docVM.fechaInicial.toIso8601String()
          : null,
      refFechaFin:
          docVM.valueParametro(44) ? docVM.fechaFinal.toIso8601String() : null,
      refContacto:
          docVM.valueParametro(385) ? docVM.refContactoParam385.text : null,
      refDescripcion:
          docVM.valueParametro(383) ? docVM.refDescripcionParam383.text : null,
      refDireccionEntrega:
          docVM.valueParametro(386) ? docVM.refDirecEntregaParam386.text : null,
      refObservacion:
          docVM.valueParametro(384) ? docVM.refObservacionParam384.text : null,
    );

    //Guardar el documento en memoria del telefono
    Preferences.document = saveDocument.toJson();
  }

  //Obtener documento guardado en permanencia de datos
  Future<void> loadDocumentSave(BuildContext context) async {
    //TODO:Validar la serie
    //view models externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);
    final docVM = Provider.of<DocumentViewModel>(context, listen: false);
    final menuVM = Provider.of<MenuViewModel>(context, listen: false);
    final detailsVM = Provider.of<DetailsViewModel>(context, listen: false);
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    final confirmVM = Provider.of<ConfirmDocViewModel>(context, listen: false);

    //No hacer nada si no hay un documento guardado
    if (Preferences.document.isEmpty) return;

    //Tipar documento guardado
    final SaveDocModel saveDocument = SaveDocModel.fromMap(
      jsonDecode(Preferences.document),
    );

    //si el usuario de la sesion y el documento es distinto no hacer nada
    if (saveDocument.user != loginVM.user) return;

    //si la estacion de trabajo de la sesion y la del documento son distintos no hacer nada
    if (saveDocument.estacion != localVM.selectedEstacion) return;

    //si la empresa de la sesion y la del documento son distintos no hacer nada
    if (saveDocument.empresa != localVM.selectedEmpresa) return;

    if (saveDocument.tipoDocumento != menuVM.documento) return;

    //buscar la serie del documento en la seria de la sesion
    int counter = -1;

    for (var i = 0; i < docVM.series.length; i++) {
      final serie = docVM.series[i];
      if (serie.serieDocumento == saveDocument.serie?.serieDocumento) {
        counter = i;
        break;
      }
    }

    //si no se encontró la serie del documento en las series de la sesion no hacer nada
    if (counter == -1) return;

    //si no hay transacciones no hacer nada
    // if (saveDocument.detalles.isEmpty) return;

    //mostrar dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'continuarDoc',
            ),
            description: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'docSinConfirmar',
            ),
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
            textCancel: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              'nuevoDoc',
            ),
            textOk: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              'cargarDoc',
            ),
          ),
        ) ??
        false;

    //si la opcion fie nuevo docummento llimpiar el documento de preferencias
    if (!result) {
      Preferences.clearDocument();
      //limpiar pantalla documento
      docVM.clearView();
      detailsVM.clearView(context);
      paymentVM.clearView(context);
      confirmVM.newDoc();
      return;
    }

    //Llamar a la funcion que recupera los datos y actualiza las vistas

    //Cargar documento

    loadDocumentLocal(context);

    // //limpiar serie
    // docVM.serieSelect = null;

    // //agregaar serie del documento
    // await docVM.changeSerie(docVM.series[counter], context);

    // counter = -1;

    // //agregar vendedor del docuemto
    // for (var i = 0; i < docVM.cuentasCorrentistasRef.length; i++) {
    //   final vendedor = docVM.cuentasCorrentistasRef[i];
    //   if (vendedor.cuentaCorrentista ==
    //       saveDocument.vendedor?.cuentaCorrentista) {
    //     counter = i;
    //     break;
    //   }
    // }

    // docVM.vendedorSelect = null;

    // //si el venodor no se encuntra no asignar niguno
    // if (counter != -1) {
    //   docVM.changeSeller(docVM.cuentasCorrentistasRef[counter]);
    // }

    // docVM.clienteSelect = null;

    // //agregar el cliente del documento
    // docVM.addClient(saveDocument.cliente);

    // detailsVM.traInternas.clear();
    // //agregar las transacciones del documento
    // for (var transaction in saveDocument.detalles) {
    //   detailsVM.addTransaction(transaction, context);
    // }

    // paymentVM.amounts.clear();

    // //agregar las formas de pago del documento
    // for (var amount in saveDocument.pagos) {
    //   paymentVM.addAmount(amount, context);
    // }
  }

  loadDocumentLocal(BuildContext context) async {
    //View models a utilizar

    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );
    final vmDoc = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

    final vmPayment = Provider.of<PaymentViewModel>(
      context,
      listen: false,
    );

    //Iniciar carga
    vmFactura.isLoading = true;

    //str to object para documento estructura
    //Tipar documento guardado
    final SaveDocModel saveDocument = SaveDocModel.fromMap(
      jsonDecode(Preferences.document),
    );

    if (vmDoc.serieSelect == null) {
      //Cargar serie del documento guardado
      for (int i = 0; i < vmDoc.series.length; i++) {
        SerieModel serieF = vmDoc.series[i];

        if (serieF.serieDocumento == saveDocument.serie!.serieDocumento) {
          vmDoc.serieSelect = serieF;
        }
      }
    }

    final List<SellerModel> cuentasCorrentistasRef =
        []; //cuenta correntisat ref

    //limmpiar lista vendedor
    cuentasCorrentistasRef.clear();

    //View models externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);

    //Datos necesarios
    int empresa = localVM.selectedEmpresa!.empresa;
    int estacion = localVM.selectedEstacion!.estacionTrabajo;
    String user = loginVM.user;
    String token = loginVM.token;
    int tipoDocumento = saveDocument.tipoDocumento;
    String serie = saveDocument.serie!.serieDocumento!;

    //instancia del servicio
    CuentaService cuentaService = CuentaService();

    //Consummo del api
    ApiResModel resVendedores = await cuentaService.getCeuntaCorrentistaRef(
      user,
      tipoDocumento,
      serie,
      empresa,
      token,
    );

    //valid succes response
    if (!resVendedores.succes) {
      vmFactura.isLoading = false;

      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        resVendedores,
      );
      return;
    }

    //cuntas correntista ref disponibles - agregar vendedores
    cuentasCorrentistasRef.addAll(resVendedores.response);

    //si solo hay un vendedor seleccionarlo por defecto
    if (cuentasCorrentistasRef.length == 1) {
      vmDoc.vendedorSelect = cuentasCorrentistasRef.first;
    }

    //Buscar tipos transaccion
    final List<TipoTransaccionModel> tiposTransaccion = [];

    //instancia del servicio
    tiposTransaccion.clear();
    TipoTransaccionService tipoTransaccionService = TipoTransaccionService();

    //consumo del api
    ApiResModel resTipoTransaccion =
        await tipoTransaccionService.getTipoTransaccion(
      tipoDocumento, // documento,
      serie, // serie,
      empresa, // empresa,
      token, // token,
      user, // user,
    );

    //valid succes response
    if (!resTipoTransaccion.succes) {
      vmFactura.isLoading = false;

      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        resTipoTransaccion,
      );
      return;
    }

    //tioos de transaccion disponibles
    tiposTransaccion.addAll(resTipoTransaccion.response);

    //Parametros
    //Buscar parametros del documento
    // final List<ParametroModel> parametros = [];
    vmDoc.parametros.clear();
    ParametroService parametroService = ParametroService();

    ApiResModel resParametros = await parametroService.getParametro(
      user,
      tipoDocumento,
      serie,
      empresa,
      estacion,
      token,
    );

    //valid succes response
    if (!resParametros.succes) {
      vmFactura.isLoading = false;
      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        resParametros,
      );
      return;
    }

    //Parammetros disponibles
    vmDoc.parametros.addAll(resParametros.response);

    //Buscar formas de pago
    //Formas de pago disponibles
    final List<PaymentModel> paymentList = [];

    //instancia del servicio
    PagoService pagoService = PagoService();

    //load prosses

    //Consumo del servicio
    ApiResModel resPayment = await pagoService.getFormas(
      tipoDocumento, // doc,
      serie, // serie,
      empresa, // empresa,
      token, // token,
    );

    //valid succes response
    if (!resPayment.succes) {
      //stop process
      vmFactura.isLoading = false;
      //si algo salio mal mostrar alerta

      await NotificationService.showErrorView(
        context,
        resPayment,
      );
      return;
    }

    //agregar formas de pago encontradas
    paymentList.addAll(resPayment.response);

    //si hay vendedor cargarlo
    if (saveDocument.vendedor != null &&
        saveDocument.vendedor!.nomCuentaCorrentista.isNotEmpty) {
      for (int i = 0; i < cuentasCorrentistasRef.length; i++) {
        SellerModel vendedorF = cuentasCorrentistasRef[i];

        //Asignaer vendedor guardado
        if (vendedorF.cuentaCorrentista ==
            saveDocument.vendedor!.cuentaCorrentista) {
          vmDoc.vendedorSelect = vendedorF;
        }
      }
    }

    if (vmDoc.valueParametro(58)) {
      TipoReferenciaService referenciaService = TipoReferenciaService();

      vmDoc.referenciaSelect = null;
      vmDoc.referencias.clear();

      //Consumo del servicio
      ApiResModel resTiposRef = await referenciaService.getTiposReferencia(
        user,
        token,
      );

      //valid succes response
      if (!resTiposRef.succes) {
        vmFactura.isLoading = false;

        //si algo salio mal mostrar alerta
        await NotificationService.showErrorView(
          context,
          resTiposRef,
        );
        return;
      }

      //agregar formas de pago encontradas
      vmDoc.referencias.addAll(resTiposRef.response);

      if (saveDocument.tipoRef != null) {
        for (int i = 0; i < vmDoc.referencias.length; i++) {
          TipoReferenciaModel referenciaF = vmDoc.referencias[i];
          if (referenciaF.tipoReferencia ==
              saveDocument.tipoRef!.tipoReferencia) {
            vmDoc.referenciaSelect = referenciaF;
          }
        }
      }
    }

    //evaluar fechas y observaciones
    if (vmDoc.valueParametro(381)) {
      //Fecha entrega
      vmDoc.fechaRefIni = DateTime.parse(saveDocument.refFechaEntrega!);
    }

    if (vmDoc.valueParametro(382)) {
      //Fecha recoger
      vmDoc.fechaRefFin = DateTime.parse(saveDocument.refFechaRecoger!);
    }

    if (vmDoc.valueParametro(44)) {
      //Fecha inicio y fecha fin

      vmDoc.fechaInicial = DateTime.parse(saveDocument.refFechaInicio!);
      vmDoc.fechaFinal = DateTime.parse(saveDocument.refFechaFin!);
    }

    if (vmDoc.valueParametro(385)) {
      vmDoc.refContactoParam385.text = saveDocument.refContacto ?? "";
    }

    if (vmDoc.valueParametro(383)) {
      vmDoc.refDescripcionParam383.text = saveDocument.refDescripcion ?? "";
    }

    if (vmDoc.valueParametro(386)) {
      vmDoc.refDirecEntregaParam386.text =
          saveDocument.refDireccionEntrega ?? "";
    }

    if (vmDoc.valueParametro(384)) {
      vmDoc.refObservacionParam384.text = saveDocument.refObservacion ?? "";
    }

    final detailsVM = Provider.of<DetailsViewModel>(
      context,
      listen: false,
    );

    vmDoc.clienteSelect = saveDocument.cliente; //asignar cliente

    if (saveDocument.cliente != null &&
        saveDocument.cliente!.facturaNit.toLowerCase() == "c/f") {
      vmDoc.cf = true;
    }

    // print(saveDocument.cliente!.facturaNit);

    detailsVM.traInternas.addAll(saveDocument.detalles); //asignar detalles
    vmPayment.amounts.addAll(saveDocument.pagos); //asignar pagos

    //calcular totales del documento y pagos
    detailsVM.calculateTotales(context);

    vmFactura.isLoading = false;
  }
}
