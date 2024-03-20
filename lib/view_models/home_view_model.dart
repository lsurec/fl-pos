// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeViewModel extends ChangeNotifier {
  //TODO: Buscar moneda
  String moneda = "";

  //control del proceso
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Cerrar sesion
  Future<void> logout(BuildContext context) async {
    //view model externo
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    //mostrar dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: "¿Estás seguro?",
            description:
                "Si no se han guardado los cambios, los perderás para siempre.",
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;

    if (!result) return;

    //cerar sesion y navegar a login
    loginVM.logout();

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login, // Ruta a la que se redirigirá después de cerrar sesión
      (Route<dynamic> route) =>
          false, // Condición para eliminar todas las rutas anteriores
    );
  }

  navigateSettings(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.settings,
    );
  }
}
