// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/shr_local_config/services/empresa_service.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/services/estacion_service.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/views/views.dart';
import 'package:flutter_post_printer_example/models/api_res_model.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashViewModel extends ChangeNotifier {
  //version actual
  String versionLocal = "";
  String versionRemota = "";
  String idApp = "app_business";

  double verStrToNum(String versionstr) {
    // Separar la cadena de versión en partes usando el carácter '.'
    List<int> versionParts = versionstr.split('.').map(int.parse).toList();

    // Convertir las partes en un número decimal
    double versionNumber =
        versionParts[0] + versionParts[1] / 100 + versionParts[2] / 10000;

    return versionNumber;
  }

  //cargar datos iniciales
  Future<void> loadData(BuildContext context) async {
    //view models externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);

    //serviico controlar version
    VersionService versionService = VersionService();

    versionLocal = await versionService.getVersionLocal();

    //TODO: Buscar version remota

    //instancia del servicio

    // ApiResModel res = await versionService.getVersion(
    //   idApp,
    //   versionLocal,
    // );

    // //valid succes response
    // if (!res.succes) {
    //   //si algo salio mal mostrar alerta
    //   NotificationService.showSnackbar("No se pudo comprobar la version");
    // } else {
    //   //asignar la version remota a una variable global
    //   List<VersionModel> versiones = res.message;
    //   //agregar precios encontrados
    //   if (versiones.isEmpty) {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(
    //         builder: (context) => UpdateView(
    //           versionRemote: versiones.first,
    //         ),
    //       ),
    //     );
    //     return;

    //     // double vLocal = verStrToNum(versionLocal);
    //     // double vRemmota = verStrToNum(versionRemota);

    //     // if (vRemmota > vLocal) {
    //     //   Navigator.of(context).pushReplacement(
    //     //     MaterialPageRoute(
    //     //       builder: (context) => const UpdateView(),
    //     //     ), // Cambiar a la pantalla principal después de cargar los datos
    //     //   );
    //     //   return;
    //     // }
    //   }
    // }

    //Buscar si hay u token en preferencias
    if (Preferences.token.isNotEmpty) {
      //si hay uuna sesion asiganr token y usuario global
      loginVM.token = Preferences.token;
      loginVM.user = Preferences.userName;
      loginVM.conStr = Preferences.conStr;
    }

    final String user = loginVM.user;
    final String token = loginVM.token;

    //si no hay una url para las apis configurada
    if (Preferences.urlApi.isEmpty) {
      // Simula una carga de datos
      await Future.delayed(const Duration(seconds: 1));

      //mostrar pantallaconfiguracion de apis
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ApiView(),
        ), // Cambiar a la pantalla principal después de cargar los datos
      );
      return;
    }

    // si no hay una sesion de usuario guradada
    if (Preferences.token.isEmpty) {
      await Future.delayed(const Duration(seconds: 1));
      //mostrar login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const LoginView(),
        ), // Cambiar a la pantalla principal después de cargar los datos
      );
      return;
    }

    //Si hay sesion y url del api

    //cargar estaciones

    final EmpresaService empresaService = EmpresaService();

    final ApiResModel resEmpresas = await empresaService.getEmpresa(
      user,
      token,
    );

    if (!resEmpresas.succes) {
      //si hay mas de una estacion o mas de una empresa mostar configuracion local

      localVM.resApis = resEmpresas;

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes
            .shrLocalConfig, // Ruta a la que se redirigirá después de cerrar sesión
        (Route<dynamic> route) => false,
      );

      return;
    }

    final EstacionService estacionService = EstacionService();

    final ApiResModel resEstaciones = await estacionService.getEstacion(
      user,
      token,
    );

    if (!resEmpresas.succes) {
      //si hay mas de una estacion o mas de una empresa mostar configuracion local

      localVM.resApis = resEstaciones;

      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes
            .shrLocalConfig, // Ruta a la que se redirigirá después de cerrar sesión
        (Route<dynamic> route) => false,
      );

      return;
    }

    localVM.empresas.addAll(resEmpresas.message);
    localVM.estaciones.addAll(resEstaciones.message);

    //si solo hay una estacion y una empresa mostrar home
    if (localVM.estaciones.length == 1 && localVM.empresas.length == 1) {
      //view model externo
      final menuVM = Provider.of<MenuViewModel>(context, listen: false);
      final homeVM = Provider.of<HomeViewModel>(context, listen: false);
      //cargar datos del menu (aplicaciones/displays)
      await menuVM.loadDataMenu(context);
      await homeVM.getTipoCambio(context);

      //navegar a home
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeView(),
        ),
      );
      return;
    }

    //si hay mas de una estacion o mas de una empresa mostar configuracion local
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes
          .shrLocalConfig, // Ruta a la que se redirigirá después de cerrar sesión
      (Route<dynamic> route) =>
          false, // Condición para eliminar todas las rutas anteriores
    );
  }
}
