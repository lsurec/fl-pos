// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:clipboard/clipboard.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';

class ApiViewModel extends ChangeNotifier {
  //controlar prcesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //input url
  String url = "";

  //Key for form
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //True if form is valid
  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }

  //validar si la url ingresada es valida y guardarla
  Future<void> connectService(BuildContext context) async {
    //ocultar teclado
    FocusScope.of(context).unfocus();

    //validar formulario
    if (!isValidForm()) return;

    //la url debe contener por lo menos un "/api/" para ser una url valida
    String separator = "/api/";

    //convertir url a minusculas
    url = url.toLowerCase();

    //existe "/api/" retorna verdadero
    bool containsApi = url.contains(separator);

    //si es falso mostrar mensaje
    if (!containsApi) {
      NotificationService.showSnackbar(AppLocalizations.of(context)!.translate(
        BlockTranslate.url,
        "invalida",
      ));
      return;
    }

    //buscar el ultimo indice donde encuentre "/api/"
    int lastIndex = url.lastIndexOf(separator);
    //Eliminar el resto de la url despues del ultimo "/api/"
    String result = url.substring(0, lastIndex + separator.length);

    //intsnce service
    HelloService helloService = HelloService();

    //iniciar proceso
    isLoading = true;

    //usar servicio api hello
    ApiResModel res = await helloService.getHello(result);

    //terminar proceso
    isLoading = false;

    //verificar respuesta del servicio si es incorrecta
    if (!res.succes) {
      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    //Si es la primera configuracion navegar a login
    //sino regresar
    if (Preferences.urlApi.isEmpty) {
      Navigator.pushReplacementNamed(context, 'login');
    } else {
      Navigator.pop(context);
    }

    //guardar url en preferencias
    Preferences.urlApi = result;

    //Mostrar mensaje correcto
    NotificationService.showSnackbar(AppLocalizations.of(context)!.translate(
      BlockTranslate.url,
      "agregada",
    ));
  }

  copyToClipboard(BuildContext context) {
    FlutterClipboard.copy(Preferences.urlApi).then(
      (value) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.url,
            "copiada",
          ),
        );
      },
    );
  }
}
