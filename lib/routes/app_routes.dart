import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/views/views.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/views/views.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/views/views.dart';
import 'package:flutter_post_printer_example/displays/tareas/views/views.dart';
import 'package:flutter_post_printer_example/views/views.dart';
import 'package:flutter/material.dart';

//rutas de navegacion
class AppRoutes {
  //rutas
  static const login = 'login';
  static const home = 'home';
  static const api = 'api';
  static const product = 'product';
  static const selectProduct = 'selectProduct';
  static const cargoDescuento = 'cargoDescuento';
  static const amount = 'amount';
  static const confirm = 'confirm';
  static const selectClient = 'selectClient';
  static const withoutPayment = 'withoutPayment';
  static const withPayment = 'withPayment';
  static const shrLocalConfig = 'shrLocalConfig';
  static const printer = 'printer';
  static const settings = 'settings';
  static const error = 'error';
  static const recent = 'recent';
  static const detailsDoc = 'detailsDoc';
  static const addClient = 'addClient';
  static const help = 'help';
  static const updateClient = 'updateClient';
  static const Listado_Documento_Pendiente_Convertir =
      'Listado_Documento_Pendiente_Convertir';
  static const destionationDocs = 'destionationDocs';
  static const pendingDocs = 'pendingDocs';
  static const convertDocs = 'convertDocs';
  static const detailsDestinationDoc = 'detailsDestinationDoc';
  static const detailsTask = 'detalleTarea';
  static const viewComments = 'viewComments';

  //otras rutas
  static Map<String, Widget Function(BuildContext)> routes = {
    login: (BuildContext context) => const LoginView(),
    home: (BuildContext context) => const HomeView(),
    api: (BuildContext context) => const ApiView(),
    product: (BuildContext context) => const ProductView(),
    selectProduct: (BuildContext context) => const SelectProductView(),
    cargoDescuento: (BuildContext context) => const CargoDescuentoView(),
    amount: (BuildContext context) => const AmountView(),
    confirm: (BuildContext context) => const ConfirmDocView(),
    selectClient: (BuildContext context) => const SelectClientView(),
    //Display documento pos (factura)
    withoutPayment: (BuildContext context) => const Tabs2View(),
    withPayment: (BuildContext context) => const Tabs3View(),
    //Display configuracion local
    shrLocalConfig: (BuildContext context) => const LocalSettingsView(),
    //TODO:buscar ruta print
    printer: (BuildContext context) => const PrintView(),
    settings: (BuildContext context) => const SettingsView(),
    error: (BuildContext context) => const ErrorView(),
    recent: (BuildContext context) => const RecentView(),
    detailsDoc: (BuildContext context) => const DetailsDocView(),
    addClient: (BuildContext context) => const AddClientView(),
    help: (BuildContext context) => const HelpView(),
    updateClient: (BuildContext context) => const UpdateClientView(),
    Listado_Documento_Pendiente_Convertir: (BuildContext context) =>
        const TypesDocView(),
    destionationDocs: (BuildContext context) => const DestinationDocView(),
    pendingDocs: (BuildContext context) => const PendingDocsView(),
    convertDocs: (BuildContext context) => const ConvertDocView(),
    detailsDestinationDoc: (BuildContext context) =>
        const DetailsDestinationDocView(),
    //Rutas Display Tareas
    detailsTask: (BuildContext context) => const DetalleTareaView(),
    viewComments: (BuildContext context) => const ComentariosView(),
  };

  //en caso de ruta incorrecta
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => const NotFoundView(),
    );
  }
}
