// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
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

  late TabController tabController;

  //formulario para buscar tareas
  GlobalKey<FormState> formKeySearch = GlobalKey<FormState>();

  //imput de busqueda de tareas
  final TextEditingController searchController = TextEditingController();
  int? filtro = 1; //para filtro de busqueda Inicialmente por descripcion

  //Lista de tareas
  final List<TareaModel> tareas = [];

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
  bool isValidFormCSearch() {
    return formKeySearch.currentState?.validate() ?? false;
  }

  //Asignar el valor del filtro seleccionado.
  busqueda(int filtro) {
    this.filtro = filtro;
    notifyListeners();
  }

  //Obtener ultimas 10 tareas
  Future<void> loadData(BuildContext context) async {
    tareas.clear(); //limpiar lista

    //obtener token y usuario
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //instancia del servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //consumo de api
    final ApiResModel res = await tareaService.getTopTareas(user, token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);
      return;
    }
    //agregar tareas encontradas a la lista de tareas
    tareas.addAll(res.response);

    isLoading = false; //detener carga
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
    Navigator.pushNamed(context, AppRoutes.detailsTask);
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
}
