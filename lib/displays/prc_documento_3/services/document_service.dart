// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
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

    //si no hay transacciones o pagos agregados no hacer nada
    if (saveDocument.detalles.isEmpty && saveDocument.pagos.isEmpty) return;

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

    //Cargar documento

    //limpiar serie
    docVM.serieSelect = null;

    //agregaar serie del documento
    await docVM.changeSerie(docVM.series[counter], context);

    counter = -1;

    //agregar vendedor del docuemto
    for (var i = 0; i < docVM.cuentasCorrentistasRef.length; i++) {
      final vendedor = docVM.cuentasCorrentistasRef[i];
      if (vendedor.cuentaCorrentista ==
          saveDocument.vendedor?.cuentaCorrentista) {
        counter = i;
        break;
      }
    }

    docVM.vendedorSelect = null;

    //si el venodor no se encuntra no asignar niguno
    if (counter != -1) {
      docVM.changeSeller(docVM.cuentasCorrentistasRef[counter]);
    }

    docVM.clienteSelect = null;

    //agregar el cliente del documento
    docVM.addClient(saveDocument.cliente);

    detailsVM.traInternas.clear();
    //agregar las transacciones del documento
    for (var transaction in saveDocument.detalles) {
      detailsVM.addTransaction(transaction, context);
    }

    paymentVM.amounts.clear();

    //agregar las formas de pago del documento
    for (var amount in saveDocument.pagos) {
      paymentVM.addAmount(amount, context);
    }
  }
}
