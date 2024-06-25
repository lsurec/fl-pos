// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/cuenta_service.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/document_view_model.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/local_settings_view_model.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class AddClientViewModel extends ChangeNotifier {
  //Key for form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //formulario completo
  final Map<String, dynamic> formValues = {
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

  Future<void> createClinet(BuildContext context, int idCuenta) async {
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
    String user = loginVM.user;
    String token = loginVM.token;
    int empresa = localVM.selectedEmpresa!.empresa;

    CuentaService cuentaService = CuentaService();

    CuentaCorrentistaModel cuenta = CuentaCorrentistaModel(
        cuenta: idCuenta,
        nombre: formValues["nombre"],
        direccion: formValues["direccion"],
        telefono: formValues["telefono"],
        correo: formValues["correo"],
        nit: formValues["nit"]);

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

      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    ApiResModel resClient = await cuentaService.getCuentaCorrentista(
      empresa,
      cuenta.nit,
      user,
      token,
    );
    isLoading = false;

    //validar respuesta del servico, si es incorrecta
    if (!resClient.succes) {
      await NotificationService.showErrorView(
        context,
        resClient,
      );

      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'cuentaCreadaNoSelec',
        ),
      );
      return;
    }

    final List<ClientModel> clients = resClient.response;

    if (clients.isEmpty) {
      NotificationService.showSnackbar(
        idCuenta == 0
            ? AppLocalizations.of(context)!.translate(
                BlockTranslate.notificacion,
                'cuentaCreadaNoSelec',
              )
            : AppLocalizations.of(context)!.translate(
                BlockTranslate.notificacion,
                'cuentaActualizadaNoSelec',
              ),
      );
      return;
    }

    if (clients.length == 1) {
      documentVM.selectClient(clients.first, context);
      NotificationService.showSnackbar(
        idCuenta == 0
            ? AppLocalizations.of(context)!.translate(
                BlockTranslate.notificacion,
                'cuentaCreadaSelec',
              )
            : AppLocalizations.of(context)!.translate(
                BlockTranslate.notificacion,
                'cuentaActualizadaSelec',
              ),
      );

      return;
    }

    for (var i = 0; i < clients.length; i++) {
      final ClientModel client = clients[i];
      if (client.facturaNit == cuenta.nit) {
        documentVM.selectClient(client, context);
        break;
      }
    }

    documentVM.setText(documentVM.clienteSelect?.facturaNombre ?? "");

    //mapear respuesta servicio
    NotificationService.showSnackbar(
      idCuenta == 0
          ? AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'cuentaCreadaSelec',
            )
          : AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'cuentaActualizadaSelec',
            ),
    );
  }
}
