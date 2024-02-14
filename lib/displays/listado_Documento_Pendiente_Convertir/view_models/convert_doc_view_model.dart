// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/doc_convert_model.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/reception_service.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
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
      Navigator.of(context).pop(); // Cierra el diálogo

      NotificationService.showSnackbar("El valor debe ser mayor a 0");
      return;
    }

    if (monto > detalles[index].disponible) {
      Navigator.of(context).pop(); // Cierra el diálogo

      NotificationService.showSnackbar(
          "El valor no debe ser mayor al valor disponible.");
      return;
    }

    detalles[index].disponibleMod = monto;
    detalles[index].checked = true;
    Navigator.of(context).pop(); // Cierra el diálogo

    notifyListeners();
  }

  Future<void> convertirDocumento(
    BuildContext context,
    OriginDocModel origen,
    DestinationDocModel destino,
  ) async {
    // print(detalles[0].consecutivoInterno);

    // return;

    List<OriginDetailInterModel> elementosCheckTrue =
        detalles.where((elemento) => elemento.checked).toList();

    if (elementosCheckTrue.isEmpty) {
      NotificationService.showSnackbar(
          "Selecciona por lo menos una transacción.");
      return;
    }

    //convertir documento

    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.nameUser;

    final ReceptionService receptionService = ReceptionService();

    isLoading = true;

    for (var element in elementosCheckTrue) {
      final ApiResModel resUpdate = await receptionService.postActualizar(
        user,
        token,
        element.consecutivoInterno, // consecutivo,
        element.disponibleMod, // cantidad,
      );

      //si el consumo salió mal
      if (!resUpdate.succes) {
        isLoading = false;

        ErrorModel error = ErrorModel(
          date: DateTime.now(),
          description: resUpdate.message,
          storeProcedure: resUpdate.storeProcedure,
        );

        NotificationService.showErrorView(
          context,
          error,
        );

        return;
      }
    }

    final ParamConvertDocModel param = ParamConvertDocModel(
      pUserName: user,
      pODocumento: origen.documento,
      pOTipoDocumento: origen.tipoDocumento,
      pOSerieDocumento: origen.serieDocumento,
      pOEmpresa: origen.empresa,
      pOEstacionTrabajo: origen.estacionTrabajo,
      pOFechaReg: origen.fechaReg,
      pDTipoDocumento: destino.fTipoDocumento,
      pDSerieDocumento: destino.fSerieDocumento,
      pDEmpresa: origen.empresa,
      pDEstacionTrabajo: origen.estacionTrabajo,
    );

    final ApiResModel resConvert = await receptionService.postConvertir(
      token,
      param,
    );

    //si el consumo salió mal
    if (!resConvert.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: resConvert.message,
        storeProcedure: resConvert.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    DocConvertModel objDest = resConvert.message;

    // volver a cargar datos
    await loadData(context, origen);

    final DocDestinationModel doc = DocDestinationModel(
      tipoDocumento: destino.fTipoDocumento,
      desTipoDocumento: destino.documento,
      serie: destino.fSerieDocumento,
      desSerie: destino.serie,
      data: objDest,
    );

    final vmDetailsDestVM = Provider.of<DetailsDestinationDocViewModel>(
      context,
      listen: false,
    );

    await vmDetailsDestVM.loadData(context, doc);

    Navigator.pushNamed(
      context,
      AppRoutes.detailsDestinationDoc,
      arguments: doc,
    );

    isLoading = false;
  }
}
