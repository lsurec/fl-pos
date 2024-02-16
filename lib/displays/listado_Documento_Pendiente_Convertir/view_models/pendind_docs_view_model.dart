// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
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

  bool _ascendente = true;
  bool get ascendente => _ascendente;

  set ascendente(bool value) {
    _ascendente = value;
    orderList();

    notifyListeners();
  }

  DateTime? fechaIni;
  DateTime? fechaFin;
  int tipoDoc = 0;

  String selectFilter = "Id documento";

  List<String> filters = [
    "Id documento",
    "Fecha documento",
  ];

  //Doucumentos disponibles
  final List<OriginDocModel> documents = [];

  orderList() {
    switch (selectFilter) {
      case "Id documento":
        if (_ascendente) {
          documents.sort((a, b) => b.iDDocumento
              .compareTo(a.iDDocumento)); // Orden descendente por ID
        } else {
          documents.sort((a, b) => a.iDDocumento
              .compareTo(b.iDDocumento)); // Orden ascendente por ID
        }

        break;
      case "Fecha documento":
        if (_ascendente) {
          documents.sort((a, b) => DateTime.parse(b.fechaHora).compareTo(
              DateTime.parse(a.fechaHora))); // Orden descendente por ID
        } else {
          documents.sort((a, b) => DateTime.parse(a.fechaHora).compareTo(
              DateTime.parse(b.fechaHora))); // Orden ascendente por ID
        }

        break;
      default:
    }

    notifyListeners();
  }

  changeFilter(String value) {
    selectFilter = value;
    orderList();
  }

  String _addLeadingZero(int number) {
    return number.toString().padLeft(2, '0');
  }

  formatStrFilterDate(DateTime date) {
    return '${date.year}${_addLeadingZero(date.month)}${_addLeadingZero(date.day)}';
  }

  Future<void> showPickerIni(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaIni!,
      //fecha minima la fecha actual o lafecha inicial seleciconada
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    if (pickedDate.isAfter(fechaFin!)) {
      fechaFin = pickedDate;
    }

    fechaIni = pickedDate;
    laodData(context);
  }

  Future<void> showPickerFin(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: fechaFin!,
      //fecha minima la fecha actual o lafecha inicial seleciconada
      firstDate: fechaIni!,
      lastDate: DateTime(2100),
    );
    if (pickedDate == null) return;

    fechaFin = pickedDate;
    laodData(context);
  }

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

    //Navgear a vosta de documentos destino
    Navigator.pushNamed(
      context,
      AppRoutes.destionationDocs,
      arguments: doc,
    );

    isLoading = false;
  }

  //Cargar datos
  Future<void> laodData(
    BuildContext context,
  ) async {
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
      formatStrFilterDate(fechaIni!),
      formatStrFilterDate(fechaFin!),
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

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

    orderList();

    isLoading = false;
  }

  formatView(DateTime date) => DateFormat('dd/MM/yyyy').format(date);

  // Función para formatear la fecha en el nuevo formato deseado
  String formatDate(String fechaString) {
    DateTime dateTime = DateTime.parse(fechaString);
    // Formatear la fecha y la hora en el nuevo formato "dd/MM/yyyy HH:mm:ss"
    String formattedDate =
        DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime.toLocal());
    return formattedDate;
  }
}
