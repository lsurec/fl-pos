// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/services/services.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class HomeRestaurantViewModel extends ChangeNotifier {
  //controlar proceso
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<SerieModel> series = [];
  SerieModel? serieSelect;

  //seleccionar serie
  Future<void> changeSerie(
    SerieModel? value,
    BuildContext context,
  ) async {
    //Seleccionar serie
    serieSelect = value;

    //TODO:Hacer cambios segun la serie

    notifyListeners();
  }

  Future<ApiResModel> loadSeries(BuildContext context) async {
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );
    final vmLocal = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    final vmMenu = Provider.of<MenuViewModel>(
      context,
      listen: false,
    );

    final int empresa = vmLocal.selectedEmpresa!.empresa;
    final int estacion = vmLocal.selectedEstacion!.estacionTrabajo;
    final String user = vmLogin.user;
    final String token = vmLogin.token;
    final int tipoDocumento = vmMenu.documento!;

    final SerieService serieService = SerieService();

    final ApiResModel res = await serieService.getSerie(
      tipoDocumento,
      empresa,
      estacion,
      user,
      token,
    );

    return res;
  }

  Future<void> navigateLoc(BuildContext context) async {
    final vmLoc = Provider.of<LocationsViewModel>(context, listen: false);

    //Cargar datos
    isLoading = true;

    final ApiResModel resLocations = await vmLoc.loadLocations(context);

    if (!resLocations.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resLocations);
      return;
    }

    final List<LocationModel> locations = resLocations.response;

    vmLoc.locations.clear();
    vmLoc.locations.addAll(locations);

    isLoading = false;
  }
}
