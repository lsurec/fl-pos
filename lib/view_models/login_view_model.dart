// ignore_for_file: use_build_context_synchronously
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../displays/shr_local_config/services/services.dart';

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

        //cargar empresas y etsaciones

        //cargar emmpresas

        final EmpresaService empresaService = EmpresaService();

        final ApiResModel resEmpresas = await empresaService.getEmpresa(
          user,
          token,
        );

        if (!resEmpresas.succes) {
          //si hay mas de una estacion o mas de una empresa mostar configuracion local

          isLoading = false;
          NotificationService.showErrorView(context, resEmpresas);
          return;
        }

        final EstacionService estacionService = EstacionService();

        final ApiResModel resEstaciones = await estacionService.getEstacion(
          user,
          token,
        );

        if (!resEmpresas.succes) {
          //si hay mas de una estacion o mas de una empresa mostar configuracion local

          isLoading = false;
          NotificationService.showErrorView(context, resEstaciones);

          return;
        }

        localVM.empresas.addAll(resEmpresas.message);
        localVM.empresas.addAll(resEmpresas.message);
        localVM.estaciones.addAll(resEstaciones.message);

        if (localVM.estaciones.length == 1) {
          localVM.selectedEstacion = localVM.estaciones.first;
        }

        if (localVM.empresas.length == 1) {
          localVM.selectedEmpresa = localVM.empresas.first;
        }

        //si solo hay una estacion y una empresa mostrar home
        if (localVM.estaciones.length == 1 && localVM.empresas.length == 1) {
          //view model externo
          final menuVM = Provider.of<MenuViewModel>(context, listen: false);
          final homeVM = Provider.of<HomeViewModel>(context, listen: false);

          //Load tipo cambio

          TipoCambioService tipoCambioService = TipoCambioService();

          final ApiResModel resCambio = await tipoCambioService.getTipoCambio(
            localVM.selectedEmpresa!.empresa,
            user,
            token,
          );

          if (!resCambio.succes) {
            //si hay mas de una estacion o mas de una empresa mostar configuracion local

            isLoading = false;
            NotificationService.showErrorView(context, resCambio);

            return;
          }

          final List<TipoCambioModel> cambios = resCambio.message;

          if (cambios.isNotEmpty) {
            homeVM.tipoCambio = cambios[0].tipoCambio;
          } else {
            resCambio.message =
                "No se encontraron registros para el tipo de cambio. Por favor verifique que tenga un valor asignado.";
            localVM.resApis = resCambio;

            isLoading = false;
            NotificationService.showErrorView(context, resCambio);

            return;
          }

          final MenuService menuService = MenuService();

          final ApiResModel resApps =
              await menuService.getApplication(user, token);

          if (!resApps.succes) {
            //si hay mas de una estacion o mas de una empresa mostar configuracion local

            isLoading = false;
            NotificationService.showErrorView(context, resApps);

            return;
          }

          final List<ApplicationModel> applications = resApps.message;

          menuVM.menuData.clear();

          for (var application in applications) {
            final ApiResModel resDisplay = await menuService.getDisplay(
              application.application,
              user,
              token,
            );

            if (!resDisplay.succes) {
              //si hay mas de una estacion o mas de una empresa mostar configuracion local
              isLoading = false;
              NotificationService.showErrorView(context, resDisplay);

              return;
            }

            menuVM.menuData.add(
              MenuData(
                application: application,
                children: resDisplay.message,
              ),
            );
          }

          menuVM.loadDataMenu(context);

          //navegar a home
          Navigator.pushReplacementNamed(context, AppRoutes.home);

          return;
        }

        localVM.resApis = null;

        //si hay mas de una estacion o mas de una empresa mostar configuracion local
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes
              .shrLocalConfig, // Ruta a la que se redirigirá después de cerrar sesión
          (Route<dynamic> route) =>
              false, // Condición para eliminar todas las rutas anteriores
        );

        Navigator.pushReplacementNamed(context, AppRoutes.shrLocalConfig);
      } else {
        //finalizar proceso
        isLoading = false;
        //si el usuario es incorrecto
        NotificationService.showSnackbar(respLogin.message);
      }
    }
  }
}
