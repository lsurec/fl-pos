// ignore_for_file: use_build_context_synchronously

import '../../../view_models/view_models.dart';
import '../../../widgets/widgets.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetalleTareaViewModel extends ChangeNotifier {
  final List<InvitadoModel> invitados = []; //alamcenar invitados
  EstadoModel? estadoAtual; //nuevo estado
  PrioridadModel? prioridadActual; //nueva prioridad
  bool historialResposables = false; //mostrra y ocultar historial
  //Almacenar historias de resonsables de la tarea
  List<ResponsableModel> responsablesHistorial = [];
  //almacenar tarea
  TareaModel? tarea;

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  DateTime? fecha; //fecha para comentarios

  DetalleTareaViewModel() {
    fecha = DateTime.now();
  }

  //Cargar comentarios
  comentariosTarea(BuildContext context) async {
    isLoading = true; //cargar pantalla
    //View model de comentarios
    final vmComentarios =
        Provider.of<ComentariosViewModel>(context, listen: false);

    //validar resppuesta de los comentarios
    final bool succesComentarios = await vmComentarios.armarComentario(context);

    //sino se realizo el consumo correctamente retornar
    if (!succesComentarios) return;

    //navegar a comentarios
    Navigator.pushNamed(context, AppRoutes.viewComments);
    isLoading = false; //detener carga
  }

  //Obtener Responsable y responsables anteriores de la tarea
  Future<ApiResModel> obtenerResponsable(
    BuildContext context,
    int idTarea,
  ) async {
    //Lista de responsables
    List<ResponsableModel> responsablesTarea = [];
    responsablesTarea.clear(); //limpiar lista

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

      ApiResModel responsable = ApiResModel(
        message: responsablesTarea,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return responsable;
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

    ApiResModel responsable = ApiResModel(
      message: responsablesTarea,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    //retornar respuesta correcta
    return responsable;
  }

  //Obtener Invitados de la tarea
  Future<ApiResModel> obtenerInvitados(
    BuildContext context,
    int tarea,
  ) async {
    //Lista de invitados
    List<InvitadoModel> invitadosTarea = [];
    invitadosTarea.clear(); //invitados tarea
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

      //Retornar respuesta incorrecta
      ApiResModel invitado = ApiResModel(
        message: invitadosTarea,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      return invitado;
    }

    isLoading = false; //detener carga

    //Agregar invitados de la tarea encontrados
    invitadosTarea.addAll(res.message);

    ApiResModel invitado = ApiResModel(
      message: invitadosTarea,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    //Agregar a lista de invitados
    invitados.addAll(invitado.message);
    notifyListeners();
    //Retornar respuesta correcta
    return invitado;
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
      tarea: tarea!.iDTarea,
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

      ApiResModel nuevoEstado = ApiResModel(
        message: actualizar,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      //Retornar respuesta incorrecta
      return nuevoEstado;
    }
    //Crear comentario por el cambio de estado.
    ComentarioModel comentario = ComentarioModel(
      comentario:
          "Cambio de estado ( ${estado.descripcion} ) realizado por usuario $user.",
      fechaHora: fecha!,
      nameUser: user,
      userName: user,
      tarea: tarea!.iDTarea,
      tareaComentario: 0,
    );

    //Asignar nuevo estado a la tarea
    tarea!.estadoObjeto = estado.estado; // asignar id estado
    tarea!.tareaEstado = estado.descripcion; // asignar estado

    //Insertar comentario a la Lista de comentarios
    vmComentarios.comentarioDetalle.add(ComentarioDetalleModel(
      comentario: comentario,
      objetos: [],
    ));

    notifyListeners();

    ApiResModel nuevoEstado = ApiResModel(
      message: actualizar,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    isLoading = false; //detener carga
    //Retornar respuesta incorrecta
    return nuevoEstado;
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
      tarea: tarea!.iDTarea,
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

      ApiResModel nuevaPrioridad = ApiResModel(
        message: actualizar,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      //Retornar respuesta incorrecta
      return nuevaPrioridad;
    }

    //Crear comentario por cambio de nueva prioridad.
    ComentarioModel comentario = ComentarioModel(
      comentario:
          "Cambio de Nivel de Prioridad  ( ${prioridad.nombre} ) realizado por usuario $user.",
      fechaHora: fecha!,
      nameUser: user,
      userName: user,
      tarea: tarea!.iDTarea,
      tareaComentario: 0,
    );

    //Asignar la nueva prioridad a la tarea
    tarea!.nivelPrioridad = prioridad.nivelPrioridad; // asignar id prioridad
    tarea!.nomNivelPrioridad = prioridad.nombre; // asignar prioridad

    //Insertar nuevo comentario  ala lsiat de comentarios
    vmComentarios.comentarioDetalle.add(ComentarioDetalleModel(
      comentario: comentario,
      objetos: [],
    ));

    notifyListeners();

    ApiResModel nuevaPrioridad = ApiResModel(
      message: actualizar,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    isLoading = false; //detener carga

    //Retornar resspuesta correcta
    return nuevaPrioridad;
  }

  //Eliminar usuario invitado de la tarea
  Future<ApiResModel> eliminarInvitado(
    BuildContext context,
    InvitadoModel invitado,
    int index,
  ) async {
    //View model login para obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String user = vmLogin.user;
    String token = vmLogin.token;

    //Instancia del servicio
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

    //Crear modelo para eliminar invitado
    EliminarUsuarioModel eliminar = EliminarUsuarioModel(
      tarea: tarea!.iDTarea,
      userResInvi: "",
      user: user,
    );

    //Consumo de api
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

      //Retornar respuesta incorrecta
      return usuarioEliminado;
    }

    ApiResModel usuarioEliminado = ApiResModel(
      message: eliminar,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    //Eliminar invitado
    invitados.removeAt(index);

    notifyListeners();

    isLoading = false; //detener carga

    //Retornar respuesta correcta
    return usuarioEliminado;
  }

  //Formatear fecha
  String formatearFecha(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la fecha en el formato dd-mm-yyyy
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    return fechaFormateada;
  }

  //Formatear hora
  String formatearHora(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la hora en formato hh:mm a AM/PM
    String horaFormateada = DateFormat('hh:mm a').format(fecha);

    return horaFormateada;
  }

  //Invitados button
  invitadosButton(BuildContext context) {
    //View model usuarios
    final vmUsuario = Provider.of<UsuariosViewModel>(context, listen: false);
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);

    if (vmUsuario.tipoBusqueda == 4) {
      //Agregar invitados a la tarea desde detalles
      guardarInvitados(context);
    }
    if (vmUsuario.tipoBusqueda == 2) {
      //Guardar invitados de la tarea desde detalle
      vmCrear.guardarUsuarios(context);
    }
  }

  //Guardar nuevos invitados
  Future<ApiResModel> guardarInvitados(
    BuildContext context,
  ) async {
    // guardar invitados nuevos
    final List<ResNuevoUsuarioModel> resInvitado = [];
    resInvitado.clear(); //limpiar invitados

    //View model de usuarios
    final vmUsuarios = Provider.of<UsuariosViewModel>(context, listen: false);

    //View model de Login para obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String user = vmLogin.user;
    String token = vmLogin.token;

    //Instancia de servicio
    final TareaService tareaService = TareaService();

    final List<InvitadoModel> agregados = []; // guardar invitados nuevos

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

      //Respuesta del invitado
      resInvitado.add(res.message[0]);

      //Crear modelo del nuevo inivtado
      InvitadoModel agregarInvitado = InvitadoModel(
        tareaUserName: resInvitado[0].tareaUserName,
        eMail: usuarioInvitado.email,
        userName: usuarioInvitado.userName,
      );

      //Agregar inivtado a la lista de agregados
      agregados.add(agregarInvitado);

      notifyListeners();
    }

    //No hay repetidos
    if (!repetidos.isNotEmpty) {
      isLoading = true;
      //agregar invitados a la lista de invitados
      invitados.addAll(agregados);
      notifyListeners();

      NotificationService.showSnackbar(
        "Se actualizó la lista de invitados a la tarea.",
      );

      //Limpiar lista de usuarios seleccionados y usuarios encontrados
      vmUsuarios.usuariosSeleccionados.clear();
      vmUsuarios.usuarios.clear();
      isLoading = false; //detener carga
    } else {
      //Hay usuarios repetidos

      NotificationService.showSnackbar(
        "Uno o más usuarios seleccionados ya son invitados de la tarea.",
      );

      ApiResModel nuevoInvitado = ApiResModel(
        message: repetidos,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      //recorrer la lista de usuarios seleccionados y deselecionarlos
      for (var usuario in vmUsuarios.usuariosSeleccionados) {
        usuario.select = false;
      }

      //limpiar listas de usuarios seleccionados y usuarios encontrados
      vmUsuarios.usuariosSeleccionados.clear();
      vmUsuarios.usuarios.clear();
      notifyListeners();

      isLoading = false; //dentener carga

      //Retornar respuesta incorrecta
      return nuevoInvitado;
    }

    //Respuesta correcta
    ApiResModel nuevoInvitado = ApiResModel(
      message: agregados,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    //limpiar listas de usuarios seleccionados y usuarios encontrados
    vmUsuarios.usuariosSeleccionados.clear();
    vmUsuarios.usuarios.clear();

    notifyListeners();

    Navigator.pop(context); //regresar a vista anterior

    isLoading = false; //detener carga

    //Retornar respuesta correcta
    return nuevoInvitado;
  }

  //Ver y ocultar historial de responsables
  verHistorial() {
    historialResposables = !historialResposables;
    notifyListeners();
  }

  //Volver a cargar detalles
  loadData(BuildContext context) async {
    //final vm = Provider.of<CrearTareaViewModel>(context, listen: false);
    // vm.estados.clear();
    // vm.periodicidades.clear();
    // vm.periodicidades.clear();
    // await vm.obtenerEstados(context);
    // await vm.obtenerPrioridades(context);
    // await vm.obtenerPeriodicidad(context);
    await obtenerInvitados(context, tarea!.iDTarea);
    await obtenerResponsable(context, tarea!.iDTarea);
  }
}
