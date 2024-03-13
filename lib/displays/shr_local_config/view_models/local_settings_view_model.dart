// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/services/services.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalSettingsViewModel extends ChangeNotifier {
  ApiResModel? resApis;

  //empresas disponibles
  final List<EmpresaModel> empresas = [];
  //Estaciones disponibles
  final List<EstacionModel> estaciones = [];

  //empresa seleccionada
  EmpresaModel? selectedEmpresa;

  //estacion seleccionada
  EstacionModel? selectedEstacion;

  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //navegar a home
  Future<void> navigateHome(BuildContext context) async {
    if (selectedEmpresa == null || selectedEstacion == null) {
      NotificationService.showSnackbar(
        "Para continuar, selecciona una empresa y estación de trabajo",
      );
      return;
    }

    //view model externi
    final menuVM = Provider.of<MenuViewModel>(context, listen: false);
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    final String user = loginVM.user;
    final String token = loginVM.token;

    //inicia de proceso
    isLoading = true;

    final MenuService menuService = MenuService();

    final ApiResModel resApps = await menuService.getApplication(user, token);

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
    isLoading = false;
  }

  //Seleccioanr tipo rpecio
  void changeEmpresa(EmpresaModel? value) {
    selectedEmpresa = value;
    notifyListeners();
  }

  //Seleccioanr tipo rpecio
  void changeEstacion(EstacionModel? value) {
    selectedEstacion = value;
    notifyListeners();
  }

  //Cargar datos necesaarios
  Future<void> loadData(BuildContext context) async {
    //view model externo
    final loginVM = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final String user = loginVM.user;
    final String token = loginVM.token;

    //instancia del servicio empresa
    EmpresaService empresaService = EmpresaService();

    //instancia del servicio estacion
    EstacionService estacionService = EstacionService();

    //limpiar datos
    selectedEmpresa = null;
    selectedEstacion = null;
    empresas.clear();
    estaciones.clear();

    isLoading = true;

    // Consumo api empresas
    ApiResModel resEmpresa = await empresaService.getEmpresa(
      user,
      token,
    );

    //valid succes response
    if (!resEmpresa.succes) {
      isLoading = false;
      NotificationService.showErrorView(
        context,
        resEmpresa,
      );

      return;
    }

    //consu,o del api estacion
    ApiResModel resEstacion = await estacionService.getEstacion(
      user,
      token,
    );

    //valid succes response
    if (!resEstacion.succes) {
      //si algo salio mal mostrar alerta
      isLoading = false;

      await NotificationService.showErrorView(
        context,
        resEstacion,
      );
      return;
    }

    //agregar empresas y estaciones
    empresas.addAll(resEmpresa.message);
    estaciones.addAll(resEstacion.message);

    //si solo hay una emoresa seleccionarla
    if (empresas.length == 1) {
      selectedEmpresa = empresas.first;
    }

    //si solo hay una estacion seleccionarala
    if (estaciones.length == 1) {
      selectedEstacion = estaciones.first;
    }

    isLoading = false;
  }
}
