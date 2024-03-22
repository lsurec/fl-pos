// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/view_models/menu_view_model.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DocumentoViewModel extends ChangeNotifier {
  //control del proceso
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //nuevo documento
  Future<void> newDocument(BuildContext context, Function backTab) async {
    //view models externos
    final documentVM = Provider.of<DocumentViewModel>(context, listen: false);
    final detailsVM = Provider.of<DetailsViewModel>(context, listen: false);
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    final confirmVM = Provider.of<ConfirmDocViewModel>(context, listen: false);

    //mostrar dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: "¿Estás seguro?",
            description:
                "Los cambios que no hayan sido guardados, se perderán para siempre.",
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;

    if (!result) return;

    //limpiar pantalla documento
    documentVM.clearView();
    detailsVM.clearView(context);
    paymentVM.clearView(context);
    confirmVM.newDoc();
    Preferences.clearDocument();

    // Cambiar al primer tab al presionar el botón
    backTab();
  }

  //confirmar documento
  void sendDocumnet(
    BuildContext context,
    int screen,
  ) {
    //View models externos
    final documentVM = Provider.of<DocumentViewModel>(context, listen: false);
    final detailsVM = Provider.of<DetailsViewModel>(context, listen: false);
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);

    //Si no hay serie seleccionado mostrar mensaje
    if (documentVM.serieSelect == null) {
      NotificationService.showSnackbar("No se ha seleccionado una serie.");
      return;
    }

    //Si no hay cliente seleccioando mostrar mensaje
    if (documentVM.clienteSelect == null) {
      NotificationService.showSnackbar("No se ha seleccionado un cliente.");
      return;
    }

    //si hay vendedores debe seleconarse uno
    if (documentVM.cuentasCorrentistasRef.isNotEmpty) {
      //si hay vendedor seleccionado mostrar mensaje
      if (documentVM.vendedorSelect == null) {
        NotificationService.showSnackbar("No se ha seleccionado un vendedor.");
        return;
      }
    }

    //si no hay transacciones mostrar mensaje
    if (detailsVM.traInternas.isEmpty) {
      NotificationService.showSnackbar("No se han agregado transacciones.");
      return;
    }

    //si hay formas de pago validar quye se agregue alguna

    if (paymentVM.paymentList.isNotEmpty) {
      //si no hay pagos agregados mostar mensaje
      if (paymentVM.amounts.isEmpty) {
        NotificationService.showSnackbar("No se ha agregado ningun pago.");
        return;
      }

      // si no se ha pagado el total mostrar mensaje
      if (paymentVM.saldo != 0) {
        NotificationService.showSnackbar("Tinene un saldo pendiente de pagar.");
        return;
      }
    }

    if (documentVM.valueParam(58)) {
      if (documentVM.tipoReferenciaSelect == null) {
        NotificationService.showSnackbar(
            "No se ha seleccioando tipo referencia.");
        return;
      }
    }

    //si todas las validaciones son correctas navegar a resumen del documento
    Navigator.pushNamed(
      context,
      "confirm",
      arguments: screen, //1 documento; 2 comanda
    );
  }

  //cargar datos necesarios
  Future<void> loadData(BuildContext context) async {
    //view model externo
    final vmDocument = Provider.of<DocumentViewModel>(context, listen: false);
    final vmPayment = Provider.of<PaymentViewModel>(context, listen: false);
    final vmMenu = Provider.of<MenuViewModel>(context, listen: false);

    if (vmMenu.documento == null) return;

    //iniciar proceso
    isLoading = true;

    //cargar series
    await vmDocument.loadSeries(context, vmMenu.documento!);

    // si hay solo una serie buscar vendedores
    if (vmDocument.series.length == 1) {
      await vmDocument.loadSellers(
        context,
        vmDocument.series.first.serieDocumento!,
        vmMenu.documento!,
      );
      await vmDocument.loadTipoTransaccion(context);
      await vmDocument.loadParametros(context);
    }

    await vmPayment.loadPayments(context);

    //finalizar proceso
    isLoading = false;
  }
}
