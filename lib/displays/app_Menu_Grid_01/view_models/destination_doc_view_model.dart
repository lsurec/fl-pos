// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/app_Menu_Grid_01/models/models.dart';
import 'package:flutter_post_printer_example/displays/app_Menu_Grid_01/services/services.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class DestinationDocViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<DestinationDocModel> documents = [];

  Future<void> loadData(BuildContext context, PendingDocModel document) async {
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.nameUser;
    final int doc = document.tipoDocumento;
    final String serie = document.serieDocumento;
    final int empresa = document.empresa;
    final int estacion = document.estacionTrabajo;

    final ReceptionService receptionService = ReceptionService();

    documents.clear();

    isLoading = true;

    final ApiResModel res = await receptionService.getDestinationDocs(
      user,
      token,
      doc,
      serie,
      empresa,
      estacion,
    );

    isLoading = false;

    if (!res.succes) {
      ErrorModel error = res.message;

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    documents.addAll(res.message);
  }
}
