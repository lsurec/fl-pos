// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/services.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class DetailsDestinationDocViewModel extends ChangeNotifier {
//controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<DestinationDetailModel> detalles = [];

  Future<void> loadData(
    BuildContext context,
    DocDestinationModel document,
  ) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.nameUser;

    final ReceptionService receptionService = ReceptionService();

    detalles.clear();

    isLoading = true;

    final ApiResModel res = await receptionService.getDetallesDocDestino(
        token, // token,
        user, // user,
        document.data.documento, // documento,
        document.data.tipoDocumento, // tipoDocumento,
        document.data.serieDocumento, // serieDocumento,
        document.data.empresa, // epresa,
        document.data.localizacion, // localizacion,
        document.data.estacion, // estacion,
        document.data.fechaReg // fechaReg,
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

    detalles.addAll(res.message);
  }
}
