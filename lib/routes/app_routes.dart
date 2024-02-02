import 'package:flutter_post_printer_example/displays/conversion/views/views.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/views/views.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/views/views.dart';
import 'package:flutter_post_printer_example/views/views.dart';
import 'package:flutter/material.dart';

//rutas de navegacion
class AppRoutes {
  //ruta incial
  static const initialRoute = 'login';
  //otras rutas
  static Map<String, Widget Function(BuildContext)> routes = {
    initialRoute: (BuildContext context) => const LoginView(),
    'home': (BuildContext context) => const HomeView(),
    'api': (BuildContext context) => const ApiView(),
    'product': (BuildContext context) => const ProductView(),
    'selectProduct': (BuildContext context) => const SelectProductView(),
    'cargoDescuento': (BuildContext context) => const CargoDescuentoView(),
    'amount': (BuildContext context) => const AmountView(),
    'confirm': (BuildContext context) => const ConfirmDocView(),
    'selectClient': (BuildContext context) => const SelectClientView(),
    //Display documento pos (factura)
    'withoutPayment': (BuildContext context) => const Tabs2View(),
    'withPayment': (BuildContext context) => const Tabs3View(),
    //Display configuracion local
    "shrLocalConfig": (BuildContext context) => const LocalSettingsView(),
    "print": (BuildContext context) => const PrintView(),
    "settings": (BuildContext context) => const SettingsView(),
    "error": (BuildContext context) => const ErrorView(),
    "recent": (BuildContext context) => const RecentView(),
    "detailsDoc": (BuildContext context) => const DetailsDocView(),
    "addClient": (BuildContext context) => const AddClientView(),
    "help": (BuildContext context) => const HelpView(),
    "updateClient": (BuildContext context) => const UpdateClientView(),
    "pendingDocs": (BuildContext context) => const PendingDocsView(),
  };

  //en caso de ruta incorrecta
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const NotFoundView(),
    );
  }
}
