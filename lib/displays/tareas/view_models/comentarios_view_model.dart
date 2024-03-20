// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/view_models/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ComentariosViewModel extends ChangeNotifier {
  //Almacenar comentarios de la tarea
  final List<ComentarioDetalleModel> comentarioDetalle = [];

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //comentario
  final TextEditingController comentarioController = TextEditingController();
  DateTime? fecha; //fecha para comentarios

  ComentariosViewModel() {
    fecha = DateTime.now();
  }

  //Nuevo comentario
  Future<ApiResModel> comentar(
    BuildContext context,
    String comentario,
  ) async {
    //ocultar teclado
    FocusScope.of(context).unfocus();

    //View model para obtener usuario y token
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    String user = loginVM.user;
    String token = loginVM.token;

    //View model de detalla de tarea
    final vmTarea = Provider.of<DetalleTareaViewModel>(context, listen: false);
    int idTarea = vmTarea.tarea!.iDTarea; //Id de la tarea

    //Instancia del servicio
    ComentarService comentarService = ComentarService();

    //Crear modelo de nuevo comentario
    ComentarModel comentario = ComentarModel(
      comentario: comentarioController.text,
      tarea: idTarea,
      userName: user,
    );

    isLoading = true; //cargar pantalla

    //consumo de api
    ApiResModel res = await comentarService.postComentar(
      token,
      comentario,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      ApiResModel comentarioNuevo = ApiResModel(
        message: comentario,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      //Respuesta incorrecta
      return comentarioNuevo;
    }

    //Crear modelo de comentario
    ComentarioModel comentarioCreado = ComentarioModel(
      comentario: comentarioController.text,
      fechaHora: fecha!,
      nameUser: user,
      userName: user,
      tarea: idTarea,
      tareaComentario: res.message.res,
    );

    ApiResModel comentarioNuevo = ApiResModel(
      message: comentarioCreado,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    //Crear modelo de comentario detalle, (comentario y objetos)
    comentarioDetalle.add(
      ComentarioDetalleModel(comentario: comentarioNuevo.message, objetos: []),
    );

    notifyListeners();

    comentarioController.text = ""; //limpiar input

    isLoading = false; //detener carga

    //Retornar respuesta correcta
    return comentarioNuevo;
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

      ApiResModel comentario = ApiResModel(
        message: comentarios,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      //Si algo salió mal retornar
      return comentario;
    }

    //Agregar repuesta de api a la lista de comentarios
    comentarios.addAll(res.message);

    isLoading = false; //detener carga

    ApiResModel comentario = ApiResModel(
      message: comentarios,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    //Si todo está correcto retornar
    return comentario;
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

      ApiResModel objetos = ApiResModel(
        message: objetosComentario,
        succes: false,
        url: "",
        storeProcedure: '',
      );

      //Si algo salió mal, retornar:
      return objetos;
    }

    //Almacener respuesta de api a la lista de objetosComentario
    objetosComentario.addAll(res.message);

    isLoading = false; //detener carga

    ApiResModel objetos = ApiResModel(
      message: objetosComentario,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    //Si todo está correcto, retornar:
    return objetos;
  }

  //Armar comentarios con objetos adjuntos
  Future<bool> armarComentario(BuildContext context) async {
    comentarioDetalle.clear(); //limpiar lista de detalleComentario

    //View model de Detalle tarea para obtener el id de la tarea
    final vmTarea = Provider.of<DetalleTareaViewModel>(context, listen: false)
        .tarea!
        .iDTarea;

    //Obtener comentarios de la tarea
    ApiResModel comentarios = await obtenerComentario(context, vmTarea);

    //Sino encontró comentarios retornar false
    if (!comentarios.succes) return false;

    //Recorrer lista de comentarios para obtener los objetos de los comentarios
    for (var i = 0; i < comentarios.message.length; i++) {
      final ComentarioModel coment = comentarios.message[i];

      //Obtener los objetos del comentario
      ApiResModel objeto = await obtenerObjetoComentario(
          context, vmTarea, coment.tareaComentario);

      //comentario completo (comentario y objetos)
      comentarioDetalle.add(ComentarioDetalleModel(
        comentario: comentarios.message[i],
        objetos: objeto.message,
      ));
    }

    //si todo está bien retornar true
    return true;
  }

  //Formatear fecha
  String formatearFecha(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la fecha en el formato dd-mm-yyyy
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    return fechaFormateada;
  }
}
