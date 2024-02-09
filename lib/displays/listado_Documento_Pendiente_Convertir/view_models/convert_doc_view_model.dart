// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/reception_service.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class ConvertDocViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool _selectAllTra = false;
  bool get selectAllTra => _selectAllTra;

  set selectAllTra(bool value) {
    _selectAllTra = value;

    for (var element in detalles) {
      element.checked = _selectAllTra;
    }

    notifyListeners();
  }

  final List<OriginDetailInterModel> detalles = [];

  String textoInput = "";

  Future<void> loadData(BuildContext context, OriginDocModel docOrigin) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.nameUser;

    final ReceptionService receptionService = ReceptionService();

    detalles.clear();

    isLoading = true;

    final ApiResModel res = await receptionService.getDetallesDocOrigen(
      token, // token,
      user, // user,
      docOrigin.documento, // documento,
      docOrigin.tipoDocumento, // tipoDocumento,
      docOrigin.serieDocumento, // serieDocumento,
      docOrigin.empresa, // epresa,
      docOrigin.localizacion, // localizacion,
      docOrigin.estacionTrabajo, // estacion,
      docOrigin.fechaReg, // fechaReg,
    );

    isLoading = false;

    //si el consumo salió mal
    if (!res.succes) {
      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    List<OriginDetailModel> details = res.message;

    for (var element in details) {
      detalles.add(
        OriginDetailInterModel(
          consecutivoInterno: element.consecutivoInterno,
          disponible: element.disponible,
          clase: element.clase,
          marca: element.marca,
          id: element.id,
          producto: element.producto,
          bodega: element.bodega,
          cantidad: element.cantidad,
          disponibleMod: element.disponible,
          checked: false,
        ),
      );
    }
  }

  selectTra(
    int index,
    bool value,
  ) {
    detalles[index].checked = value;
    notifyListeners();
  }

  modificarDisponible(
    BuildContext context,
    int index,
  ) {
    double monto = 0;

    if (double.tryParse(textoInput) == null) {
      //si el input es nulo o vacio agregar 0
      monto = 0;
    } else {
      monto = double.parse(textoInput); //parse string to double
    }

    if (monto <= 0) {
      NotificationService.showSnackbar("El valor debe ser mmayor a 0");
      return;
    }

    if (monto > detalles[index].disponible) {
      NotificationService.showSnackbar(
          "El valor debe ser mmayor al valor disponible.");
      return;
    }

    detalles[index].disponibleMod = monto;
    detalles[index].checked = true;
    Navigator.of(context).pop(); // Cierra el diálogo

    notifyListeners();
  }
}
