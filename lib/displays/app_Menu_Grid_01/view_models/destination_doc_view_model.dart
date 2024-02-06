// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/app_Menu_Grid_01/models/models.dart';
import 'package:flutter_post_printer_example/displays/app_Menu_Grid_01/services/services.dart';
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

  //Cargar datos
  Future<void> loadData(BuildContext context, PendingDocModel document) async {
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

    //si algo salió mal
    if (!res.succes) {
      ErrorModel error = res.message;

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
