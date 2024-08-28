import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class DetailsDocViewModel extends ChangeNotifier {
  //control del proceso
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

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
    final menuVM = Provider.of<MenuViewModel>(context, listen: false);

    Navigator.pushNamed(
      context,
      AppRoutes.printer,
      arguments: PrintDocSettingsModel(
        opcion: menuVM.documento == 20
            ? 4
            : 2, //TODO: Parametrizar con Alfa y Omega
        consecutivoDoc: doc.consecutivo,
        cuentaCorrentistaRef: doc.seller,
        client: doc.client,
      ),
    );
  }

  //Navgar a pantalla de impresion
  share(
    BuildContext context,
    DetailDocModel doc,
  ) async {
    final vmShare = Provider.of<ShareDocViewModel>(context, listen: false);
    final menuVM = Provider.of<MenuViewModel>(context, listen: false);

    isLoading = true;

    if (menuVM.documento == 20) {
      await vmShare.sheredDocCotiAlfayOmega(
        context,
        doc.consecutivo,
        doc.seller,
        doc.client,
        doc.total,
      );
      isLoading = false;
      return;
    } else {
      await vmShare.sheredDoc(
        context,
        doc.consecutivo,
        doc.seller,
        doc.client,
        doc.total,
      );
      isLoading = false;
      return;
    }
  }
}
