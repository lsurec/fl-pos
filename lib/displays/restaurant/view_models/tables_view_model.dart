import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/services.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class TablesViewModel extends ChangeNotifier {
  final List<TableModel> tables = [];

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

    final int empresa = vmLocal.selectedEmpresa!.empresa;
    final int estacion = vmLocal.selectedEstacion!.estacionTrabajo;
    final String user = vmLogin.user;
    final String token = vmLogin.token;
    final int tipoDocumento = vmMenu.documento!;

    RestaurantService restaurantService = RestaurantService();

    final ApiResModel resTables = await restaurantService.getTables(
      tipoDocumento,
      empresa,
      estacion,
      "1", //TODO:Preguntar
      elementAssigned,
      user,
      token,
    );

    return resTables;
  }
}
