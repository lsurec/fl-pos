// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/cuenta_service.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/document_view_model.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/local_settings_view_mode.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class AddClientViewModel extends ChangeNotifier {
  //Key for form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //formulario completo
  final Map<String, String> formValues = {
    'nombre': '',
    'direccion': '',
    'telefono': '',
    'correo': '',
    'nit': '',
  };

  //True if form is valid
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> createClinet(BuildContext context) async {
    //validar formulario
    if (!isValidForm()) return;

    FocusScope.of(context).unfocus();

    //Proveedor de datos externo
    final loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    //Proveedor de datos externo
    final localVM = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    final documentVM = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

    //usuario token y cadena de conexion
    String user = loginVM.nameUser;
    String token = loginVM.token;
    int empresa = localVM.selectedEmpresa!.empresa;

    CuentaService cuentaService = CuentaService();

    CuentaCorrentistaModel cuenta = CuentaCorrentistaModel.fromMap(formValues);

    isLoading = true;
    ApiResModel res = await cuentaService.postCuenta(
      user,
      empresa,
      token,
      cuenta,
    );

    //validar respuesta del servico, si es incorrecta
    if (!res.succes) {
      isLoading = false;
      //finalizar proceso
      isLoading = false;
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        url: res.url,
        storeProcedure: res.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );
      return;
    }

    ApiResModel resClient = await cuentaService.getClient(
      empresa,
      cuenta.nit,
      user,
      token,
    );
    isLoading = false;

    //validar respuesta del servico, si es incorrecta
    if (!resClient.succes) {
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resClient.message,
        url: resClient.url,
        storeProcedure: resClient.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );

      NotificationService.showSnackbar(
        "Se creo la cuenta, pero hubo en error al seleccionarla.",
      );
      return;
    }

    final List<ClientModel> clients = resClient.message;

    if (clients.isEmpty) {
      NotificationService.showSnackbar(
        "Se creo la cuenta, pero hubo en error al seleccionarla.",
      );
      return;
    }

    if (clients.length == 1) {
      documentVM.selectClient(clients.first, context);
      NotificationService.showSnackbar(
        "Cuenta creada y seleccionada correctamente.",
      );

      return;
    }

    for (var i = 0; i < clients.length; i++) {
      final ClientModel client = clients[i];
      if (client.facturaNit == cuenta.nit) {
        documentVM.selectClient(clients.first, context);

        break;
      }
    }

    //mapear respuesta servicio
    NotificationService.showSnackbar(
      "Cuenta creada y seleccionada correctamente.",
    );
  }
}
