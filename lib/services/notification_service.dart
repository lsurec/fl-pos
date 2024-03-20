// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/models/api_res_model.dart';
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

  static showInfoPrint(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Problema de Impresora'),
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  'Si configuraste tu impresora pero no imprime, sigue estos pasos:'),
              SizedBox(height: 8),
              Text('1. Verifica que tu impresora esté encendida.'),
              Text('2. Asegúrate de que la impresora esté en modo ESC/POS.'),
              Text(
                  '3. Comprueba que la impresora esté vinculada en la lista de dispositivos Bluetooth de tu dispositivo.'),
              Text(
                  '4. Asegúrate de que la impresora tenga papel disponible para imprimir.'),
              Text(
                  '5. Comprueba que no se esté obstruyendo la salida del papel al momento de imprimir.'),
              Text(
                  '6. Verifica que otro dispositvo no esté usando la impresora a la que intentas imprimir.'),
              Text(
                  '7. Asegurate que la impresora que intentas usar es la correcta.'),
              Text(
                  '8. Verifica que el dispositivo vinculado sea la impresora que intentas usar.'),
              SizedBox(height: 16),
              Text(
                'Si el problema persiste, comunícate con nuestro soporte técnico para obtener ayuda adicional.',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
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
      Navigator.pushNamed(
        context,
        "error",
        arguments: error,
      );
    }
  }
}
