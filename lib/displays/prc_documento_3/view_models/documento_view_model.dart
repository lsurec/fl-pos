// ignore_for_file: use_build_context_synchronously

import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/menu_view_model.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_post_printer_example/libraries/app_data.dart'
    as AppData;

class DocumentoViewModel extends ChangeNotifier {
  //control del proceso
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  printNetwork() async {
    int paperDefault = 80; //58 //72 //80

    DateTime now = DateTime.now();

    // Formatear la fecha como una cadena
    String formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";

    try {
      List<int> bytes = [];
      final generator = Generator(
        AppData.paperSize[paperDefault],
        await CapabilityProfile.load(),
      );
      bytes += generator.setGlobalCodeTable('CP1252');

      bytes += generator.text(
        "15 DE AGOSTO",
        styles: PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
        ),
      );
      bytes += generator.text(
        "Mesa: Mesa 1",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
        ),
      );

      bytes += generator.text(
        "REST - HPJ - 134",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
        ),
      );

      bytes += generator.emptyLines(2);

      bytes += generator.row(
        [
          PosColumn(text: 'Cant.', width: 2), // Ancho 2
          PosColumn(text: 'Descripcion', width: 10), // Ancho 6
        ],
      );
      bytes += bytes += generator.row(
        [
          PosColumn(
            text: '1',
            width: 2,
            styles: PosStyles(
              height: PosTextSize.size2,
            ),
          ), // Ancho 2
          PosColumn(
            text: 'DESAYUNO TIPICO',
            width: 10,
            styles: PosStyles(
              height: PosTextSize.size2,
            ),
          ), // Ancho 6
        ],
      );
      bytes += generator.emptyLines(2);

      bytes += generator.text(
        "Le atendió: ANAÍ CRUZ",
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
        ),
      );
      bytes += generator.text(
        formattedDate,
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size1,
        ),
      );
      bytes += generator.cut();

      PrinterManager.instance.connect(
        type: PrinterType.network,
        model: TcpPrinterInput(
          ipAddress: "192.168.0.15",
        ),
      );
      final PrinterManager instanceManager = PrinterManager.instance;

      await instanceManager.send(type: PrinterType.network, bytes: bytes);
    } catch (e) {
      print("No se pudo imprimir: ${e.toString()}");
    }
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
