// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/services.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class TablesViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<TableModel> tables = [];
  TableModel? table;

  backTablesView(BuildContext context) {
    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.tables));
  }

  navigateClassifications(
    BuildContext context,
    TableModel tableParam,
    int index,
  ) {
    table = tableParam;
    Navigator.pushNamed(context, AppRoutes.pin);
  }

  Future<void> loadData(BuildContext context) async {
    isLoading = true;

    final vmLoc = Provider.of<LocationsViewModel>(context, listen: false);

    final ApiResModel resTables = await loadTables(
      context,
      vmLoc.location!.elementoAsignado,
    );

    isLoading = false;

    if (!resTables.succes) {
      NotificationService.showErrorView(context, resTables);
    }
  }

  updateOrdersTable(BuildContext context) {
    final vmOrder = Provider.of<OrderViewModel>(context, listen: false);

    for (var i = 0; i < tables.length; i++) {
      final TableModel mesa = tables[i];

      tables[i].orders = [];

      for (var j = 0; j < vmOrder.orders.length; j++) {
        final OrderModel order = vmOrder.orders[j];

        if (order.mesa.elementoId == mesa.elementoId) {
          tables[i].orders!.add(j);
        }
      }
    }

    notifyListeners();
  }

  Future<ApiResModel> loadTables(
    BuildContext context,
    int elementAssigned,
  ) async {
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

    final vmHomeRestaurant = Provider.of<HomeRestaurantViewModel>(
      context,
      listen: false,
    );

    final int empresa = vmLocal.selectedEmpresa!.empresa;
    final int estacion = vmLocal.selectedEstacion!.estacionTrabajo;
    final String user = vmLogin.user;
    final String token = vmLogin.token;
    final int tipoDocumento = vmMenu.documento!;
    final String serie = vmHomeRestaurant.serieSelect!.serieDocumento!;

    RestaurantService restaurantService = RestaurantService();

    final ApiResModel resTables = await restaurantService.getTables(
      tipoDocumento,
      empresa,
      estacion,
      serie,
      elementAssigned,
      user,
      token,
    );

    if (!resTables.succes) return resTables;

    final List<TableModel> tablesRes = resTables.response;

    table = null;
    tables.clear();
    tables.addAll(tablesRes);

    updateOrdersTable(context);

    return resTables;
  }
}
