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
import '../../../widgets/widgets.dart';

class DetalleTareaViewModel extends ChangeNotifier {
  final List<InvitadoModel> invitados = [];
  EstadoModel? estadoAtual;
  PrioridadModel? prioridadActual;
  bool historialResposables = false;

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  TareaModel? tarea;

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

  List<ResponsableModel> responsablesHistorial = [];

  //Obtener Responsable y responsables anteriores de la tarea
  Future<ApiResModel> obtenerResponsable(
    BuildContext context,
    int idTarea,
  ) async {
    List<ResponsableModel> responsablesTarea = [];
    responsablesTarea.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

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
      NotificationService.showErrorView(context, res);

      ApiResModel responsable = ApiResModel(
        message: responsablesTarea,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return responsable;
    }

    responsablesTarea.addAll(res.message);

    for (var i = 0; i < responsablesTarea.length; i++) {
      ResponsableModel responsable = responsablesTarea[i];
      if (responsable.estado.toLowerCase() == "inactivo") {
        responsablesHistorial.add(responsable);
        notifyListeners();
        break;
      }
    }

    isLoading = false;

    ApiResModel responsable = ApiResModel(
      message: responsablesTarea,
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
    List<InvitadoModel> invitadosTarea = [];
    invitadosTarea.clear();
    invitados.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

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

      NotificationService.showErrorView(context, res);

      ApiResModel invitado = ApiResModel(
        message: invitadosTarea,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return invitado;
    }

    isLoading = false;

    invitadosTarea.addAll(res.message);

    ApiResModel invitado = ApiResModel(
      message: invitadosTarea,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    invitados.addAll(invitado.message);
    notifyListeners();
    return invitado;
  }

  //Actualizar el estado de la tarea
  Future<ApiResModel> actualizarEstado(
    BuildContext context,
    EstadoModel estado,
  ) async {
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    final vmComentarios =
        Provider.of<ComentariosViewModel>(context, listen: false);

    String token = vmLogin.token;
    String user = vmLogin.user;

    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    ActualizarEstadoModel actualizar = ActualizarEstadoModel(
        userName: user, estado: estado.estado, tarea: tarea!.iDTarea);

    final ApiResModel res = await tareaService.postEstadoTarea(
      token,
      actualizar,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      ApiResModel nuevoEstado = ApiResModel(
        message: actualizar,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return nuevoEstado;
    }

    ApiResModel nuevoEstado = ApiResModel(
      message: actualizar,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    ComentarioModel comentario = ComentarioModel(
      comentario:
          "Cambio de estado ( ${estado.descripcion} ) realizado por usuario $user.",
      fechaHora: fecha,
      nameUser: user,
      userName: user,
      tarea: tarea!.iDTarea,
      tareaComentario: 0,
    );

    tarea!.estadoObjeto = estado.estado; // asignar id estado
    tarea!.tareaEstado = estado.descripcion; // asignar estado

    vmComentarios.comentarioDetalle.add(ComentarioDetalleModel(
      comentario: comentario,
      objetos: [],
    ));

    notifyListeners();

    isLoading = false; //detener carga

    return nuevoEstado;
  }

  //Actualizar el nivel de prioridad de la tarea
  Future<ApiResModel> actualizarPrioridad(
    BuildContext context,
    PrioridadModel prioridad,
  ) async {
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    final vmComentarios =
        Provider.of<ComentariosViewModel>(context, listen: false);

    String token = vmLogin.token;
    String user = vmLogin.user;

    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    ActualizarPrioridadModel actualizar = ActualizarPrioridadModel(
        userName: user,
        prioridad: prioridad.nivelPrioridad,
        tarea: tarea!.iDTarea);

    final ApiResModel res = await tareaService.postPrioridadTarea(
      token,
      actualizar,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      ApiResModel nuevaPrioridad = ApiResModel(
        message: actualizar,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return nuevaPrioridad;
    }

    ApiResModel nuevaPrioridad = ApiResModel(
      message: actualizar,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    ComentarioModel comentario = ComentarioModel(
      comentario:
          "Cambio de Nivel de Prioridad  ( ${prioridad.nombre} ) realizado por usuario $user.",
      fechaHora: fecha,
      nameUser: user,
      userName: user,
      tarea: tarea!.iDTarea,
      tareaComentario: 0,
    );

    tarea!.nivelPrioridad = prioridad.nivelPrioridad; // asignar id prioridad
    tarea!.nomNivelPrioridad = prioridad.nombre; // asignar prioridad

    vmComentarios.comentarioDetalle.add(ComentarioDetalleModel(
      comentario: comentario,
      objetos: [],
    ));

    notifyListeners();

    isLoading = false; //detener carga

    return nuevaPrioridad;
  }

  //Actualizar el nivel de prioridad de la tarea
  Future<ApiResModel> eliminarInvitado(
    BuildContext context,
    InvitadoModel invitado,
    int index,
  ) async {
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);

    String user = vmLogin.user;
    String token = vmLogin.token;

    final TareaService tareaService = TareaService();

    //mostrar dialogo de confirmacion
    bool result = await showDialog(
          context: context,
          builder: (context) => AlertWidget(
            title: "¿Estás seguro?",
            description:
                "Este usuario será eliminado de la lista de invitados de esta tarea.",
            onOk: () => Navigator.of(context).pop(true),
            onCancel: () => Navigator.of(context).pop(false),
          ),
        ) ??
        false;

    ApiResModel cancelar = ApiResModel(
      message: "",
      succes: false,
      url: "",
      storeProcedure: '',
    );

    if (!result) return cancelar;

    isLoading = true; //cargar pantalla

    EliminarUsuarioModel eliminar = EliminarUsuarioModel(
      tarea: tarea!.iDTarea,
      userResInvi: "",
      user: user,
    );

    final ApiResModel res = await tareaService.postEliminarInvitado(
      token,
      eliminar,
      invitado.tareaUserName,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      ApiResModel usuarioEliminado = ApiResModel(
        message: eliminar,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return usuarioEliminado;
    }

    ApiResModel usuarioEliminado = ApiResModel(
      message: eliminar,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    invitados.removeAt(index);

    notifyListeners();

    isLoading = false; //detener carga

    return usuarioEliminado;
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

  Future<ApiResModel> guardarInvitados(
    BuildContext context,
  ) async {
    // guardar invitados nuevos
    final List<ResNuevoUsuarioModel> resInvitado = [];
    resInvitado.clear();

    final vmUsuarios = Provider.of<UsuariosViewModel>(context, listen: false);
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);

    String user = vmLogin.user;
    String token = vmLogin.token;

    final TareaService tareaService = TareaService();

    final List<InvitadoModel> agregados = []; // guardar invitados nuevos
    // final List<InvitadoModel> resInvitado = []; // guardar invitados nuevos

    final List<String> repetidos = []; //guardar invitados repetidos

    //encontrar usuarios seleccionados
    for (var usuario in vmUsuarios.usuarios) {
      if (usuario.select) {
        vmUsuarios.usuariosSeleccionados.add(usuario);
      }
    }
    //verificar que no hayan repetidos
    for (var usuarioInvitado in vmUsuarios.usuariosSeleccionados) {
      repetidos.clear();
      // Verificar si el usuario ya está en la lista de invitados
      if (invitados.any((inv) => inv.userName == usuarioInvitado.userName)) {
        repetidos.add(usuarioInvitado.userName);
        continue;
      }

      //usuario nuevo
      NuevoUsuarioModel invitado = NuevoUsuarioModel(
        tarea: tarea!.iDTarea,
        userResInvi: usuarioInvitado.userName,
        user: user,
      );

      isLoading = true; //cargar pantalla

      //consumo de api
      final ApiResModel res = await tareaService.postInvitados(
        token,
        invitado,
      );

      //si el consumo salió mal
      if (!res.succes) {
        NotificationService.showErrorView(context, res);

        ApiResModel nuevoInvitado = ApiResModel(
          message: res.message,
          succes: false,
          url: "",
          storeProcedure: '',
        );

        isLoading = false;
        return nuevoInvitado;
      }

      resInvitado.add(res.message[0]);

      InvitadoModel agregarInvitado = InvitadoModel(
        tareaUserName: resInvitado[0].tareaUserName,
        eMail: usuarioInvitado.email,
        userName: usuarioInvitado.userName,
      );

      agregados.add(agregarInvitado);

      notifyListeners();
    }

    if (!repetidos.isNotEmpty) {
      print("${repetidos.length}, no hay repetidos");

      isLoading = true;
      //agregar invitados
      invitados.addAll(agregados);
      notifyListeners();

      NotificationService.showSnackbar(
        "Se actualizó la lista de invitados a la tarea.",
      );

      vmUsuarios.usuariosSeleccionados.clear();
      vmUsuarios.usuarios.clear();
      isLoading = false;
    } else {
      print("${repetidos.length}, si hay repetidos");

      NotificationService.showSnackbar(
        "Uno o más usuarios seleccionados ya son invitados de la tarea.",
      );

      ApiResModel nuevoInvitado = ApiResModel(
        message: repetidos,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      for (var usuario in vmUsuarios.usuariosSeleccionados) {
        usuario.select = false;
      }
      vmUsuarios.usuariosSeleccionados.clear();
      vmUsuarios.usuarios.clear();
      notifyListeners();
      isLoading = false;
      return nuevoInvitado;
    }

    ApiResModel nuevoInvitado = ApiResModel(
      message: agregados,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    vmUsuarios.usuariosSeleccionados.clear();
    vmUsuarios.usuarios.clear();

    // invitados.addAll(agregados);

    notifyListeners();

    Navigator.pop(context);

    isLoading = false;

    return nuevoInvitado;
  }

  // Función para verificar usuarios repetidos
  List<String> usuariosRepetidos(
    List<UsuarioModel> usuariosSelec,
    List<InvitadoModel> invitados,
  ) {
    List<String> repetidos = [];
    for (var usuarioInvitado in usuariosSelec) {
      if (invitados.any((inv) => inv.userName == usuarioInvitado.userName)) {
        repetidos.add(usuarioInvitado.userName);
      }
    }
    return repetidos;
  }

  verHistorial() {
    historialResposables = !historialResposables;
    notifyListeners();
  }
}
