import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_post_printer_example/libraries/app_data.dart'
    as AppData;

class SelectAccountViewModel extends ChangeNotifier {
  final PrinterManager instanceManager = PrinterManager.instance;

  bool isSelectedMode = false;

  setIsSelectedMode(BuildContext context, bool value) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    if (!value) {
      for (var i = 0; i < orderVM.orders.length; i++) {
        orderVM.orders[i].selected = value;
      }
    }

    isSelectedMode = value;

    notifyListeners();
  }

  Future<void> printStatusAccount(BuildContext context) async {
    try {
      int paperDefault = 80; //58 //72 //80

      PosStyles center = const PosStyles(
        align: PosAlign.center,
      );

      String line = "________________________________________________";

      List<int> bytes = [];
      final generator = Generator(
        AppData.paperSize[paperDefault],
        await CapabilityProfile.load(),
      );

      // final ByteData data = await rootBundle.load('assets/logo_demosoft.png');
      // final Uint8List bytesImg = data.buffer.asUint8List();
      // final img.Image? image = decodeImage(bytesImg);

      bytes += generator.setGlobalCodeTable('CP1252');

      bytes += generator.text(
        "Club campestre la montaña",
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
        ),
      );

      bytes += generator.text(
        "Barra mirablosque",
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
        ),
      );

      bytes += generator.text(
        "Mesa: Mesa 1",
        styles: const PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size2,
        ),
      );

      bytes += generator.text(
        "MIRALBOLSQUE - 1",
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
        ),
      );

      bytes += generator.emptyLines(1);

      bytes += generator.row([
        PosColumn(
          text: "Cant",
          width: 2,
        ),
        PosColumn(
          text: "Descripcion",
          width: 7,
        ),
        PosColumn(
          text: "Total",
          width: 3,
          styles: const PosStyles(
            align: PosAlign.right,
          ),
        ),
      ]);

      bytes += generator.text(line);
      bytes += generator.emptyLines(1);

      bytes += generator.row(
        [
          PosColumn(
            text: "100",
            width: 2,
          ),
          PosColumn(
            text: "Excepteur reprehenderit ut nostrud et veniam in.",
            width: 7,
          ),
          PosColumn(
            text: "100.00",
            width: 3,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ],
      );
      bytes += generator.text(line);
      bytes += generator.emptyLines(1);

      bytes += generator.row(
        [
          PosColumn(
            text: "Sub-Total:",
            width: 8,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
            ),
          ),
          PosColumn(
            text: "100,000.00",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
            ),
          ),
        ],
      );
      bytes += generator.row(
        [
          PosColumn(
            text: "Descuento:",
            width: 8,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
          PosColumn(
            text: "100,000.00",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ],
      );
      bytes += generator.row(
        [
          PosColumn(
            text: "Total:",
            width: 8,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
            ),
          ),
          PosColumn(
            text: "100,000.00",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
            ),
          ),
        ],
      );

      bytes += generator.row(
        [
          PosColumn(
            text: "",
            width: 8,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
            ),
          ),
          PosColumn(
            text: "_______________",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ],
      );
      bytes += generator.emptyLines(1);

      bytes += generator.row(
        [
          PosColumn(
            text: "Propina:",
            width: 8,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
            ),
          ),
          PosColumn(
            text: "_______________",
            width: 4,
            styles: const PosStyles(
              align: PosAlign.right,
            ),
          ),
        ],
      );
      bytes += generator.emptyLines(1);

      bytes += generator.text(
        "Nombre:",
      );

      bytes += generator.text(line);

      bytes += generator.emptyLines(1);

      bytes += generator.text(
        "NIT:",
      );

      bytes += generator.text(line);
      bytes += generator.emptyLines(1);

      bytes += generator.text(
        "Celular:",
      );

      bytes += generator.text(line);

      bytes += generator.emptyLines(1);

      bytes += generator.text(
        "Email:",
      );

      bytes += generator.text(line);
      bytes += generator.emptyLines(2);

      bytes += generator.text(
        "Le atendió: MESERO",
      );
      bytes += generator.emptyLines(1);
      bytes += generator.text(
        "12/12/2020",
      );
      bytes += generator.text(
        "12:12:00",
      );

      bytes += generator.emptyLines(2);

      bytes += generator.text(line);
      bytes += generator.emptyLines(2);

      bytes += generator.text(
        "Powered By:",
        styles: center,
      );

      bytes += generator.text(
        "Desarrollo Moderno de Software S.A.",
        styles: center,
      );
      bytes += generator.text(
        "www.demosoft.com.gt",
        styles: center,
      );

      bytes += generator.cut();

      await PrinterManager.instance.connect(
        type: PrinterType.network,
        model: TcpPrinterInput(
          // ipAddress: element.ipAdress,
          ipAddress: "192.168.0.10",
        ),
      );

      await instanceManager.send(
        type: PrinterType.network,
        bytes: bytes,
      );
    } catch (e) {
      // isLoading = false;
      NotificationService.showSnackbar(AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'noImprimio',
      ));
      return;
    }
  }

  navigatePermisionView(
    BuildContext context,
  ) {
    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    final LocationsViewModel locVM = Provider.of<LocationsViewModel>(
      context,
      listen: false,
    );

    final TransferSummaryViewModel transerVM =
        Provider.of<TransferSummaryViewModel>(
      context,
      listen: false,
    );

    transerVM.tableOrigin = tablesVM.table;
    transerVM.locationOrigin = locVM.location;

    Navigator.pushNamed(
      context,
      AppRoutes.permisions,
      arguments: 32, // 45 trasladar transaccion
    );
  }

  navigateDetails(BuildContext context, int index) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    if (orderVM.orders[index].transacciones.isEmpty) {
      NotificationService.showSnackbar(
          "No hay transacciones para mostrar"); //TODO:Translate
      return;
    }

    Navigator.pushNamed(
      context,
      AppRoutes.order,
      arguments: index,
    );
  }

  tapCard(
    BuildContext context,
    int screen,
    int index,
    TraRestaurantModel? transaction,
    int tipoAccion,
  ) {
    final OrderViewModel orderVM =
        Provider.of<OrderViewModel>(context, listen: false);

    switch (screen) {
      case 1: //Agreagr Transacion
        orderVM.addTransactionToOrder(context, transaction!, index);
        break;

      case 2: //Detalles
        navigateDetails(context, index);
        break;

      case 3: //traslado

        final TransferSummaryViewModel transferVM =
            Provider.of<TransferSummaryViewModel>(
          context,
          listen: false,
        );

        if (transferVM.tableOrigin!.elementoAsignado ==
                transferVM.tableDest!.elementoAsignado &&
            transferVM.locationOrigin!.elementoAsignado ==
                transferVM.locationDest!.elementoAsignado &&
            transferVM.indexOrderOrigin == index) {
          //TODO: Translate
          NotificationService.showSnackbar(
              "La transaccion ya existe en esta cuenta");
          return;
        }

        transferVM.indexOrderDest = index;

        Navigator.pushNamed(
          context,
          AppRoutes.transferSummary,
          arguments: tipoAccion,
        );
        break;
      default:
    }
  }

  selectedItem(BuildContext context, int indexOrder) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    orderVM.orders[indexOrder].selected = !orderVM.orders[indexOrder].selected;
    notifyListeners();

    if (getSelectedItems(context) == 0) setIsSelectedMode(context, false);
  }

  onLongPress(
    BuildContext context,
    int indexOrder,
  ) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    orderVM.orders[indexOrder].selected = true;

    setIsSelectedMode(context, true);
  }

  deleteItemsRecursive(BuildContext context) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    for (var i = 0; i < orderVM.orders.length; i++) {
      if (orderVM.orders[i].selected) {
        int comandada = 0;

        for (var element in orderVM.orders[i].transacciones) {
          if (element.processed) {
            comandada++;
          }
        }

        if (comandada == 0) {
          orderVM.orders.removeAt(i);
          deleteItemsRecursive(context);
          break;
        }
      }
    }

    tablesVM.updateOrdersTable(context);

    notifyListeners();
  }

  deleteItems(BuildContext context) {
    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    showDialog(
      context: context,
      builder: (context) => AlertWidget(
        title: "¿Estás seguro?",
        description:
            "Estas a punto de eliminar las cuentas seleccionadas. Esta accion no se puede deshacer.",
        onOk: () {
          //Cerrar sesión, limpiar datos
          Navigator.of(context).pop();

          int comandada = 0;

          for (var element in orderVM.orders) {
            for (var i = 0; i < element.transacciones.length; i++) {
              if (element.transacciones[i].processed) {
                comandada++;
                break;
              }
            }
          }

          deleteItemsRecursive(context);

          if (tablesVM.table!.orders!.isEmpty) {
            Navigator.of(context).pop();
          }

          setIsSelectedMode(context, false);
          notifyListeners();

          if (comandada != 0) {
            NotificationService.showSnackbar(
                "Cuentas comandadas no se pueden modificar.");
            return;
          }

          NotificationService.showSnackbar("Cuentas eliminadas");
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  selectedAll(BuildContext context) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    if (getSelectedItems(context) == tablesVM.table!.orders!.length) {
      for (var element in tablesVM.table!.orders!) {
        orderVM.orders[element].selected = false;
      }

      // isSelectedMode = false;
    } else {
      for (var element in tablesVM.table!.orders!) {
        orderVM.orders[element].selected = true;
      }
    }

    notifyListeners();
  }

  getSelectedItems(BuildContext context) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    return orderVM.orders.where((order) => order.selected).toList().length;
  }

  //Salir de la pantalla
  Future<bool> backPage(
    BuildContext context,
  ) async {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    if (!isSelectedMode) return true;

    setIsSelectedMode(context, false);

    for (var element in orderVM.orders) {
      element.selected = false;
    }

    notifyListeners();

    return false;
  }
}
