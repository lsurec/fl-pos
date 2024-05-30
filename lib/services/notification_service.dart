// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/api_res_model.dart';
import 'package:flutter_post_printer_example/models/error_model.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';

class NotificationService {
  //Key dcaffkod global
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  //Mostrar snack bar
  static showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: AppTheme.styleTheme(
          Styles.normal,
          Preferences.theme,
        ),
      ),
      backgroundColor: AppTheme.primary,
      // action: SnackBarAction(
      //   label: 'Aceptar',
      //   onPressed: () => Navigator.pop(context),
      // ),
    );

    //mosttar snack
    messengerKey.currentState!.showSnackBar(snackBar);
  }

  static showInfoPrint(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.impresora,
              "problema",
            ),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "pasos",
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "encendida",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "modo",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "vinculada",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "papel",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "salidaPapel",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "usarCorrecta",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "correcta",
                ),
              ),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "dispositivo",
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.impresora,
                  "soporte",
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.botones,
                  "cerrar",
                ),
              ),
            ),
            // TextButton(
            //   onPressed: () {
            //     // Aquí puedes agregar lógica adicional, como redirigir a la sección de soporte.
            //     Navigator.of(context).pop();
            //   },
            //   child: Text('Contactar Soporte'),
            // ),
          ],
        );
      },
    );
  }

  static Future<void> showErrorView(
    BuildContext context,
    ApiResModel res,
  ) async {
    ErrorModel error = ErrorModel(
      date: DateTime.now(),
      description: res.message,
      url: res.url,
      storeProcedure: res.storeProcedure,
    );

    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'salioMal',
            ),
            description: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'error',
            ),
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
            textCancel: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              'informe',
            ),
            textOk: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              'aceptar',
            ),
          ),
        ) ??
        true;

    //Si quiere verse el error
    if (!result) {
      //navegar a pantalla para ver el error
      Navigator.pushNamed(
        context,
        "error",
        arguments: error,
      );
    }
  }
}
