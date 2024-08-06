import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/tables_view_model.dart';
import 'package:provider/provider.dart';

class OrderViewModel extends ChangeNotifier {
  final List<OrderModel> orders = [];

  addFirst(
    BuildContext context,
    OrderModel item,
  ) {
    final vmTable = Provider.of<TablesViewModel>(context, listen: false);
    orders.add(item);
    vmTable.updateOrdersTable(context);
    notifyListeners();
  }

  addTransactionFirst(TraRestaurantModel transaction) {
    orders.first.transacciones.add(transaction);
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
}
