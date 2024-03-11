// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../displays/prc_documento_3/view_models/view_models.dart';

class MenuViewModel extends ChangeNotifier {
  //Lista que se muestra en pantalla
  final List<MenuModel> menuActive = [];
  //lista de navegacion (Nodos que se han miviso)
  final List<MenuModel> routeMenu = [];
  //menu completo
  late List<MenuModel> menu = [];

  //tipo docuento
  int? documento;
  String name = "";
  String? documentoName;

  //navegar a ruta
  Future<void> navigateDisplay(
    BuildContext context,
    String route,
    int? tipoDocumento,
    String nameDisplay,
    String? docName,
  ) async {
    //asiganro valores para la pantalla
    documento = tipoDocumento;
    name = nameDisplay;
    documentoName = docName;

    if (route.toLowerCase() == "prcdocumento_3") {
      final vmFactura = Provider.of<DocumentoViewModel>(context, listen: false);
      final vmPayment = Provider.of<PaymentViewModel>(context, listen: false);
      final vmHome = Provider.of<HomeViewModel>(context, listen: false);

      vmHome.isLoading = true;
      await vmFactura.loadData(context);

      vmHome.isLoading = false;

      if (vmPayment.paymentList.isEmpty) {
        Navigator.pushNamed(context, "withoutPayment");
        return;
      }

      Navigator.pushNamed(context, "withPayment");
      return;
    }

    //cargar dtos
    if (route == AppRoutes.Listado_Documento_Pendiente_Convertir) {
      final vmHome = Provider.of<HomeViewModel>(context, listen: false);
      final vmTipos = Provider.of<TypesDocViewModel>(context, listen: false);
      final vmPend = Provider.of<PendingDocsViewModel>(context, listen: false);

      vmHome.isLoading = true;

      DateTime now = DateTime.now();

      vmPend.fechaIni = now;
      vmPend.fechaFin = now;

      await vmTipos.loadData(context);

      //si solo hay un documento sleccioanrlo
      if (vmTipos.documents.length == 1) {
        final penVM = Provider.of<PendingDocsViewModel>(context, listen: false);

        penVM.tipoDoc = vmTipos.documents.first.tipoDocumento;

        await penVM.laodData(context);

        Navigator.pushNamed(
          context,
          AppRoutes.pendingDocs,
          arguments: vmTipos.documents.first,
        );

        vmHome.isLoading = false;

        return;
      }

      Navigator.pushNamed(context, route);

      vmHome.isLoading = false;

      return;
    }

    Navigator.pushNamed(context, route);
  }

  //Cambiar la lista que se muestra en pantalla
  void changeMenuActive(List<MenuModel> active, MenuModel padre) {
    //limpiar lista que se muestra
    menuActive.clear();
    //Agreagr nuevo contenido a la lista
    menuActive.addAll(active);
    //Agregar padre a la navehacion
    routeMenu.add(padre);
    //Notificar a los clientes
    notifyListeners();
  }

  //Cambiar rutas (Agreagar)
  void changeRoute(int index) {
    //Si el indice del padre seleccionado es menor al total de itemes
    //eliminar todos los qe sigan a partir del indice seleccoinado
    if (routeMenu.length - 1 > index) {
      //Eliminar el ultimo indice
      routeMenu.removeAt(routeMenu.length - 1);
      //Eliminar lo que se esta mostrando
      menuActive.clear();
      //Agreagar nuevo contenido
      menuActive.addAll(routeMenu[index].children);
      //notificar a los clientes
      notifyListeners();
      //Repetir hasta que todos los indices de mas se eliminen
      changeRoute(index);
    }
  }

  //actualizar menu
  Future<void> refreshData(BuildContext context) async {
    final homeVM = Provider.of<HomeViewModel>(context, listen: false);
    homeVM.isLoading = true;
    await loadDataMenu(context);
    homeVM.isLoading = false;
  }

  //cargar menu
  Future<void> loadDataMenu(BuildContext context) async {
    //limmpiar listas que se usan
    menuActive.clear();
    routeMenu.clear();
    menu.clear();

    //view model externo
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);

    //Lista aplicaciones y displays ()
    late List<MenuData> menuData = [];

    //Usario y token
    final String user = loginVM.user;
    final String token = loginVM.token;

    //Menu service
    MenuService menuService = MenuService();

    //Get data service application
    ApiResModel res = await menuService.getApplication(user, token);

    if (!res.succes) {
      await NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    ///asiganr aplicacviones
    List<ApplicationModel> applications = res.message;

    //Si menu data tiene datos anteriores limpiar la lista
    menuData.clear();

    //Guardar en menu datos applicaciones y displays sin ordenar
    for (var application in applications) {
      menuData.add(MenuData(application: application, children: []));
    }

    //Llamar a los displays de cada applicacion
    for (var app in menuData) {
      ApiResModel res = await menuService.getDisplay(
        app.application.application,
        user,
        token,
      );

      if (!res.succes) {
        await NotificationService.showErrorView(
          context,
          res,
        );
        return;
      }

      //asignar displays
      List<DisplayModel> displays = res.message;

      //agregar displays a la applicacion correspondientes
      app.children.addAll(displays);
    }

    //Separar displays nodo 1
    for (var item in menuData) {
      //nodo 1 (displays)
      List<MenuModel> padres = [];
      //nodos sin ordenar (displays)
      List<MenuModel> hijos = [];

      //Genrar estructrura de arbol
      for (var display in item.children) {
        //item menu model (Estructura de arbol propia)
        MenuModel itemMenu = MenuModel(
          name: display.name,
          // id: display.consecutivoInterno,
          route: display.displayUrlAlter ?? "notView",
          idChild: display.userDisplay,
          idFather: display.userDisplayFather,
          children: [],
          display: display,
        );

        //Si la propiedad userDisplayFather esta vacia es el primer nodo
        if (display.userDisplayFather == null) {
          padres.add(itemMenu);
        } else {
          hijos.add(itemMenu);
        }
      }

      //agregar items a la lista propia
      menu.add(
        MenuModel(
          display: null,
          name: item.application.description,
          // id: item.application.application,
          route: "",
          children: ordenarNodos(
            padres,
            hijos,
          ), //Funcion recursiva para ordenar nodos infinitos
        ),
      );
    }

    //retornar menu de arbol

    changeMenuActive(
      menu,
      MenuModel(
        display: null,
        name: "Aplicaciones",
        route: '',
        children: menu,
      ),
    );
  }

  // Función recursiva para ordenar nodos infinitos, recibe nodos principales y nodos a ordenar
  List<MenuModel> ordenarNodos(List<MenuModel> padres, List<MenuModel> hijos) {
    // Recorrer los nodos principales
    for (var i = 0; i < padres.length; i++) {
      // Item padre de la iteración
      MenuModel padre = padres[i];

      // Recorrer todos los hijos en orden inverso para evitar problemas al eliminar
      for (var j = hijos.length - 1; j >= 0; j--) {
        // Item hijo de la iteración
        MenuModel hijo = hijos[j];

        // Si coinciden (padre > hijo), agregar ese hijo al padre
        if (padre.idChild == hijo.idFather) {
          padre.children.add(hijo); // Agregar hijo al padre
          // Eliminar al hijo que ya se usó para evitar repetirlo
          hijos.removeAt(j);
          // Llamar a la misma función (recursividad) se detiene cuando ya no hay hijos
          ordenarNodos(padre.children, hijos);
        }
      }
    }

    // Retornar nodos ordenados
    return padres;
  }
}
