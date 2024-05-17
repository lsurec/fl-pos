// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/models.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class DetalleTareaCalendarioViewModel extends ChangeNotifier {
  //cargar pantalla
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  TareaCalendarioModel? tarea; //tarea del calendario
  EstadoModel? estadoAtual; //nuevo estado
  PrioridadModel? prioridadActual; //nueva prioridad

  //historial de los responsables
  List<ResponsableModel> responsablesHistorial = [];
  final List<InvitadoModel> invitados = []; //alamcenar invitados

  bool historialResposables = false; //mostrra y ocultar historial

  //Volver a cargar detalles
  loadData(BuildContext context) async {
    isLoading = true; //cargar pantalla
    estadoAtual = null;
    prioridadActual = null;

    final ApiResModel succesResponsables = await obtenerResponsable(
      context,
      tarea!.tarea,
    ); //obtener responsable activo de la tarea

    if (!succesResponsables.succes) {
      isLoading = false;
      return;
    }

    final ApiResModel succesInvitados = await obtenerInvitados(
      context,
      tarea!.tarea,
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
      EstadoModel estadoTarea = vmCrear.estados[i];
      if (estadoTarea.estado == tarea!.estado) {
        estadoAtual = estadoTarea;
        break;
      }
    }
    //Mostrar prioridad actual de la tarea en ls lista de prioridades
    for (var i = 0; i < vmCrear.prioridades.length; i++) {
      PrioridadModel prioridad = vmCrear.prioridades[i];
      if (prioridad.nivelPrioridad == tarea!.nivelPrioridad) {
        prioridadActual = prioridad;
        break;
      }
    }

    isLoading = false; //detener carga
  }

  //Cargar comentarios
  comentariosTarea(BuildContext context) async {
    isLoading = true; //cargar pantalla
    //View model de tareas
    final vmTarea = Provider.of<CalendarioViewModel>(context, listen: false);

    //validar resppuesta de los comentarios
    final bool succesComentarios = await vmTarea.armarComentario(context);

    //sino se realizo el consumo correctamente retornar
    if (!succesComentarios) {
      isLoading = false;
      return;
    }

    //View model de tareas
    final vmComentarios =
        Provider.of<ComentariosViewModel>(context, listen: false);
    //limpiar lista de archivos seleccionados
    vmComentarios.files.clear();

    //navegar a comentarios
    vmComentarios.vistaTarea = 2;
    notifyListeners();
    Navigator.pushNamed(context, AppRoutes.viewComments);
    isLoading = false; //detener carga
  }

  //Ver y ocultar historial de responsables
  verHistorial() {
    historialResposables = !historialResposables;
    notifyListeners();
  }

  //Eliminar usuario invitado de la tarea
  eliminarInvitado(
    BuildContext context,
    InvitadoModel invitado,
    int index,
  ) async {}

  //Obtener Responsable y responsables anteriores de la tarea
  Future<ApiResModel> obtenerResponsable(
    BuildContext context,
    int idTarea,
  ) async {
    //Lista de responsables
    final List<ResponsableModel> responsablesTarea = [];
    responsablesTarea.clear(); //limpiar lista
    responsablesHistorial.clear(); //Limpiar lista

    //View model Login, obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //Instancia del servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //Consumo de api
    final ApiResModel res = await tareaService.getResponsable(
      user,
      token,
      idTarea,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);

      return res;
    }

    //añadir a la lista los usuarios responsables encontrados
    responsablesTarea.addAll(res.message);

    //recorrer la lista y buscar los de estado "inactivo"
    for (var i = 0; i < responsablesTarea.length; i++) {
      ResponsableModel responsable = responsablesTarea[i];
      if (responsable.estado.toLowerCase() == "inactivo") {
        //insertarlo en la lista del historial
        responsablesHistorial.add(responsable);
        notifyListeners();
        break;
      }
    }

    isLoading = false; //detener carga

    //retornar respuesta correcta
    return res;
  }

  //Obtener Invitados de la tarea
  Future<ApiResModel> obtenerInvitados(
    BuildContext context,
    int tarea,
  ) async {
    invitados.clear(); //invitados

    //View model de login para obtener token y usuario
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //Instancia de servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //Cargar pantalla

    //Consumo de api.
    final ApiResModel res = await tareaService.getInvitado(
      user,
      token,
      tarea,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      return res;
    }

    //Agregar a lista de invitados
    invitados.addAll(res.message);
    //Retornar respuesta correcta
    isLoading = false; //detener carga

    return res;
  }

  //Obtener Comentarios de la tarea
  Future<ApiResModel> obtenerComentario(
    BuildContext context,
    int tarea,
  ) async {
    //Almacenar comentarios de la tarea
    List<ComentarioModel> comentarios = [];
    comentarios.clear();

    //View model Login para obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //Instancia del servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //Consumo de servicio
    final ApiResModel res = await tareaService.getComentario(
      user,
      token,
      tarea,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);

      //Si algo salió mal retornar
      return res;
    }

    //Agregar repuesta de api a la lista de comentarios
    comentarios.addAll(res.message);

    isLoading = false; //detener carga

    //Si todo está correcto retornar
    return res;
  }

  //Obtener Objetos de un comentario de una tarea
  Future<ApiResModel> obtenerObjetoComentario(
    BuildContext context,
    int tarea,
    int tareaComentario,
  ) async {
    //Almacenar objetos del comentario
    List<ObjetoComentarioModel> objetosComentario = [];
    objetosComentario.clear(); //limpiar lista de objetos del comentario

    //View model de Login para obtener token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;

    //Instancia del servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //Consumo de api
    final ApiResModel res = await tareaService.getObjetoComentario(
      token,
      tarea,
      tareaComentario,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;
      NotificationService.showErrorView(context, res);

      //Si algo salió mal, retornar:
      return res;
    }

    //Almacener respuesta de api a la lista de objetosComentario
    objetosComentario.addAll(res.message);

    isLoading = false; //detener carga

    //Si todo está correcto, retornar:
    return res;
  }

  //Actualizar el estado de la tarea
  Future<ApiResModel> actualizarEstado(
    BuildContext context,
    EstadoModel estado,
  ) async {
    //View model para obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //View model comentario
    final vmComentarios =
        Provider.of<ComentariosViewModel>(context, listen: false);

    //Instancia del servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //Crear modelo de nuevo estado
    ActualizarEstadoModel actualizar = ActualizarEstadoModel(
      userName: user,
      estado: estado.estado,
      tarea: tarea!.tarea,
    );

    //Consumo de api
    final ApiResModel res = await tareaService.postEstadoTarea(
      token,
      actualizar,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      //Retornar respuesta incorrecta
      return res;
    }
    //Crear comentario por el cambio de estado.
    ComentarioModel comentario = ComentarioModel(
      comentario:
          "Cambio de estado ( ${estado.descripcion} ) realizado por usuario $user.",
      fechaHora: DateTime.now(),
      nameUser: user,
      userName: user,
      tarea: tarea!.tarea,
      tareaComentario: 0,
    );

    //Asignar nuevo estado a la tarea
    tarea!.estado = estado.estado; // asignar id estado
    tarea!.desTarea = estado.descripcion; // asignar estado

    //Insertar comentario a la Lista de comentarios
    vmComentarios.comentarioDetalle.add(
      ComentarioDetalleModel(
        comentario: comentario,
        objetos: [],
      ),
    );

    NotificationService.showSnackbar(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.mensajes,
        'estadoActualizado',
      ),
    );

    isLoading = false; //detener carga
    //Retornar respuesta incorrecta
    return res;
  }

  //Actualizar el nivel de prioridad de la tarea
  Future<ApiResModel> actualizarPrioridad(
    BuildContext context,
    PrioridadModel prioridad,
  ) async {
    //View model de login para obtener el usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //View model de comentarios
    final vmComentarios =
        Provider.of<ComentariosViewModel>(context, listen: false);

    //Instancia del servicio
    final TareaService tareaService = TareaService();

    isLoading = true; //cargar pantalla

    //Crear modelo de nueva prioridad
    ActualizarPrioridadModel actualizar = ActualizarPrioridadModel(
      userName: user,
      prioridad: prioridad.nivelPrioridad,
      tarea: tarea!.tarea,
    );

    //Consumo de api
    final ApiResModel res = await tareaService.postPrioridadTarea(
      token,
      actualizar,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      //Retornar respuesta incorrecta
      return res;
    }

    //Crear comentario por cambio de nueva prioridad.
    ComentarioModel comentario = ComentarioModel(
      comentario:
          "Cambio de Nivel de Prioridad  ( ${prioridad.nombre} ) realizado por usuario $user.",
      fechaHora: DateTime.now(),
      nameUser: user,
      userName: user,
      tarea: tarea!.tarea,
      tareaComentario: 0,
    );

    //Asignar la nueva prioridad a la tarea
    tarea!.nivelPrioridad = prioridad.nivelPrioridad; // asignar id prioridad
    tarea!.nomNivelPrioridad = prioridad.nombre; // asignar prioridad

    //Insertar nuevo comentario  ala lsiat de comentarios
    vmComentarios.comentarioDetalle.add(
      ComentarioDetalleModel(
        comentario: comentario,
        objetos: [],
      ),
    );

    NotificationService.showSnackbar(
      AppLocalizations.of(context)!.translate(
        BlockTranslate.mensajes,
        'prioridadActualizada',
      ),
    );

    isLoading = false; //detener carga

    //Retornar resspuesta correcta
    return res;
  }
}
