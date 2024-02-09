// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class TypesDocViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<TypeDocModel> documents = [];

  Future<void> navigatePendDocs(
    BuildContext context,
    TypeDocModel tipo,
  ) async {
    final penVM = Provider.of<PendingDocsViewModel>(context, listen: false);

    isLoading = true;

    await penVM.laodData(context, tipo.tipoDocumento);

    isLoading = false;

    Navigator.pushNamed(
      context,
      "pendingDocs",
      arguments: tipo,
    );
  }

  Future<void> loadData(BuildContext context) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.nameUser;

    documents.clear();

    final ReceptionService receptionService = ReceptionService();

    isLoading = true;

    //consumo del api
    final ApiResModel res = await receptionService.getTiposDoc(user, token);

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

    documents.addAll(res.message);
  }
}
