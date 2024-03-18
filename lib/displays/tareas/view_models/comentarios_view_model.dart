// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/view_models/login_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

DateTime fecha = DateTime.now();

class ComentariosViewModel extends ChangeNotifier {
  // final List<ComentarioModel> comentarios = [];
  // final List<ObjetoComentarioModel> objetosComentario = [];
  final List<ComentarioDetalleModel> comentarioDetalle = [];

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  final TextEditingController comentarioController = TextEditingController();

  Future<ApiResModel> comentar(
    BuildContext context,
    String comentario,
  ) async {
    //ocultar teclado
    FocusScope.of(context).unfocus();

    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    final vmTarea = Provider.of<DetalleTareaViewModel>(context, listen: false);

    //usuario y token
    String user = loginVM.user;
    String token = loginVM.token;
    int idTarea = vmTarea.tarea!.iDTarea;

    ComentarService comentarService = ComentarService();

    ComentarModel comentario = ComentarModel(
      comentario: comentarioController.text,
      tarea: idTarea,
      userName: user,
    );

    isLoading = true;

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

      return comentarioNuevo;
    }

    ComentarioModel comentarioCreado = ComentarioModel(
      comentario: comentarioController.text,
      fechaHora: fecha,
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

    comentarioDetalle.add(
      ComentarioDetalleModel(comentario: comentarioNuevo.message, objetos: []),
    );

    notifyListeners();

    comentarioController.text = ""; //limpiar input
    isLoading = false;

    return comentarioNuevo;
  }

//Obtener Comentarios de la tarea
  Future<ApiResModel> obtenerComentario(
    BuildContext context,
    int tarea,
  ) async {
    List<ComentarioModel> comentarios = [];
    comentarios.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    final TareaService tareaService = TareaService();

    isLoading = true;

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

      return comentario;
    }

    comentarios.addAll(res.message);

    isLoading = false;

    ApiResModel comentario = ApiResModel(
      message: comentarios,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    return comentario;
  }

  //Obtener Objetos de un comentario de una tarea
  Future<ApiResModel> obtenerObjetoComentario(
    BuildContext context,
    int tarea,
    int tareaComentario,
  ) async {
    List<ObjetoComentarioModel> objetosComentario = [];

    objetosComentario.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    // String user = vmLogin.nameUser;

    final TareaService tareaService = TareaService();

    isLoading = true;

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

      return objetos;
    }

    objetosComentario.addAll(res.message);

    isLoading = false;

    ApiResModel objetos = ApiResModel(
      message: objetosComentario,
      succes: true,
      url: "",
      storeProcedure: '',
    );

    return objetos;
  }

  Future<bool> armarComentario(BuildContext context) async {
    comentarioDetalle.clear();
    final vmTarea = Provider.of<DetalleTareaViewModel>(context, listen: false)
        .tarea!
        .iDTarea;

    ApiResModel comentarios = await obtenerComentario(context, vmTarea);

    for (var i = 0; i < comentarios.message.length; i++) {
      final ComentarioModel coment = comentarios.message[i];

      ApiResModel objeto = await obtenerObjetoComentario(
          context, vmTarea, coment.tareaComentario);

      //comentario completo
      comentarioDetalle.add(ComentarioDetalleModel(
          comentario: comentarios.message[i], objetos: objeto.message));

      if (!comentarios.succes) return false;
    }

    return true;
  }

  String formatearFecha(DateTime fecha) {
    // Asegurarse de que la fecha esté en la zona horaria local
    fecha = fecha.toLocal();

    // Formatear la fecha en el formato dd-mm-yyyy
    String fechaFormateada = DateFormat('dd/MM/yyyy').format(fecha);

    return fechaFormateada;
  }
}
