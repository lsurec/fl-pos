// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';

import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../view_models/view_models.dart';

class DetalleTareaViewModel extends ChangeNotifier {
  final List<InvitadoModel> invitados = [];
  EstadoModel? estadoAtual;
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  TareaModel? tarea;
  final List<String> estados = [
    'Activo',
    'Cerrado',
    'Pendiente',
    'Inactivo',
    'Anulado',
    'Finalizado'
  ];

  final List<String> prioridades = [
    'Critico',
    'Alto',
    'Normal',
    'Bajo',
  ];

  String? nuevoEstado; //almacenar nuevo estado
  String? nuevaPrioridad; //almacenar nueva prioridad

  final formEstado = GlobalKey<FormState>();
  final formPrioridad = GlobalKey<FormState>();

  verComentarios(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.viewComments,
        arguments: tarea!.tareaObservacion1);
  }

  comentariosTarea(BuildContext context) async {
    isLoading = true;
    final vmComentarios =
        Provider.of<ComentariosViewModel>(context, listen: false);

    final bool succesComentarios = await vmComentarios.armarComentario(context);

    if (!succesComentarios) return;

    Navigator.pushNamed(context, AppRoutes.viewComments);
    isLoading = false;
  }

  //Obtener Responsable y responsables anteriores de la tarea
  Future<ApiResModel> obtenerResponsable(
    BuildContext context,
    int idTarea,
  ) async {
    List<ResponsableModel> responsables = [];
    responsables.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

    final ApiResModel res = await tareaService.getResponsable(
      user,
      token,
      idTarea,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      showError(context, res);

      ApiResModel responsable = ApiResModel(
        message: responsables,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return responsable;
    }

    responsables.addAll(res.message);

    isLoading = false;

    ApiResModel responsable = ApiResModel(
      message: responsables,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    return responsable;
  }

  //Obtener Invitados de la tarea
  Future<ApiResModel> obtenerInvitados(
    BuildContext context,
    int tarea,
  ) async {
    // List<InvitadoModel> invitados = [];

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

      showError(context, res);

      ApiResModel invitado = ApiResModel(
        message: invitados,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return invitado;
    }

    invitados.addAll(res.message);

    isLoading = false;

    ApiResModel invitado = ApiResModel(
      message: invitados,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    return invitado;
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

  String formatearFecha(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la fecha en el formato dd-mm-yyyy
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    return fechaFormateada;
  }

  String formatearHora(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la hora en formato hh:mm a AM/PM
    String horaFormateada = DateFormat('hh:mm a').format(fecha);

    return horaFormateada;
  }
}
