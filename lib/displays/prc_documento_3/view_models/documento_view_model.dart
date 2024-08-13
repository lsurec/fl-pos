// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
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

  late TabController tabController;

  //nuevo documento
  Future<void> newDocument(BuildContext context) async {
    //mostrar dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'confirmar',
            ),
            description: AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'perder',
            ),
            textOk: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              "aceptar",
            ),
            textCancel: AppLocalizations.of(context)!.translate(
              BlockTranslate.botones,
              "cancelar",
            ),
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;

    if (!result) return;

    setValuesNewDoc(context);
  }

  Future<bool> backTabs(BuildContext context) async {
    final vmConfirm = Provider.of<ConfirmDocViewModel>(context, listen: false);

    final vmPayment = Provider.of<PaymentViewModel>(
      context,
      listen: false,
    );

    if (!vmConfirm.showPrint) return true;

    setValuesNewDoc(context);

    if (vmPayment.paymentList.isEmpty) {
      Navigator.popUntil(
          context, ModalRoute.withName(AppRoutes.withoutPayment));

      return false;
    }

    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.withPayment));
    return false;
  }

  setValuesNewDoc(BuildContext context) {
    //view models externos
    final documentVM = Provider.of<DocumentViewModel>(context, listen: false);
    final detailsVM = Provider.of<DetailsViewModel>(context, listen: false);
    final paymentVM = Provider.of<PaymentViewModel>(context, listen: false);
    final confirmVM = Provider.of<ConfirmDocViewModel>(context, listen: false);
    final vmConfirm = Provider.of<ConfirmDocViewModel>(context, listen: false);

    //limpiar pantalla documento
    documentVM.clearView();
    detailsVM.clearView(context);
    paymentVM.clearView(context);
    confirmVM.newDoc();

    vmConfirm.setIdDocumentoRef();

    // Cambiar al primer tab al presionar el botón
    tabController.animateTo(0); // Cambiar al primer tab (índice 0)
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
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinSerie',
        ),
      );
      return;
    }

    //Si no hay cliente seleccioando mostrar mensaje
    if (documentVM.clienteSelect == null) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinCliente',
        ),
      );
      return;
    }

    //si hay vendedores debe seleconarse uno
    if (documentVM.cuentasCorrentistasRef.isNotEmpty) {
      //si hay vendedor seleccionado mostrar mensaje
      if (documentVM.vendedorSelect == null) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'sinVendedor',
          ),
        );
        return;
      }
    }

    //verificar el tipo de referencia
    if (documentVM.valueParametro(58)) {
      if (documentVM.referenciaSelect == null) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'seleccioneTipoRef',
          ),
        );
        return;
      }
    }

    //verificar las fechas
    if (documentVM.valueParametro(44)) {
      if (!documentVM.validateDates()) {
        //Mostrar los mensajes indicando cual es la fecha incorrecta
        documentVM.notificacionFechas(context);
        return;
      }
    }

    //si no hay transacciones mostrar mensaje
    if (detailsVM.traInternas.isEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinTransacciones',
        ),
      );
      return;
    }

    //si hay formas de pago validar quye se agregue alguna

    if (paymentVM.paymentList.isNotEmpty) {
      //si no hay pagos agregados mostar mensaje
      if (paymentVM.amounts.isEmpty) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'sinPago',
          ),
        );
        return;
      }

      // si no se ha pagado el total mostrar mensaje
      if (paymentVM.saldo != 0) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'saldoPendiente',
          ),
        );
        return;
      }
    }

    final vmConfirm = Provider.of<ConfirmDocViewModel>(context, listen: false);

    //Obtener latitude y longitud Si es necesario
    if (documentVM.getPosition()) {
      vmConfirm.setPosition();
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

    vmDocument.referencias.clear();
    vmDocument.cuentasCorrentistasRef.clear();

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
      await vmDocument.obtenerReferencias(context); //cargar referencias
    }

    await vmPayment.loadPayments(context);

    //finalizar proceso
    isLoading = false;
  }
}
