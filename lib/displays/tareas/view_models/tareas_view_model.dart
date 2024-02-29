// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
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
  // final List<PeriodicidadModel> periodicidades = [];
  final List<ResponsableModel> responsables = [];
  final List<InvitadoModel> invitados = [];
  final List<UsuarioModel> usuarios = [];
  final List<IdReferenciaModel> idReferencias = [];

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

  showError(BuildContext context, ApiResModel res) {
    ErrorModel error = ErrorModel(
      date: DateTime.now(),
      description: res.message,
      storeProcedure: res.storeProcedure,
    );

    NotificationService.showErrorView(
      context,
      error,
    );
  }

  //Obtener Responsable y responsables anteriores de la tarea
  Future<void> obtenerResponsable(
    BuildContext context,
    int tarea,
  ) async {
    responsables.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getResponsable(
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

    responsables.addAll(res.message);

    print(responsables[0].userName);

    isLoading = false;
  }

  //Obtener Invitados de la tarea
  Future<void> obtenerInvitados(
    BuildContext context,
    int tarea,
  ) async {
    invitados.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getInvitado(
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

    invitados.addAll(res.message);

    print(invitados[0].userName);

    isLoading = false;
  }

  crearTarea(BuildContext context) async {
    // obtenerPeriodicidad(context);
    // obtenerComentario(context, 4500);
    // obtenerObjetoComentario(context, 4500, 9952);
    // obtenerResponsable(context, 5113);
    // obtenerInvitados(context, 5113);
    // buscarIdRefencia(context, "012");
    // buscarUsuario(context, "aca");

    //view modles
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);

    isLoading = true;
    //consumos
    final bool succesTipos = await vmCrear.obtenerTiposTarea(context);
    final bool succesEstados = await vmCrear.obtenerEstados(context);
    final bool succesPrioridades = await vmCrear.obtenerPrioridades(context);
    final bool succesPeriodicidades =
        await vmCrear.obtenerPeriodicidad(context);

    if (!succesTipos ||
        !succesEstados ||
        !succesPrioridades ||
        !succesPeriodicidades) return;

    Navigator.pushNamed(context, AppRoutes.createTask);

    isLoading = false;
  }

  verDetalles(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.detailsTask);
  }

  detalleTarea(BuildContext context, TareaModel tarea) {
    isLoading = true;
    final vmDetalle =
        Provider.of<DetalleTareaViewModel>(context, listen: false);
    vmDetalle.tarea = tarea;

    Navigator.pushNamed(context, AppRoutes.detailsTask);
    isLoading = false;
  }

  String formatearFecha(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la fecha en el formato dd-mm-yyyy
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    return fechaFormateada;
  }
}
