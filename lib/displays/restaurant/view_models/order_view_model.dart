import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/tables_view_model.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class OrderViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isSelectedMode = false;
  bool get isSelectedMode => _isSelectedMode;

  set isSelectedMode(bool value) {
    _isSelectedMode = value;
    notifyListeners();
  }

  final List<OrderModel> orders = [];
  final List<int> selectedTra = [];

  //Salir de la pantalla
  Future<bool> backPage(
    BuildContext context,
    int indexOrder,
  ) async {
    if (!isSelectedMode) return true;

    isSelectedMode = false;

    for (var element in orders[indexOrder].transacciones) {
      element.selected = false;
    }

    notifyListeners();

    return false;
  }

  selectedAll(int indexOrder) {
    if (orders[indexOrder].transacciones.length ==
        getSelectedItems(indexOrder)) {
      for (var element in orders[indexOrder].transacciones) {
        element.selected = false;
      }

      // isSelectedMode = false;
    } else {
      for (var element in orders[indexOrder].transacciones) {
        element.selected = true;
      }
    }

    notifyListeners();
  }

  sleectedItem(int indexOrder, indexTra) {
    orders[indexOrder].transacciones[indexTra].selected =
        !orders[indexOrder].transacciones[indexTra].selected;

    notifyListeners();

    if (getSelectedItems(indexOrder) == 0) isSelectedMode = false;
  }

  onLongPress(int indexOrder, indexTra) {
    orders[indexOrder].transacciones[indexTra].selected = true;

    isSelectedMode = true;
  }

  getSelectedItems(int indexOrder) {
    return orders[indexOrder]
        .transacciones
        .where((order) => order.selected)
        .toList()
        .length;
  }

  //incrementa la cantidad de la transaccion
  increment(int indexOrder, int indexTra) {
    orders[indexOrder].transacciones[indexTra].cantidad++;

    notifyListeners();
  }

  //decrementa la cantidad de la transaccion
  decrement(BuildContext context, int indexOrder, int indexTra) {
    if (orders[indexOrder].transacciones[indexTra].cantidad == 1) {
      delete(context, indexOrder, indexTra);
      return;
    }

    orders[indexOrder].transacciones[indexTra].cantidad--;
    notifyListeners();
  }

  deleteSelectRecursive(int indexOrder) {
    for (var i = 0; i < orders[indexOrder].transacciones.length; i++) {
      if (orders[indexOrder].transacciones[i].selected) {
        orders[indexOrder].transacciones.removeAt(i);
        deleteSelectRecursive(indexOrder);
        break;
      }
    }
  }

  deleteSelected(int indexOrder, BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertWidget(
        title: "¿Estás seguro?",
        description:
            "Estas a punto de eliminar las transacciones seleccionadas. Esta accion no se puede deshacer.",
        onOk: () {
          //Cerrar sesión, limpiar datos
          Navigator.of(context).pop();

          deleteSelectRecursive(indexOrder);

          if (orders[indexOrder].transacciones.isEmpty) {
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

  //Eliminar transaccion
  delete(BuildContext context, int indexOrder, int indexTra) {
    //eliminar transaccion
    showDialog(
      context: context,
      builder: (context) => AlertWidget(
        title: "¿Estás seguro?",
        description:
            "Estas a punto de eliminar la transaccion. Esta accion no se puede deshacer.",
        onOk: () {
          //Cerrar sesión, limpiar datos
          Navigator.of(context).pop();

          orders[indexOrder].transacciones.removeAt(indexTra);

          if (orders[indexOrder].transacciones.isEmpty) {
            Navigator.of(context).pop();
            isSelectedMode = false;
          }

          NotificationService.showSnackbar("Transaccion eliminada");
          notifyListeners();
        },
        onCancel: () => Navigator.pop(context),
      ),
    );
  }

  addFirst(
    BuildContext context,
    OrderModel item,
  ) {
    final vmTable = Provider.of<TablesViewModel>(context, listen: false);
    orders.add(item);
    vmTable.updateOrdersTable(context);
    notifyListeners();
  }

  addTransactionFirst(
    TraRestaurantModel transaction,
    int indexOrder,
  ) {
    orders[indexOrder].transacciones.add(transaction);
    notifyListeners();
  }

  addTransactionToOrder(
    BuildContext context,
    TraRestaurantModel transaction,
    int idexOrder,
  ) {
    orders[idexOrder].transacciones.add(transaction);
    Navigator.popUntil(context, ModalRoute.withName(AppRoutes.productsClass));
    NotificationService.showSnackbar("Producto agregado");

    notifyListeners();
  }

  getGuarniciones(int indexOrder, int indexTra) {
    return orders[indexOrder]
        .transacciones[indexTra]
        .guarniciones
        .map(
          (guarnicion) =>
              "${guarnicion.garnish.descripcion} ${guarnicion.selected.descripcion}",
        )
        .join(", ");
  }

  getTotal(int idexOrder) {
    double total = 0;

    for (var element in orders[idexOrder].transacciones) {
      total += (element.cantidad * element.precio.precioU);
    }

    return total;
  }
}
