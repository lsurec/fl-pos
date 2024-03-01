// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/tarea_service.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/view_models/login_view_model.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

DateTime fecha = DateTime.now();

class ComentariosViewModel extends ChangeNotifier {
  final List<ComentarioModel> comentarios = [];
  final List<ObjetoComentarioModel> objetosComentario = [];
  List<ComentarioDetalle> comentarioDetalle = [];

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String comentText = ""; //comenrario nuevo

  final TextEditingController comentarioController = TextEditingController();

  comentar(BuildContext context) {
    // if (comentarioController.text == "") {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //       content: Text(
    //         'Ingrese un comentario.',
    //       ),
    //     ),
    //   );
    //   return;
    // }
    // final ComentarioNuevoModel comentario = ComentarioNuevoModel(
    //   comentario: comentarioController.text,
    //   fechaHora: "fecha",
    //   nameUser: "DESA02",
    //   tarea: 4000,
    //   tareaComentario: 4600,
    //   userName: "Mario ejemplo (Desa02)",
    // );

    // comentarios.add(comentario); //agregar comentario a la lista

    // comentarioController.text = ''; //limpiar textformfield

    // notifyListeners();
  }

//Obtener Comentarios de la tarea
  Future<bool> obtenerComentario(
    BuildContext context,
    int tarea,
  ) async {
    comentarios.clear();

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

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
      showError(context, res);
      return false;
    }

    comentarios.addAll(res.message);

    isLoading = false;

    return true;
  }

  //Obtener Objetos de un comentario de una tarea
  Future<bool> obtenerObjetoComentario(
    BuildContext context,
    int tarea,
    int tareaComentario,
  ) async {
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
      showError(context, res);
      return false;
    }

    objetosComentario.addAll(res.message);

    isLoading = false;
    return true;
  }

  armarComentario(BuildContext context) {
    final vmTarea = Provider.of<DetalleTareaViewModel>(context, listen: false);

    for (var i = 0; i < comentarios.length; i++) {
      final ComentarioModel coment = comentarios[i];

      obtenerObjetoComentario(
          context, vmTarea.tarea!.iDTarea, coment.tareaComentario);

      comentarioDetalle = [
        ComentarioDetalle(comentario: coment, objetos: objetosComentario),
      ];
    }
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
}
