import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/tables_view_model.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class OrderViewModel extends ChangeNotifier {
  final List<OrderModel> orders = [];

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
          Navigator.of(context).pop();
          orders[indexOrder].transacciones.removeAt(indexTra);
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
