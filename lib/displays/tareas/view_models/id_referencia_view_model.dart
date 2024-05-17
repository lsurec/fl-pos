// ignore_for_file: use_build_context_synchronously
import '../../../services/notification_service.dart';
import 'dart:async';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  //Lista para almacenar id referencias encontradas
  List<IdReferenciaModel> idReferencias = [];

//Buscar Id Referencia
  Future<void> buscarIdRefencia(
    BuildContext context,
    String search,
  ) async {
    idReferencias.clear(); //Limpiar lista de idReferencia

    //si el campo de busqueda está vacio, limpiar lista.
    if (search.isEmpty) {
      idReferencias.clear();
      return;
    }

    //View model de Login para obtener el usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //View model de configuracion local para obtener la empresa
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    int empresa = vmLocal.selectedEmpresa!.empresa;

    //Instancia del servicio
    final IdReferenciaService idReferenciaService = IdReferenciaService();

    isLoading = true; //cargar pantalla

    //Consumo del api
    final ApiResModel res = await idReferenciaService.getIdReferencia(
      user,
      token,
      empresa,
      search,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);
      return;
    }

    //agregar respesta de api a la lista de id referencias encontradas
    idReferencias.addAll(res.message);

    isLoading = false; //detener carga
  }

  void buscarRefTemp(BuildContext context) {
    timer?.cancel(); // Cancelar el temporizador existente si existe
    timer = Timer(
      const Duration(milliseconds: 1000),
      () {
        // Función de filtrado que consume el servicio
        FocusScope.of(context).unfocus(); //ocultar teclado
        buscarIdRefencia(context, buscarIdReferencia.text);
      },
    ); // Establecer el período de retardo en milisegundos (en este caso, 1000 ms o 1 segundo)
  }
}
