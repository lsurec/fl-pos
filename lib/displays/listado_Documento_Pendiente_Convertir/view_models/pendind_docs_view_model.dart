// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PendingDocsViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int tipoDoc = 0;

  //Doucumentos disponibles
  final List<OriginDocModel> documents = [];

  //navgear a pantalla de documentos destino
  Future<void> navigateDestination(
    BuildContext context,
    OriginDocModel doc,
  ) async {
    //datos externos
    final destVM = Provider.of<DestinationDocViewModel>(context, listen: false);

    isLoading = true;

    //Cargar documentos destino disponibles
    await destVM.loadData(context, doc);

    if (destVM.documents.length == 1) {
      await destVM.navigateConvert(context, doc, destVM.documents.first);
      isLoading = false;

      return;
    }

    isLoading = false;

    //Navgear a vosta de documentos destino
    Navigator.pushNamed(
      context,
      "destionationDocs",
      arguments: doc,
    );
  }

  //Cargar datos
  Future<void> laodData(BuildContext context) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.nameUser;

    //servicio que se va a usar
    final ReceptionService receptionService = ReceptionService();

    //limpiar docuemntos existentes
    documents.clear();

    isLoading = true;

    //consumo del api
    final ApiResModel res = await receptionService.getPendindgDocs(
      user,
      token,
      tipoDoc,
    );

    isLoading = false;

    //si el consumo salió mal
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

    //asignar documntos disponibles
    documents.addAll(res.message);
  }

  // Función para formatear la fecha en el nuevo formato deseado
  String formatDate(String fechaString) {
    DateTime dateTime = DateTime.parse(fechaString);
    // Formatear la fecha y la hora en el nuevo formato "dd/MM/yyyy HH:mm:ss"
    String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime.toLocal());
    return formattedDate;
  }
}
