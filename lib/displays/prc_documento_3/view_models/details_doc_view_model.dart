import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';

class DetailsDocViewModel extends ChangeNotifier {
  //Mostrar boton para imprimir
  bool _showBlock = false;
  bool get showBlock => _showBlock;

  set showBlock(bool value) {
    _showBlock = value;
    notifyListeners();
  }

  //Navgar a pantalla de impresion
  navigatePrint(
    BuildContext context,
    DetailDocModel doc,
  ) {
    Navigator.pushNamed(
      context,
      AppRoutes.printer,
      arguments: PrintDocSettingsModel(
        opcion: 2,
        consecutivoDoc: doc.consecutivo,
        cuentaCorrentistaRef: doc.seller,
      ),
    );
  }
}
