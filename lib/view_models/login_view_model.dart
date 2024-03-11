// ignore_for_file: use_build_context_synchronously
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //token del usuario
  String token = "";
  //nombre del usuario
  String user = "";
  //Cadena de conexion
  String conStr = "";
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

  // Toggles the password show status
  void toggle() {
    obscureText = !obscureText;
    notifyListeners();
  }

  //disableSession
  void disableSession(bool value) {
    isSliderDisabledSession = value;
    notifyListeners();
  }

  //navigate api url config
  void navigateConfigApi(BuildContext context) {
    Navigator.pushNamed(context, "api");
  }

  //cerrar Sesion
  void logout() {
    //limpiar datos en preferencias
    Preferences.clearToken();
    token = "";
    user = "";
    conStr = "";
    notifyListeners();
  }

  //init Session
  Future<void> login(BuildContext context) async {
    //ocultar tecladp
    FocusScope.of(context).unfocus();

    LoginService loginService = LoginService();

    //validate form
    // Navigator.pushNamed(context, "home");
    if (isValidForm()) {
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
      AccessModel respLogin = res.message;

      //si el usuaro es correcto
      if (respLogin.success) {
        //guardar token y nombre de usuario
        token = respLogin.message;
        user = respLogin.user;
        conStr = respLogin.con;

        //si la sesion es permanente guardar en preferencias el token
        if (isSliderDisabledSession) {
          Preferences.token = token;
          Preferences.userName = user;
          Preferences.conStr = conStr;
        }

        //view models externos
        final localVM =
            Provider.of<LocalSettingsViewModel>(context, listen: false);
        final menuVM = Provider.of<MenuViewModel>(context, listen: false);
        final homeVM = Provider.of<HomeViewModel>(context, listen: false);

        //cargar datos del menu
        await localVM.loadData(context);

        //si hay solo una estacion y una empresa
        if (localVM.empresas.length == 1 && localVM.estaciones.length == 1) {
          //cargar datos del menu
          await menuVM.loadDataMenu(context);
          homeVM.getTipoCambio(context);

          //finalizar proceso
          Navigator.pushReplacementNamed(context, "home");
          isLoading = false;
        } else {
          //finalizar proceso
          Navigator.pushReplacementNamed(context, "shrLocalConfig");
          isLoading = false;
        }
      } else {
        //finalizar proceso
        isLoading = false;
        //si el usuario es incorrecto
        NotificationService.showSnackbar(respLogin.message);
      }
    }
  }
}
