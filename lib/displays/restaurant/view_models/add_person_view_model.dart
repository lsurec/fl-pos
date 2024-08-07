import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:provider/provider.dart';

class AddPersonViewModel extends ChangeNotifier {
  final Map<String, String> formValues = {
    'name': '',
  };

  renamePerson(BuildContext context, int indexOrder) {
    final OrderViewModel vmOrder = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    vmOrder.orders[indexOrder].nombre = formValues["name"] ?? "";
    Navigator.pop(context);
    notifyListeners();
  }

  addPerson(BuildContext context) {
    final OrderViewModel vmOrder = Provider.of<OrderViewModel>(
      context,
      listen: false,
    );

    final TablesViewModel vmTable = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );

    final PinViewModel vmPin = Provider.of<PinViewModel>(
      context,
      listen: false,
    );

    final LocationsViewModel vmLocal = Provider.of<LocationsViewModel>(
      context,
      listen: false,
    );

    vmOrder.orders.add(
      OrderModel(
        mesero: vmPin.waitress!,
        id: vmOrder.orders.length + 1,
        nombre: formValues["name"]!,
        ubicacion: vmLocal.location!,
        mesa: vmTable.table!,
        transacciones: [],
      ),
    );

    formValues["name"] = "";

    vmTable.updateOrdersTable(context);

    NotificationService.showSnackbar("Cuenta agregada");

    Navigator.of(context).pop();
  }
}
