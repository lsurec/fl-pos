// ignore_for_file: use_build_context_synchronously

import 'dart:async';

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

  Timer? timer; // Temporizador

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
    String user = vmLogin.user;
    int empresa = vmLocal.selectedEmpresa!.empresa;

    final IdReferenciaService idReferenciaService = IdReferenciaService();

    isLoading = true;
    final ApiResModel res =
        await idReferenciaService.getIdReferencia(user, token, empresa, search);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      return;
    }

    idReferencias.addAll(res.message);

    isLoading = false;
  }

  void buscarRefTemp(BuildContext context, String search) {
    timer?.cancel(); // Cancelar el temporizador existente si existe
    timer = Timer(const Duration(milliseconds: 1000), () {
      // Función de filtrado que consume el servicio
      buscarIdRefencia(context, buscarIdReferencia.text);
    }); // Establecer el período de retardo en milisegundos (en este caso, 1000 ms o 1 segundo)
  }
}
