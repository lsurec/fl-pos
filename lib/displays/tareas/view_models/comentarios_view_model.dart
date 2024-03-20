// ignore_for_file: use_build_context_synchronously

import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
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

  //Nuevo comentario
  Future<void> comentar(
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

      //Respuesta incorrecta
      return;
    }

    //Crear modelo de comentario
    ComentarioModel comentarioCreado = ComentarioModel(
      comentario: comentarioController.text,
      fechaHora: DateTime.now(),
      nameUser: user,
      userName: user,
      tarea: idTarea,
      tareaComentario: res.message.res,
    );

    //Crear modelo de comentario detalle, (comentario y objetos)
    comentarioDetalle.add(
      ComentarioDetalleModel(
        comentario: comentarioCreado,
        objetos: [],
      ),
    );

    comentarioController.text = ""; //limpiar input

    isLoading = false; //detener carga

    //Retornar respuesta correcta
    return;
  }

  loadData(BuildContext context) async {
    isLoading = true; //cargar pantalla
    //View model de comentarios
    final vmTarea = Provider.of<TareasViewModel>(context, listen: false);

    //validar resppuesta de los comentarios
    final bool succesComentarios = await vmTarea.armarComentario(context);

    //sino se realizo el consumo correctamente retornar
    if (!succesComentarios) {
      isLoading = false;
      return;
    }

    isLoading = false; //detener carga
  }
}
