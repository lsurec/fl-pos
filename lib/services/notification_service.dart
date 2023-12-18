// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/error_model.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';

class NotificationService {
  //Key dcaffkod global
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  //Mostrar snack bar
  static showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: AppTheme.primary,
      // action: SnackBarAction(
      //   label: 'Aceptar',
      //   onPressed: () => Navigator.pop(context),
      // ),
    );

    //mosttar snack
    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static Future<void> showErrorView(
    BuildContext context,
    ErrorModel error,
  ) async {
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: "Algo salió mal",
            description:
                "No se pudo completar el proceso de conexión al servicio. Por favor, inténtalo de nuevo más tarde.",
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
            textCancel: "Ver informe",
            textOk: "Aceptar",
          ),
        ) ??
        true;

    //Si quiere verse el error
    if (!result) {
      //navegar a pantalla para ver el error
      Navigator.pushNamed(context, "error", arguments: error);
    }
  }
}
