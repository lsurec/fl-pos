// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class ElementoAsigandoViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //variable de busqueda
  final TextEditingController buscarElementoAsignado = TextEditingController();

  //Lista para almacenar id referencias encontradas
  List<ElementoAsignadoModel> elementos = [];
  ElementoAsignadoModel? elemento;

  selectRef(BuildContext context, ElementoAsignadoModel? value, bool back) {
    elemento = value;
    notifyListeners();
    if (back) Navigator.pop(context);
  }

  //Buscar Id Referencia
  Future<void> getElementoAsignado(BuildContext context) async {
    elementos.clear(); //Limpiar lista de idReferencia

    //si el campo de busqueda está vacio, limpiar lista.
    if (buscarElementoAsignado.text.isEmpty) {
      elementos.clear();
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'ingreseCaracter',
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    //View model de Login para obtener el usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //View model de configuracion local para obtener la empresa
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    int empresa = vmLocal.selectedEmpresa!.empresa;

    //Instancia del servicio
    final ElementoAsignadoService elementoAsignadoService =
        ElementoAsignadoService();

    isLoading = true; //cargar pantalla

    //Consumo del api
    final ApiResponseModel res =
        await elementoAsignadoService.getElementoAsignado(
      empresa,
      buscarElementoAsignado.text,
      user,
      token,
    );

    //si el consumo salió mal
    if (!res.status) {
      isLoading = false;
      NotificationService.showInfoErrorView(context, res);
      return;
    }

    //agregar respesta de api a la lista de id referencias encontradas
    elementos.addAll(res.data);

    isLoading = false; //detener carga
  }
}
