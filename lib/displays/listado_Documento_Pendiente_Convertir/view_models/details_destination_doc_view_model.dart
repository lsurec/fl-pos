// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsDestinationDocViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Detalles del documento destino
  final List<DestinationDetailModel> detalles = [];

  //cargar datos necesarios
  Future<void> loadData(
    BuildContext context,
    DocDestinationModel document, //Documento destino
  ) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.nameUser;

    //Servicio
    final ReceptionService receptionService = ReceptionService();

    //limmpiar detlles previos
    detalles.clear();

    //Iniciar pantalla de carga
    isLoading = true;

    //Consumo del api para obtenr los detalles del documento destino
    final ApiResModel res = await receptionService.getDetallesDocDestino(
        token, // token,
        user, // user,
        document.data.documento, // documento,
        document.data.tipoDocumento, // tipoDocumento,
        document.data.serieDocumento, // serieDocumento,
        document.data.empresa, // epresa,
        document.data.localizacion, // localizacion,
        document.data.estacion, // estacion,
        document.data.fechaReg // fechaReg,
        );

    //detener carga
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

    //agregar detalles
    detalles.addAll(res.message);
  }

  //Salir de la pantalla
  Future<bool> backPage(BuildContext context) async {
    //proveedores externos de datos
    final vmPend = Provider.of<PendingDocsViewModel>(context, listen: false);
    final vmConvert = Provider.of<ConvertDocViewModel>(context, listen: false);

    //desmarcar csilla seleccionar transacciones
    vmConvert.selectAllTra = false;

    //iniciar carga
    isLoading = true;

    //cardar documentos origrn
    await vmPend.laodData(context);

    //regresar a docuemntos pendientes de recepcionar
    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.pendingDocs));

    //Detener carga
    isLoading = false;

    return false;
  }

  //imprimir docuemnto
  printDoc(
    BuildContext context,
    DocDestinationModel document,
  ) {
    //navegar a pantalla de impresion
    Navigator.pushNamed(
      context,
      AppRoutes.printer,
      arguments: [3, document],
    );
  }
}
