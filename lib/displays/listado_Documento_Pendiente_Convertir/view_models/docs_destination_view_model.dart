// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/models/models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:provider/provider.dart';

class DocsDestinationViewModel extends ChangeNotifier {
  //controlar procesos
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> navigateDetails(
      BuildContext context, DocDestinationModel document) async {
    final detailsVM =
        Provider.of<DetailsDestinationDocViewModel>(context, listen: false);

    isLoading = true;

    await detailsVM.loadData(context, document);

    Navigator.pushNamed(
      context,
      AppRoutes.detailsDestinationDoc,
      arguments: document,
    );

    isLoading = false;
  }
}
