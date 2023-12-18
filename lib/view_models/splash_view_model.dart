// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/views/views.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/views/views.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashViewModel extends ChangeNotifier {
  //version actual
  String versionLocal = "";
  String versionRemota = "1.0.0";

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

    double vLocal = verStrToNum(versionLocal);
    double vRemmota = verStrToNum(versionRemota);

    if (vRemmota > vLocal) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const UpdateView(),
        ), // Cambiar a la pantalla principal después de cargar los datos
      );
      return;
    }

    //Buscar si hay u ntojken en preferencias
    if (Preferences.token.isNotEmpty) {
      //si hay uuna sesion asiganr token y usuario global
      loginVM.token = Preferences.token;
      loginVM.nameUser = Preferences.userName;
      loginVM.conStr = Preferences.conStr;
    }

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
    await localVM.loadData(context);

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
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const LocalSettingsView(),
      ), // Cambiar a la pantalla principal después de cargar los datos
    );
  }
}
