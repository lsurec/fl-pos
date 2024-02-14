// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/services/services.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TypesDocViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //tipos de documentos que puede convertir
  final List<TypeDocModel> documents = [];

  //Navegar a documentos pendientes de recepcionar
  Future<void> navigatePendDocs(
    BuildContext context,
    TypeDocModel tipo, //Tipo de documento
  ) async {
    //Proveedor de datos externo
    final penVM = Provider.of<PendingDocsViewModel>(context, listen: false);

    //iniciar caraga
    isLoading = true;

    //Guradr tipo de documento seleccionado
    penVM.tipoDoc = tipo.tipoDocumento;

    //Cragar documentos pendientes de recepcionar
    await penVM.laodData(context);

    //navegar a pantalla documentos endentes
    Navigator.pushNamed(
      context,
      AppRoutes.pendingDocs,
      arguments: tipo,
    );

    //Detener carga
    isLoading = false;
  }

  //cargar datos
  Future<void> loadData(BuildContext context) async {
    //datos externos
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final String token = loginVM.token;
    final String user = loginVM.nameUser;

    //limpiar docunentos  anteriores
    documents.clear();

    //servicio
    final ReceptionService receptionService = ReceptionService();

    //iniciar carga
    isLoading = true;

    //consumo del api
    final ApiResModel res = await receptionService.getTiposDoc(user, token);

    //dteener carga
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

    //agregar tipos de docuentos encontrados
    documents.addAll(res.message);
  }
}
