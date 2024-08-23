// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';

class PermisionsViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //conytrolar seion permanente
  bool isSliderDisabledSession = false;
  //ocultar y mostrar contraseña
  bool obscureText = true;
  //formulario login
  final Map<String, String> formValues = {
    'user': '',
    'pass': '',
  };

  //Key for form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //True if form is valid
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  //init Session
  Future<void> login(BuildContext context, int tipoAccion) async {
    //ocultar tecladp
    FocusScope.of(context).unfocus();

    LoginService loginService = LoginService();
    if (!isValidForm()) return;

    //validate form
    // Navigator.pushNamed(context, "home");
    //code if valid true
    LoginModel loginModel = LoginModel(
      user: formValues["user"]!,
      pass: formValues["pass"]!,
    );

    //iniciar proceso
    isLoading = true;

    //uso servicio login
    ApiResModel res = await loginService.postLogin(loginModel);

    //validar respuesta del servico, si es incorrecta
    if (!res.succes) {
      //finalizar proceso
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    //mapear respuesta servicio
    AccessModel respLogin = res.response;

    //si el usuaro es correcto
    if (respLogin.success) {
      //guardar token y nombre de usuario

      TipoAccionService tipoAccionService = TipoAccionService();

      final ApiResModel resTipoAccion =
          await tipoAccionService.validaTipoAccion(
        tipoAccion,
        respLogin.user,
        respLogin.message,
      );

      //validar respuesta del servico, si es incorrecta
      if (!resTipoAccion.succes) {
        //finalizar proceso
        isLoading = false;

        await NotificationService.showErrorView(
          context,
          resTipoAccion,
        );
        return;
      }

      isLoading = false;

      RespLogin accionValida = resTipoAccion.response;
      if (!accionValida.data) {
        NotificationService.showSnackbar(
            "El usuario ${respLogin.user} no posee permisos para esta acción.");

        isLoading = false;
        return;
      }

      //Navegar a select ubicacion
      Navigator.pushNamed(context, AppRoutes.selectLocation,
          arguments: tipoAccion);

      isLoading = false;
    } else {
      //finalizar proceso
      isLoading = false;
      //si el usuario es incorrecto
      NotificationService.showSnackbar(respLogin.message);
    }
  }
}
