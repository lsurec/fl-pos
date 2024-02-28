import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/tarea_service.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TareasViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  GlobalKey<FormState> formKeySearch = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();

//Validar formulario barra busqueda
  bool isValidFormCSearch() {
    return formKeySearch.currentState?.validate() ?? false;
  }

  String buscar = ""; //para buscar tareas
  int? filtro = 1; //para filtro de busqueda Inicialmente por descripcion
  DateTime fecha = DateTime.now(); //obtener fecha actual

//Lista ejemplo de las tareas
  final List<TareaModel> tareas = [];
  final List<EstadoModel> estados = [];
  final List<TipoTareaModel> tiposTarea = [];
  final List<PrioridadModel> prioridades = [];
  final List<ComentarioModel> comentarios = [];

  performSearch() {
    if (filtro == 1) {
      print("Formulario valido, Filtro $filtro por Descripcion");
    }
    if (filtro == 2) {
      print("Formulario valido, Filtro $filtro por ID Referencia");
    }
    if (!isValidFormCSearch()) return;
    print("Formulario valido");
    //TODO:Funcion buscar
  }

  busqueda(int filtro) {
    this.filtro = filtro;
    notifyListeners();
  }

  Future<void> loadData(BuildContext context) async {
    tareas.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getTopTareas(user, token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    tareas.addAll(res.message);

    isLoading = false;
  }

  //buscar por filtro

  Future<void> buscarTareasDescripcion(
    BuildContext context,
    String search,
  ) async {
    tareas.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;
    final ApiResModel res =
        await tareaService.getTareasDescripcion(user, token, search);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    tareas.addAll(res.message);

    isLoading = false;
  }

  //Buscar por id de referencia
  Future<void> buscarTareasIdReferencia(
    BuildContext context,
    String search,
  ) async {
    tareas.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res =
        await tareaService.getTareasIdReferencia(user, token, search);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    tareas.addAll(res.message);

    isLoading = false;
  }

  //Obtener Estados
  Future<void> obtenerEstados(
    BuildContext context,
  ) async {
    estados.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    // String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getEstado(token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    estados.addAll(res.message);

    print(estados[0]);

    isLoading = false;
  }

  //Obtener Tipos
  Future<void> obtenerTiposTarea(
    BuildContext context,
  ) async {
    tiposTarea.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getTipoTarea(user, token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    tiposTarea.addAll(res.message);

    print(tiposTarea[0]);

    isLoading = false;
  }

  //Obtener Prioridades
  Future<void> obtenerPrioridades(
    BuildContext context,
  ) async {
    prioridades.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getPrioridad(user, token);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    prioridades.addAll(res.message);

    print(prioridades[0]);

    isLoading = false;
  }

  //Obtener Prioridades
  Future<void> obtenerComentarios(
    BuildContext context,
    int tarea,
  ) async {
    comentarios.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getComentarios(
      user,
      token,
      tarea,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }

    comentarios.addAll(res.message);

    print(comentarios[0]);

    isLoading = false;
  }

  crearTarea(BuildContext context) async {
    obtenerEstados(context);
    obtenerTiposTarea(context);
    obtenerPrioridades(context);
    obtenerComentarios(context, 4500);
    // Navigator.pushNamed(context, AppRoutes.createTask);
  }

  verDetalles(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.detailsTask);
  }

  String formatearFecha(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la fecha en el formato dd-mm-yyyy
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    return fechaFormateada;
  }
}
