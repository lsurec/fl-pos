// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TareasViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int todas = 0;
  int creadas = 1;
  int invitaciones = 2;
  int asignadas = 3;

  late TabController tabController;

  //formulario para buscar tareas
  GlobalKey<FormState> formKeySearch = GlobalKey<FormState>();
  GlobalKey<FormState> formCreadasKeySearch = GlobalKey<FormState>();
  GlobalKey<FormState> formAsignadasKeySearch = GlobalKey<FormState>();
  GlobalKey<FormState> formInvitacioesKeySearch = GlobalKey<FormState>();

  //imput de busqueda de tareas
  final TextEditingController searchController = TextEditingController();
  int? filtro = 1; //para filtro de busqueda Inicialmente por descripcion

  int vistaDetalle = 0;

  //Lista de tareas
  final List<TareaModel> tareas = [];

  bool creadasCarga = false;
  bool asignadasCarga = false;
  bool invitacionesCarga = false;
  bool todasCarga = false;

  final List<TareaModel> tareasGenerales = [];
  final List<TareaModel> tareasCreadas = [];
  final List<TareaModel> tareasInvitaciones = [];
  final List<TareaModel> tareasAsignadas = [];

  //funcion para buscar tareas segun el filtro marcado
  searchText(BuildContext context) {
    //filtro = 1 es por descripcion
    if (filtro == 1) {
      buscarTareasDescripcion(context, searchController.text);
    }
    //filtro = 2 es por id de referencia
    if (filtro == 2) {
      buscarTareasIdReferencia(context, searchController.text);
    }
  }

  //Validar formulario barra busqueda
  bool isValidFormCSearchAnterior() {
    return formKeySearch.currentState?.validate() ?? false;
  }

  bool isValidFormCSearch() {
    return formKeySearch.currentState?.validate() ?? false;
    // switch (tabController.index) {
    //   case 0:
    //   case 1:
    //     return formCreadasKeySearch.currentState?.validate() ?? false;
    //   case 2:
    //     return formInvitacioesKeySearch.currentState?.validate() ?? false;
    //   case 3:
    //     return formAsignadasKeySearch.currentState?.validate() ?? false;
    //   default:
    //     return false;
    // }
  }

  //Asignar el valor del filtro seleccionado.
  busqueda(int filtro) {
    this.filtro = filtro;
    notifyListeners();
  }

  //Obtener ultimas 10 tareas
  Future<void> loadData(BuildContext context) async {
    vistaDetalle = 1;
    await obtenerTareasTodas(context);
    await obtenerTareasCreadas(context);
    await obtenerTareasInvitaciones(context);
    await obtenerTareasAsignadas(context);

    // limpiar(0);
    // List<TareaModel> encontradas = [];
    // encontradas.clear(); //limpiar lista
    // searchController.clear();

    // //obtener token y usuario
    // final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    // String token = vmLogin.token;
    // String user = vmLogin.user;

    // //instancia del servicio
    // final TareaService tareaService = TareaService();

    // isLoading = true; //cargar pantalla

    // //consumo de api
    // final ApiResModel res = await tareaService.getTopTareas(user, token);

    // //si el consumo salió mal
    // if (!res.succes) {
    //   isLoading = false;
    //   NotificationService.showErrorView(context, res);
    //   return;
    // }
    // //agregar tareas encontradas a la lista de tareas
    // encontradas.addAll(res.response);
    // //Registros encontrados
    // registros = encontradas.length;

    // //tipo 1 = ultimas tareas
    // asignarTareas(encontradas, 0);

    // isLoading = false; //detener carga
  }

  asignarTareas(List<TareaModel> tareasEncontradas, int tipo) {
    if (tipo == 0) {
      tareasGenerales.addAll(tareasEncontradas);
      tareasCreadas.addAll(tareasEncontradas);
      tareasInvitaciones.addAll(tareasEncontradas);
      tareasAsignadas.addAll(tareasEncontradas);
    }

    if (tipo == 1) {
      switch (tabController.index) {
        case 0:
          return tareasGenerales.addAll(tareasEncontradas);
        case 1:
          return tareasCreadas.addAll(tareasEncontradas);
        case 2:
          return tareasInvitaciones.addAll(tareasEncontradas);
        case 3:
          return tareasAsignadas.addAll(tareasEncontradas);
        default:
          return false;
      }
    }
  }

  //buscar por filtro: Descripción
  Future<void> buscarTareasDescripcion(
    BuildContext context,
    String search,
  ) async {
    //Validar formulario
    if (!isValidFormCSearch()) return;
    tareas.clear(); //limpiar lista

    //obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia del servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //consumo de api
    final ApiResModel res =
        await tareaService.getTareasDescripcion(user, token, search);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);
      return;
    }

    //agregar a la lista las tareas encontradas
    tareas.addAll(res.response);

    isLoading = false; //detener carga
  }

  int registros = 0;

  //buscar por filtro: Descripción
  Future<void> buscarTareas(
    BuildContext context,
    String search,
    int opcion,
  ) async {
    //limpiar listas
    limpiar(1);
    //Validar formulario
    if (!isValidFormCSearch()) return;
    // tareas.clear(); //limpiar lista
    List<TareaModel> encontradas = [];
    encontradas.clear(); //limpiar lista

    //obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia del servicio
    final TareaService tareaService = TareaService();

    //ocultar teclado
    FocusScope.of(context).unfocus();

    isLoading = true; //cargar pantalla

    //consumo de api
    final ApiResModel res = await tareaService.getTareas(
      user,
      token,
      search,
      tabController.index,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(
        context,
        res,
      );
      return;
    }

    //agregar tareas encontradas a la lista de tareas
    encontradas.addAll(res.response);

    registros = encontradas.length;

    //Tipo 1 = Busqueda
    asignarTareas(encontradas, 1);

    if (encontradas.isEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinCoincidencias',
        ),
      );
    }

    isLoading = false; //detener carga
  }

  //Rangos
  int vermas = 0;
  int rangoIni = 1;
  int rangoFin = 10;
  int rangoTodasIni = 1;
  int rangoTodasFin = 10;
  int rangoCreadasIni = 1;
  int rangoCreadasFin = 10;
  int rangoAsignadasIni = 1;
  int rangoAsignadasFin = 10;
  int rangoInvitacionesIni = 1;
  int rangoInvitacionesFin = 10;
  int intervaloRegistros = 10;

  //Buscar tareas por rango
  Future<void> buscarRangoTareas(
    BuildContext context,
    String search,
    int vermas,
  ) async {
    //obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia del servicio
    final TareaService tareaService = TareaService();

    //Validar formulario
    if (!isValidFormCSearch()) return;

    //si tareas está vacio, reestablecer los rangos
    if (tareas.isEmpty) {
      rangoIni = 1;
      rangoFin = intervaloRegistros;
    }

    // Realiza la búsqueda
    //si ver mas es = 1 aumenta los rangos
    if (vermas == 1) {
      isLoading = true; //cargar pantalla

      //consumo de api
      final ApiResModel res = await tareaService.getRangoTareas(
        user,
        token,
        search,
        rangoIni,
        rangoFin,
      );

      //si el consumo salió mal
      if (!res.succes) {
        isLoading = false;
        NotificationService.showErrorView(
          context,
          res,
        );
        return;
      }

      tareas.addAll(res.response);

      isLoading = false; //detener cargar pantalla

      rangoIni = tareas.length + 1;
      rangoFin = rangoIni + intervaloRegistros;

      //sino
    } else {
      //Limpiar lista
      tareas.clear();

      rangoIni = 1;
      rangoFin = 10;

      isLoading = true;

      //consumo de api
      final ApiResModel resTarea = await tareaService.getRangoTareas(
        user,
        token,
        search,
        rangoIni,
        rangoFin,
      );

      //si el consumo salió mal
      if (!resTarea.succes) {
        isLoading = false;
        NotificationService.showErrorView(
          context,
          resTarea,
        );
        return;
      }

      //Si se ejecuto bien, obtener la respuesta de Api Buscar Tareas
      tareas.addAll(resTarea.response);

      isLoading = false;

      rangoIni += intervaloRegistros;
      rangoFin += intervaloRegistros;
    }
  }

  //Buscar por filtro: Id de referencia
  Future<void> buscarTareasIdReferencia(
    BuildContext context,
    String search,
  ) async {
    //validar formulario
    if (!isValidFormCSearch()) return;
    tareas.clear(); //limpiar lista

    //Obtener user y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia de servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //Consumo del api
    final ApiResModel res =
        await tareaService.getTareasIdReferencia(user, token, search);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);
      return;
    }

    //Agregar a la lista las tareas encontradas.
    tareas.addAll(res.response);

    isLoading = false; //detener carga
  }

  //Realizar consumos y navegar a crear tarea
  crearTarea(BuildContext context) async {
    //view models Crear Tarea
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);

    isLoading = true; //cargar pantalla
    vmCrear.idPantalla = 1; //desde tareas
    //consumos
    final bool succesTipos =
        await vmCrear.obtenerTiposTarea(context); //tipos de tarea

    if (!succesTipos) {
      isLoading = false;
      return;
    }

    final bool succesEstados =
        await vmCrear.obtenerEstados(context); //estados de tarea
    if (!succesEstados) {
      isLoading = false;
      return;
    }
    final bool succesPrioridades =
        await vmCrear.obtenerPrioridades(context); //prioridades de tarea
    if (!succesPrioridades) {
      isLoading = false;
      return;
    }

    final bool succesPeriodicidades =
        await vmCrear.obtenerPeriodicidad(context); //periodicidades
    if (!succesPeriodicidades) {
      isLoading = false;
      return;
    }
    vmCrear.fechaInicial = DateTime.now();
    vmCrear.fechaFinal = vmCrear.addDate10Min(vmCrear.fechaInicial);

    vmCrear.files.clear();

    //Navegar a la vista de crear tareas
    Navigator.pushNamed(context, AppRoutes.createTask);

    isLoading = false; //Detener carga
  }

  //Consumo de servicios para navegar a los detalles de la tarea
  detalleTarea(BuildContext context, TareaModel tarea) async {
    vistaDetalle = 1; // desde tareas.
    
    isLoading = true; //cargar pantalla
    //view model de Detalle
    final vmDetalle = Provider.of<DetalleTareaViewModel>(
      context,
      listen: false,
    );

    vmDetalle.tarea = tarea; //guardar la tarea
    final ApiResModel succesResponsables = await vmDetalle.obtenerResponsable(
      context,
      tarea.iDTarea,
    ); //obtener responsable activo de la tarea

    if (!succesResponsables.succes) {
      isLoading = false;
      return;
    }

    final ApiResModel succesInvitados = await vmDetalle.obtenerInvitados(
      context,
      tarea.iDTarea,
    ); //obtener invitados de la tarea

    if (!succesInvitados.succes) {
      isLoading = false;
      return;
    }

    //viwe model de Crear tarea
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);
    final bool succesEstados = await vmCrear.obtenerEstados(
      context,
    ); //obtener estados de tarea

    if (!succesEstados) {
      isLoading = false;
      return;
    }
    final bool succesPrioridades = await vmCrear.obtenerPrioridades(
      context,
    ); //obtener prioridades de la tarea

    if (!succesPrioridades) {
      isLoading = false;
      return;
    }

    //Mostrar estado actual de la tarea en ls lista de estados
    for (var i = 0; i < vmCrear.estados.length; i++) {
      EstadoModel estado = vmCrear.estados[i];
      if (estado.estado == tarea.estadoObjeto) {
        vmDetalle.estadoAtual = estado;
        break;
      }
    }
    //Mostrar prioridad actual de la tarea en ls lista de prioridades
    for (var i = 0; i < vmCrear.prioridades.length; i++) {
      PrioridadModel prioridad = vmCrear.prioridades[i];
      if (prioridad.nivelPrioridad == tarea.nivelPrioridad) {
        vmDetalle.prioridadActual = prioridad;
        break;
      }
    }

    //validar resppuesta de los comentarios
    final bool succesComentarios = await armarComentario(context);

    //sino se realizo el consumo correctamente retornar
    if (!succesComentarios) {
      isLoading = false;
      return;
    }

    //Navegar a detalles
    Navigator.pushNamed(
      context,
      AppRoutes.detailsTask,
    );

    isLoading = false; //detener carga
  }

  //insertar nueva tarea al inicio de la lista de tareas
  insertarTarea(TareaModel tarea) {
    tareas.insert(0, tarea);
    notifyListeners();
  }

  //Armar comentarios con objetos adjuntos
  Future<bool> armarComentario(BuildContext context) async {
    final vmComentario =
        Provider.of<ComentariosViewModel>(context, listen: false);
    vmComentario.comentarioDetalle.clear(); //limpiar lista de detalleComentario

    //View model de Detalle tarea para obtener el id de la tarea
    final vmTarea = Provider.of<DetalleTareaViewModel>(context, listen: false);

    //Obtener comentarios de la tarea
    ApiResModel comentarios =
        await vmTarea.obtenerComentario(context, vmTarea.tarea!.iDTarea);

    //Sino encontró comentarios retornar false
    if (!comentarios.succes) return false;

    //Recorrer lista de comentarios para obtener los objetos de los comentarios
    for (var i = 0; i < comentarios.response.length; i++) {
      final ComentarioModel coment = comentarios.response[i];

      //Obtener los objetos del comentario
      ApiResModel objeto = await vmTarea.obtenerObjetoComentario(
        context,
        vmTarea.tarea!.iDTarea,
        coment.tareaComentario,
      );

      //comentario completo (comentario y objetos)
      vmComentario.comentarioDetalle.add(ComentarioDetalleModel(
        comentario: comentarios.response[i],
        objetos: objeto.response,
      ));
    }

    //si todo está bien retornar true
    return true;
  }

  GlobalKey<FormState> getGlobalKey(int keyType) {
    switch (keyType) {
      case 0:
        return formKeySearch;
      case 1:
        return formCreadasKeySearch;
      case 2:
        return formInvitacioesKeySearch;
      case 3:
        return formAsignadasKeySearch;
      // Puedes agregar más casos según sea necesario
      default:
        throw ArgumentError('Invalid key type: $keyType');
    }
  }

  limpiarLista(BuildContext context) {
    // tareas.clear(); //limpiar lista
    searchController.clear();
  }

  limpiar(int tipo) {
    if (tipo == 0) {
      tareasGenerales.clear();
      tareasCreadas.clear();
      tareasInvitaciones.clear();
      tareasAsignadas.clear();
    }

    if (tipo == 1) {
      switch (tabController.index) {
        case 0:
          return tareasGenerales.clear();
        case 1:
          return tareasCreadas.clear();
        case 2:
          return tareasInvitaciones.clear();
        case 3:
          return tareasAsignadas.clear();
        default:
          return false;
      }
    }
  }

  navegarBusqueda(
    BuildContext context,
  ) {
    //Navegar a la vista de crear tareas
    Navigator.pushNamed(
      context,
      AppRoutes.searchTask,
    );
  }

  //Regresar a la pantalla anterior y limpiar
  Future<bool> back() async {
    searchController.clear();
    rangoIni = 0;
    rangoFin = 0;
    tareas.clear();
    return true;
  }

  Future<void> cargarTodas(
    BuildContext context,
  ) async {
    //cargar todas
  }

  Future<void> cargarAsignadas(
    BuildContext context,
  ) async {
    //cargar asignadas
  }

  Future<void> cargarInvitaciones(
    BuildContext context,
  ) async {
    //cargar invitaciones
  }

  Future<void> cargarCreadas(
    BuildContext context,
  ) async {
    //cargar creadas
  }

  obtenerTareasTodas(
    BuildContext context,
  ) async {
    tareasGenerales.clear();
    rangoTodasIni = 1;
    rangoTodasFin = intervaloRegistros;

    //Obtener user y token
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia de servicio
    final TareaService tareaService = TareaService();

    isLoading = true;
    //Consumo de api
    ApiResModel resTarea = await tareaService.getRangoTodas(
      user,
      token,
      rangoTodasIni,
      rangoTodasFin,
    );

    //si algo salio mal
    if (!resTarea.succes) {
      isLoading = false;

      NotificationService.showErrorView(
        context,
        resTarea,
      );

      return;
    }

    //Si se ejecuto bien, obtener la respuesta de Api Buscar Tareas
    tareasGenerales.addAll(resTarea.response);

    isLoading = false;

    rangoTodasIni = tareasGenerales[tareasGenerales.length - 1].id + 1;
    rangoTodasFin = rangoTodasIni + 10;
  }

  obtenerTareasCreadas(
    BuildContext context,
  ) async {
    tareasCreadas.clear();
    rangoCreadasIni = 1;
    rangoCreadasFin = intervaloRegistros;

    //Obtener user y token
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia de servicio
    final TareaService tareaService = TareaService();

    isLoading = true;
    //Consumo de api
    ApiResModel resTarea = await tareaService.getRangoCreadas(
      user,
      token,
      rangoCreadasIni,
      rangoCreadasFin,
    );

    isLoading = false;

    //si algo salio mal
    if (!resTarea.succes) {
      isLoading = false;

      NotificationService.showErrorView(
        context,
        resTarea,
      );

      return;
    }

    //Si se ejecuto bien, obtener la respuesta de Api Buscar Tareas
    tareasCreadas.addAll(resTarea.response);

    rangoCreadasIni = tareasCreadas[tareasCreadas.length - 1].id + 1;
    rangoCreadasFin = rangoCreadasIni + 10;
  }

  obtenerTareasAsignadas(
    BuildContext context,
  ) async {
    tareasAsignadas.clear();
    rangoAsignadasIni = 1;
    rangoAsignadasFin = intervaloRegistros;
    //Obtener user y token
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia de servicio
    final TareaService tareaService = TareaService();

    isLoading = true;
    //Consumo de api
    ApiResModel resTarea = await tareaService.getRangoAsignadas(
      user,
      token,
      rangoAsignadasIni,
      rangoAsignadasFin,
    );

    //si algo salio mal
    if (!resTarea.succes) {
      isLoading = false;

      NotificationService.showErrorView(
        context,
        resTarea,
      );

      return;
    }

    //Si se ejecuto bien, obtener la respuesta de Api Buscar Tareas
    tareasAsignadas.addAll(resTarea.response);

    isLoading = false;

    if (tareasInvitaciones.isEmpty) {
      return;
    }

    rangoAsignadasIni = tareasAsignadas[tareasAsignadas.length - 1].id + 1;
    rangoAsignadasFin = rangoAsignadasIni + 10;
  }

  obtenerTareasInvitaciones(
    BuildContext context,
  ) async {
    tareasInvitaciones.clear();
    rangoInvitacionesIni = 1;
    rangoInvitacionesFin = intervaloRegistros;
    //Obtener user y token
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia de servicio
    final TareaService tareaService = TareaService();

    isLoading = true;
    //Consumo de api
    ApiResModel resTarea = await tareaService.getRangoInvitaciones(
      user,
      token,
      rangoInvitacionesIni,
      rangoInvitacionesFin,
    );

    //si algo salio mal
    if (!resTarea.succes) {
      isLoading = false;

      NotificationService.showErrorView(
        context,
        resTarea,
      );

      return;
    }

    //Si se ejecuto bien, obtener la respuesta de Api Buscar Tareas
    tareasInvitaciones.addAll(resTarea.response);

    isLoading = false;

    if (tareasInvitaciones.isEmpty) {
      return;
    }

    rangoInvitacionesIni =
        tareasInvitaciones[tareasInvitaciones.length - 1].id + 1;
    rangoInvitacionesFin = rangoInvitacionesIni + 10;
  }

  recargarTodas(
    BuildContext context,
  ) async {
    //Obtener user y token
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia de servicio
    final TareaService tareaService = TareaService();

    todasCarga = true;

    //aumentar los rangos
    ApiResModel resTarea = await tareaService.getRangoTodas(
      user,
      token,
      rangoInvitacionesIni,
      rangoInvitacionesFin,
    );

    //si algo salio mal
    if (!resTarea.succes) {
      todasCarga = false;

      NotificationService.showErrorView(
        context,
        resTarea,
      );

      return;
    }

    //Si se ejecuto bien, obtener la respuesta de Api Buscar Tareas
    List<TareaModel> tareasMas = resTarea.response;

    todasCarga = false;

    // Insertar la lista de tareas en `tareasFiltro`
    tareasGenerales.addAll(tareasMas);

    //actualizar rangos
    int mas10 = 10;

    rangoTodasIni = tareasGenerales[tareasGenerales.length - 1].id + 1;
    rangoTodasFin = rangoTodasIni + intervaloRegistros + mas10;
  }

  recargarCreadas(
    BuildContext context,
  ) async {
    //Obtener user y token
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia de servicio
    final TareaService tareaService = TareaService();

    creadasCarga = true;

    //aumentar los rangos
    ApiResModel resTarea = await tareaService.getRangoCreadas(
      user,
      token,
      rangoInvitacionesIni,
      rangoInvitacionesFin,
    );

    //si algo salio mal
    if (!resTarea.succes) {
      creadasCarga = false;

      NotificationService.showErrorView(
        context,
        resTarea,
      );

      return;
    }

    //Si se ejecuto bien, obtener la respuesta de Api Buscar Tareas
    List<TareaModel> tareasMas = resTarea.response;

    creadasCarga = false;

    // Insertar la lista de tareas en `tareasFiltro`
    tareasCreadas.addAll(tareasMas);

    //actualizar rangos
    int mas10 = 10;

    rangoCreadasIni = tareasCreadas[tareasCreadas.length - 1].id + 1;
    rangoCreadasFin = rangoCreadasIni + intervaloRegistros + mas10;
  }

  recargarAsignadas(
    BuildContext context,
  ) async {
    //Obtener user y token
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia de servicio
    final TareaService tareaService = TareaService();

    asignadasCarga = true;

    //aumentar los rangos
    ApiResModel resTarea = await tareaService.getRangoAsignadas(
      user,
      token,
      rangoInvitacionesIni,
      rangoInvitacionesFin,
    );

    //si algo salio mal
    if (!resTarea.succes) {
      asignadasCarga = false;

      NotificationService.showErrorView(
        context,
        resTarea,
      );

      return;
    }

    //Si se ejecuto bien, obtener la respuesta de Api Buscar Tareas
    List<TareaModel> tareasMas = resTarea.response;

    asignadasCarga = false;

    // Insertar la lista de tareas en `tareasFiltro`
    tareasAsignadas.addAll(tareasMas);

    //actualizar rangos
    int mas10 = 10;

    rangoAsignadasIni = tareasAsignadas[tareasAsignadas.length - 1].id + 1;
    rangoAsignadasFin = rangoAsignadasIni + intervaloRegistros + mas10;
  }

  recargarInvitaciones(
    BuildContext context,
  ) async {
    //Obtener user y token
    final vmLogin = Provider.of<LoginViewModel>(
      context,
      listen: false,
    );

    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia de servicio
    final TareaService tareaService = TareaService();

    invitacionesCarga = true;

    //aumentar los rangos
    ApiResModel resTarea = await tareaService.getRangoInvitaciones(
      user,
      token,
      rangoInvitacionesIni,
      rangoInvitacionesFin,
    );

    //si algo salio mal
    if (!resTarea.succes) {
      invitacionesCarga = false;

      NotificationService.showErrorView(
        context,
        resTarea,
      );

      return;
    }

    //Si se ejecuto bien, obtener la respuesta de Api Buscar Tareas
    List<TareaModel> tareasMas = resTarea.response;

    invitacionesCarga = false;

    // Insertar la lista de tareas en `tareasFiltro`
    tareasInvitaciones.addAll(tareasMas);

    //actualizar rangos
    int mas10 = 10;

    rangoAsignadasIni =
        tareasInvitaciones[tareasInvitaciones.length - 1].id + 1;
    rangoAsignadasFin = rangoAsignadasIni + intervaloRegistros + mas10;
  }
}
