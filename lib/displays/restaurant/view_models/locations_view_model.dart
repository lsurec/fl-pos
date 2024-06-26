// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/restaurant_service.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class LocationsViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<LocationModel> locations = [];
  LocationModel? location;

  Future<ApiResModel> loadLocations(BuildContext context) async {
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

    RestaurantService restaurantService = RestaurantService();

    final ApiResModel resLocations = await restaurantService.getLocations(
      tipoDocumento,
      empresa,
      estacion,
      "1", //TODO:Preguntar -serie
      user,
      token,
    );

    return resLocations;
  }

  Future<void> loadData(BuildContext context) async {
    isLoading = true;

    final ApiResModel resLocations = await loadLocations(context);

    if (!resLocations.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resLocations);
      return;
    }

    final List<LocationModel> locationRes = resLocations.response;

    locations.clear();
    locations.addAll(locationRes);

    isLoading = false;
  }

  Future<void> navigateTables(
    BuildContext context,
    LocationModel locationParam,
  ) async {
    isLoading = true;

    final vmTables = Provider.of<TablesViewModel>(context, listen: false);

    final ApiResModel resTables = await vmTables.loadTables(
      context,
      locationParam.elementoAsignado,
    );

    if (!resTables.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resTables);
      return;
    }

    final List<TableModel> tablesRes = resTables.response;

    vmTables.tables.clear();
    vmTables.tables.addAll(tablesRes);

    vmTables.updateOrdersTable(context);

    location = null;
    location = locationParam;

    Navigator.pushNamed(context, AppRoutes.tables);

    isLoading = false;
  }
}