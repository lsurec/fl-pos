import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/restaurant_service.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class ClassificationViewModel extends ChangeNotifier {
  final List<ClassificationModel> classifications = [];

  Future<ApiResModel> loadClassification(BuildContext context) async {
    final docVM = Provider.of<DocumentViewModel>(
      context,
      listen: false,
    );

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
    final String serie = docVM.serieSelect!.serieDocumento!;

    RestaurantService restaurantService = RestaurantService();

    final ApiResModel resClassification =
        await restaurantService.getClassifications(
      tipoDocumento,
      empresa,
      estacion,
      serie,
      user,
      token,
    );

    return resClassification;
  }
}
