import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/product_restaurant_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/details_restaurant_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/order_view_model.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/views/views.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/account_pin_model.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:provider/provider.dart';

class AccountsViewModel extends ChangeNotifier {
  // final Map<String, dynamic> formValueAccount = {
  //   'cuenta': '',
  //   'option': null,
  // };
  // //Key for form account
  // GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // //True if form is valid
  // bool isValidForm() {
  //   return formKey.currentState?.validate() ?? false;
  // }

  // final List<OrderModel> orders = [];

  // loadCuentas(
  //   BuildContext context,
  //   TableModel mesa,
  //   LocationModel ubicacion,
  // ) {
  //   final _ordersVM = Provider.of<OrderViewModel>(context, listen: false);

  //   orders.clear();
  //   //filtar ordenes de la ubicacion y mesa
  //   orders.addAll(
  //     _ordersVM.orders
  //         .where(
  //           (order) =>
  //               order.mesa.elementoId
  //                   .toLowerCase()
  //                   .contains(mesa.elementoId.toLowerCase()) &&
  //               order.ubicacion.id
  //                   .toString()
  //                   .toLowerCase()
  //                   .contains(ubicacion.id.toString().toLowerCase()),
  //         )
  //         .toList(),
  //   );
  //   notifyListeners();
  // }

  // addNewAccount(
  //   BuildContext context,
  // ) {
  //   final vmTable = Provider.of<TablesViewModel>(context, listen: false);
  //   final vmLocation = Provider.of<LocationsViewModel>(context, listen: false);
  //   final vmPin = Provider.of<PinViewModel>(context, listen: false);

  //   final TableModel mesa = vmTable.table!;
  //   final LocationModel ubicacion = vmLocation.location!;
  //   final AccountPinModel mesero = vmPin.waitress!;

  //   if (isValidForm()) {
  //     final _ordersVM = Provider.of<OrderViewModel>(context, listen: false);

  //     OrderModel order = OrderModel(
  //       mesero: mesero,
  //       id: _ordersVM.orders.length + 1,
  //       nombre: formValueAccount['cuenta'],
  //       ubicacion: ubicacion,
  //       mesa: mesa,
  //       transacciones: [],
  //     );

  //     _ordersVM.orders.add(order);

  //     var snackBar = const SnackBar(
  //       content: Text("Cuenta agregada"),
  //       backgroundColor: AppTheme.primary,
  //       // action: SnackBarAction(
  //       //   label: 'Aceptar',
  //       //   onPressed: () => Navigator.pop(context),
  //       // ),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);

  //     loadCuentas(context, mesa, ubicacion);

  //     final _tableVM = Provider.of<TablesViewModel>(
  //       context,
  //       listen: false,
  //     );

  //     _tableVM.updateOrdersTable(context);

  //     //seleccionar la nueva cuenta creada
  //     formValueAccount['option'] = orders.length - 1;
  //     notifyListeners();
  //   }
  // }

  // addTransaction(
  //   BuildContext context,
  //   TableModel mesa,
  //   LocationModel ubicacion,
  //   ProductRestaurantModel producto,
  //   TypePriceModel cantidad,
  // ) {
  //   if (orders.isEmpty || formValueAccount["option"] == null) {
  //     var snackBar = const SnackBar(
  //       content: Text("Cree y/o seleccione una cuenta."),
  //       backgroundColor: AppTheme.primary,
  //       // action: SnackBarAction(
  //       //   label: 'Aceptar',
  //       //   onPressed: () => Navigator.pop(context),
  //       // ),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
  //     return;
  //   }

  //   final _productVM =
  //       Provider.of<ProductsClassViewModel>(context, listen: false);
  //   final _detailsVM =
  //       Provider.of<DetailsRestaurantViewModel>(context, listen: false);
  //   final _ordersVM = Provider.of<OrderViewModel>(context, listen: false);

  //   int indexOrder = -1;

  //   OrderModel orderSelect = orders[formValueAccount["option"]];

  //   for (var i = 0; i < _ordersVM.orders.length; i++) {
  //     OrderModel orderFind = _ordersVM.orders[i];

  //     if (orderFind.id == orderSelect.id) {
  //       indexOrder = i;
  //       break;
  //     }
  //   }

  //   if (indexOrder != -1) {
  //     TransaccionModel transaccion = TransaccionModel(
  //       precio: cantidad.precio,
  //       id: _ordersVM.orders[indexOrder].transacciones.length + 1,
  //       cantidad: cantidad.cantidad,
  //       producto: producto,
  //       observacion: _detailsVM.formValues['observacion'],
  //       guarniciones: [],
  //     );

  //     //navegar pantalla
  //     // if (_productVM.guarniciones.isNotEmpty) {
  //     //   Navigator.pushNamed(context, 'guarnicion', arguments: [
  //     //     indexOrder,
  //     //     transaccion,
  //     //   ]);

  //     //   return;
  //     // }

  //     //agregar transaccion a orden

  //     _ordersVM.orders[indexOrder].transacciones.add(transaccion);

  //     var snackBar = SnackBar(
  //       content: Text(
  //         "Se agregó la transaccion a la cuenta ${orders[formValueAccount["option"]].nombre}",
  //       ),
  //       backgroundColor: AppTheme.primary,
  //       // action: SnackBarAction(
  //       //   label: 'Aceptar',
  //       //   onPressed: () => Navigator.pop(context),
  //       // ),
  //     );
  //     ScaffoldMessenger.of(context).showSnackBar(snackBar);

  //     Navigator.pop(context);
  //   }
  // }
}
