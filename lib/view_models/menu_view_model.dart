// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/listado_Documento_Pendiente_Convertir/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../displays/listado_Documento_Pendiente_Convertir/services/services.dart';
import '../displays/prc_documento_3/view_models/view_models.dart';

class MenuViewModel extends ChangeNotifier {
  double tipoCambio = 0;

  //Lista que se muestra en pantalla
  final List<MenuModel> menuActive = [];
  //lista de navegacion (Nodos que se han miviso)
  final List<MenuModel> routeMenu = [];
  //menu completo
  final List<MenuModel> menu = [];

  //menu
  final List<MenuData> menuData = [];

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

    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    final vmFactura = Provider.of<DocumentoViewModel>(
      context,
      listen: false,
    );

    final vmHome = Provider.of<HomeViewModel>(
      context,
      listen: false,
    );

    final String user = vmLogin.user;
    final String token = vmLogin.token;

    tipoCambio = 0;

    if (route.toLowerCase() == "prcdocumento_3") {
      vmHome.isLoading = true;
      await vmFactura.loadNewData(context, 0);
      vmHome.isLoading = false;

      return;
    }

    //cargar dtos
    if (route == AppRoutes.Listado_Documento_Pendiente_Convertir) {
      if (documento == null) {
        NotificationService.showSnackbar(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'sinDocumento',
          ),
        );
        return;
      }

      final vmHome = Provider.of<HomeViewModel>(context, listen: false);
      final vmTipos = Provider.of<TypesDocViewModel>(context, listen: false);
      final vmPend = Provider.of<PendingDocsViewModel>(context, listen: false);

      vmHome.isLoading = true;

      DateTime now = DateTime.now();

      vmPend.fechaIni = now;
      vmPend.fechaFin = now;

      //limpiar docunentos  anteriores
      vmTipos.documents.clear();

      //servicio
      final ReceptionService receptionService = ReceptionService();

      //iniciar carga
      vmHome.isLoading = true;

      //consumo del api
      final ApiResModel res = await receptionService.getTiposDoc(user, token);

      //si el consumo salió mal
      if (!res.succes) {
        vmHome.isLoading = false;

        NotificationService.showErrorView(
          context,
          res,
        );

        return;
      }

      //agregar tipos de docuentos encontrados
      vmTipos.documents.addAll(res.response);

      //si solo hay un documento sleccioanrlo
      if (vmTipos.documents.length == 1) {
        final penVM = Provider.of<PendingDocsViewModel>(context, listen: false);

        penVM.tipoDoc = vmTipos.documents.first.tipoDocumento;

        //servicio que se va a usar
        final ReceptionService receptionService = ReceptionService();

        //limpiar docuemntos existentes
        penVM.documents.clear();

        //consumo del api
        final ApiResModel res = await receptionService.getPendindgDocs(
            user,
            token,
            documento!,
            penVM.formatStrFilterDate(penVM.fechaIni!),
            penVM.formatStrFilterDate(penVM.fechaFin!),
            "");

        //si el consumo salió mal
        if (!res.succes) {
          vmHome.isLoading = false;

          NotificationService.showErrorView(
            context,
            res,
          );

          return;
        }

        //asignar documntos disponibles
        penVM.documents.addAll(res.response);

        penVM.orderList();

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

  //Cambiar rutas (Agragar)
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
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final localVM = Provider.of<LocalSettingsViewModel>(context, listen: false);

    final String user = loginVM.user;
    final String token = loginVM.token;

    homeVM.isLoading = true;

    final TipoCambioService tipoCambioService = TipoCambioService();

    final ApiResModel resCambio = await tipoCambioService.getTipoCambio(
      localVM.selectedEmpresa!.empresa,
      user,
      token,
    );

    if (!resCambio.succes) {
      homeVM.isLoading = false;
      NotificationService.showErrorView(context, resCambio);
      return;
    }

    final List<TipoCambioModel> cambios = resCambio.response;

    if (cambios.isNotEmpty) {
      tipoCambio = cambios[0].tipoCambio;
    } else {
      resCambio.response = AppLocalizations.of(context)!.translate(
        BlockTranslate.notificacion,
        'sinTipoCambio',
      );

      homeVM.isLoading = false;
      NotificationService.showErrorView(context, resCambio);

      return;
    }

    final MenuService menuService = MenuService();

    final ApiResModel resApps = await menuService.getApplication(user, token);

    if (!resApps.succes) {
      //si hay mas de una estacion o mas de una empresa mostar configuracion local
      homeVM.isLoading = false;

      NotificationService.showErrorView(context, resApps);
      return;
    }

    final List<ApplicationModel> applications = resApps.response;

    menuData.clear();

    for (var application in applications) {
      final ApiResModel resDisplay = await menuService.getDisplay(
        application.application,
        user,
        token,
      );

      if (!resDisplay.succes) {
        //si hay mas de una estacion o mas de una empresa mostar configuracion local

        homeVM.isLoading = false;

        NotificationService.showErrorView(context, resDisplay);
        return;
      }

      menuData.add(
        MenuData(
          application: application,
          children: resDisplay.response,
        ),
      );
    }

    loadDataMenu(context);

    homeVM.isLoading = false;
  }

  //cargar menu
  loadDataMenu(BuildContext context) {
    //limmpiar listas que se usan
    menuActive.clear();
    routeMenu.clear();
    menu.clear();

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
        name: AppLocalizations.of(context)!.translate(
          BlockTranslate.home,
          'aplicacion',
        ),
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
