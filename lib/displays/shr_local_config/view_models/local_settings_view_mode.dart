// ignore_for_file: use_build_context_synchronously, curly_braces_in_flow_control_structures

import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/services/services.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalSettingsViewModel extends ChangeNotifier {
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
    //view model externi
    final menuVM = Provider.of<MenuViewModel>(context, listen: false);
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);

    //inicia de proceso
    isLoading = true;

    //cargar menu
    await menuVM.loadDataMenu(context);
    await homeVM.getTipoCambio(context);

    //finalizar proceso
    isLoading = false;

    //navegar a home
    Navigator.pushReplacementNamed(context, "home");
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

  //Reload datos
  Future<void> refreshData(BuildContext context) async {
    isLoading = true;
    await loadData(context);
    isLoading = false;
  }

  //Cargar datos necesaarios
  loadData(BuildContext context) async {
    //view model externo
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    //instancia del servicio empresa
    EmpresaService empresaService = EmpresaService();

    //instancia del servicio estacion
    EstacionService estacionService = EstacionService();

    //limpiar datos
    selectedEmpresa = null;
    selectedEstacion = null;
    empresas.clear();
    estaciones.clear();

    // Consumo api empresas
    ApiResModel resEmpresa = await empresaService.getEmpresa(
      loginVM.nameUser,
      loginVM.token,
    );

    //valid succes response
    if (!resEmpresa.succes) {
      // isLoading = false;

      //si algo salio mal mostrar alerta

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resEmpresa.message,
        url: resEmpresa.url,
        storeProcedure: resEmpresa.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    //consu,o del api estacion
    ApiResModel resEstacion = await estacionService.getEstacion(
      loginVM.nameUser,
      loginVM.token,
    );

    //valid succes response
    if (!resEstacion.succes) {
      //si algo salio mal mostrar alerta
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resEstacion.message,
        url: resEstacion.url,
        storeProcedure: resEstacion.storeProcedure,
      );

      await NotificationService.showErrorView(
        context,
        error,
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

    notifyListeners();
  }
}
