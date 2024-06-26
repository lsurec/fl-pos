// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/restaurant_service.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/account_pin_model.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class PinViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  AccountPinModel? waitress;
  String pinMesero = "";
  //Key for form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  //True if form is valid
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  Future<void> validatePin(BuildContext context) async {
    //hide keybord
    FocusScope.of(context).unfocus();

    if (!isValidForm()) return;

    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );
    final vmLocal = Provider.of<LocalSettingsViewModel>(
      context,
      listen: false,
    );

    final int empresa = vmLocal.selectedEmpresa!.empresa;
    final String token = vmLogin.token;

    RestaurantService restaurantService = RestaurantService();

    isLoading = true;

    final ApiResModel resPin = await restaurantService.getAccountPin(
      token,
      empresa,
      pinMesero,
    );

    if (!resPin.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resPin);
      return;
    }

    final List<AccountPinModel> waiters = resPin.response;

    if (waiters.isEmpty) {
      //TODO:Transalte
      NotificationService.showSnackbar("Pin invalido.");
      return;
    }

    waitress = waiters.first;

    //Cargar

    Navigator.pushNamed(context, AppRoutes.classification);

    isLoading = false;

    //Navegar a clasificacion
  }
}
