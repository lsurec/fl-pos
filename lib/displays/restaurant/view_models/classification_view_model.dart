// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/services/restaurant_service.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class ClassificationViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final List<ClassificationModel> classifications = [];
  final List<List<ClassificationModel>> menu = [];

  int totalLength = 0;

  Future<void> loadData(BuildContext context) async {
    isLoading = true;

    final ApiResModel resClassification = await loadClassification(context);

    if (!resClassification.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, resClassification);
      return;
    }

    List<ClassificationModel> classificationsRes = resClassification.response;

    classifications.clear();
    classifications.addAll(classificationsRes);

    orderMenu();

    isLoading = false;
  }

  orderMenu() {
    double rowsNum = 0; //Saber cuantas filas tengo

    //Dividir en 2 los items totales  pata obtener cuntas filas tengo
    if ((classifications.length / 2) % 1 == 0) {
      //Es entero
      rowsNum = classifications.length / 2; //Esa cantidad de filas
    } else {
      //es decimal
      rowsNum =
          ((classifications.length - 1) / 2) + 1; //sacar el entero y sumarle 1
    }

    menu.clear();

    //agreagr el numero de filas vacias
    for (var i = 0; i < rowsNum; i++) {
      menu.add([]);
    }

    //lenar las finlas
    //recorrer el numero de filas
    for (var i = 0; i < menu.length; i++) {
      //si de las lista inicial todavia hay algo
      if (classifications.isNotEmpty) {
        //si de la lista inicial ya solo hay uno
        if (classifications.length < 2) {
          //agrego ese item
          menu[i].add(classifications[0]);
          classifications.removeAt(0);
        } else {
          //si son mas de 2
          //Ibgreso los 2 primmeros
          menu[i].add(classifications[0]);
          menu[i].add(classifications[1]);
          //Eliminar los items que se igresaron a la fila
          classifications.removeAt(0);
          classifications.removeAt(0);
        }
      }
    }

    totalLength = 0;
    for (var sublist in menu) {
      totalLength += sublist.length;
    }
  }

  Future<ApiResModel> loadClassification(BuildContext context) async {
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

    final ApiResModel resClassification =
        await restaurantService.getClassifications(
      tipoDocumento,
      empresa,
      estacion,
      "1", //TODO:Restaurante
      user,
      token,
    );

    return resClassification;
  }
}
