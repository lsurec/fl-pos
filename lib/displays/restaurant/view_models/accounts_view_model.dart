import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/order_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/tables_view_model.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class AccountsViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isSelectedMode = false;
  bool get isSelectedMode => _isSelectedMode;

  set isSelectedMode(bool value) {
    _isSelectedMode = value;
    notifyListeners();
  }

  final List<int> selectedAccounts = [];

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
        orderVM.orders.removeAt(i);
        deleteItemsRecursive(context);
        break;
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

    showDialog(
      context: context,
      builder: (context) => AlertWidget(
        title: "¿Estás seguro?",
        description:
            "Estas a punto de eliminar las cuentas seleccionadas. Esta accion no se puede deshacer.",
        onOk: () {
          //Cerrar sesión, limpiar datos
          Navigator.of(context).pop();

          deleteItemsRecursive(context);

          if (tablesVM.table!.orders!.isEmpty) {
            Navigator.of(context).pop();
          }

          isSelectedMode = false;
          NotificationService.showSnackbar("Transacciones eliminadas");
          notifyListeners();
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

  selectedItem(BuildContext context, int indexOrder) {
    final OrderViewModel orderVM = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    orderVM.orders[indexOrder].selected = !orderVM.orders[indexOrder].selected;
    notifyListeners();

    if (getSelectedItems(context) == 0) isSelectedMode = false;
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

    isSelectedMode = true;
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

    isSelectedMode = false;

    for (var element in orderVM.orders) {
      element.selected = false;
    }

    notifyListeners();

    return false;
  }
}
