// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DestinationDocViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //docummentos destino disponibles
  final List<DestinationDocModel> documents = [];

  Future<void> navigateConvert(
    BuildContext context,
    OriginDocModel originDoc,
    DestinationDocModel destinationDoc,
  ) async {
    final conVM = Provider.of<ConvertDocViewModel>(context, listen: false);

    isLoading = true;
    await conVM.loadData(context, originDoc);
    isLoading = false;

    Navigator.pushNamed(
      context,
      "convertDocs",
      arguments: [
        originDoc,
        destinationDoc,
      ],
    );
  }

  //Cargar datos
  Future<void> loadData(BuildContext context, OriginDocModel document) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token; //token de la sesion
    final String user = loginVM.nameUser; //usuario de la sesion
    final int doc = document.tipoDocumento; //tipo documento
    final String serie = document.serieDocumento; //serie documento
    final int empresa = document.empresa; //empresa
    final int estacion = document.estacionTrabajo; //estacion

    //servicio qeu se va a utilizar
    final ReceptionService receptionService = ReceptionService();

    //limpiar documentos que pueden existir
    documents.clear();

    isLoading = true;

    //Consumo del servicio
    final ApiResModel res = await receptionService.getDestinationDocs(
      user,
      token,
      doc,
      serie,
      empresa,
      estacion,
    );

    isLoading = false;

//TODO:Verificar reviison de erroes en otros servicios (Este es el correcto)
    //si algo salió mal
    if (!res.succes) {
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    //Agregar documentos disponibles
    documents.addAll(res.message);
  }
}
