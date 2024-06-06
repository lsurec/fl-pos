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

class DestinationDocViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //documentos destino disponibles
  final List<DestinationDocModel> documents = [];

  //Navegar a pantallla de conversion de documentos
  Future<void> navigateConvert(
    BuildContext context,
    OriginDocModel originDoc, //Documento origen
    DestinationDocModel destinationDoc, //Docuento destino
  ) async {
    //Proveedor de datos
    final conVM = Provider.of<ConvertDocViewModel>(context, listen: false);

    //Iniciar carga
    isLoading = true;
    //Cargar detalles del documento origen
    await conVM.loadData(context, originDoc);

    //navegar a la pantalla de conversión
    Navigator.pushNamed(
      context,
      AppRoutes.convertDocs,
      arguments: [
        originDoc,
        destinationDoc,
      ],
    );

    //finalizar carga
    isLoading = false;
  }

  //Cargar datos
  Future<void> loadData(BuildContext context, OriginDocModel document) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token; //token de la sesion
    final String user = loginVM.user; //usuario de la sesion
    final int doc = document.tipoDocumento; //tipo documento
    final String serie = document.serieDocumento; //serie documento
    final int empresa = document.empresa; //empresa
    final int estacion = document.estacionTrabajo; //estacion

    //servicio qeu se va a utilizar
    final ReceptionService receptionService = ReceptionService();

    //limpiar documentos que pueden existir
    documents.clear();

    isLoading = true;

    //Consumo del servicio
    final ApiResModel res = await receptionService.getDestinationDocs(
      user,
      token,
      doc,
      serie,
      empresa,
      estacion,
    );

    isLoading = false;

    //TODO:Verificar reviison de erroes en otros servicios (Este es el correcto)
    //si algo salió mal
    if (!res.succes) {
      NotificationService.showErrorView(
        context,
        res,
      );

      return;
    }

    //Agregar documentos disponibles
    documents.addAll(res.response);
  }
}
