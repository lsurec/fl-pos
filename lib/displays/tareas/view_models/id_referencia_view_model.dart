// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

import '../../../services/notification_service.dart';

class IdReferenciaViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //variable de busqueda
  final TextEditingController buscarIdReferencia = TextEditingController();

  List<IdReferenciaModel> idReferencias = [];

//Buscar Id Referencia
  Future<void> buscarIdRefencia(
    BuildContext context,
    String search,
  ) async {
    idReferencias.clear();

    if (search.isEmpty) {
      idReferencias = [];
      print("Ingrese un caracter para realizar una busqueda");
      return;
    }

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;
    int empresa = vmLocal.selectedEmpresa!.empresa;

    final IdReferenciaService idReferenciaService = IdReferenciaService();

    isLoading = true;
    final ApiResModel res =
        await idReferenciaService.getIdReferencia(user, token, empresa, search);

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

    idReferencias.addAll(res.message);

    isLoading = false;
  }
}
