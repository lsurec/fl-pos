// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/comentarios_view_model.dart';

import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetalleTareaViewModel extends ChangeNotifier {
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
    final vmComentarios =
        Provider.of<ComentariosViewModel>(context, listen: false);

    final bool succesComentarios =
        await vmComentarios.obtenerComentario(context, tarea!.iDTarea);

    for (var i = 0; i < vmComentarios.comentarios.length; i++) {}

    final bool succesObjetos = await vmComentarios.obtenerObjetoComentario(
        context, tarea!.iDTarea, 9952);

    if (!succesComentarios || !succesObjetos) return;

    Navigator.pushNamed(context, AppRoutes.viewComments);
  }

  armarComentario(BuildContext context) {
    final vmComentarios =
        Provider.of<ComentariosViewModel>(context, listen: false);

    for (var i = 0; i < vmComentarios.comentarios.length; i++) {
      ComentarioModel comentario = vmComentarios.comentarios[i];

      vmComentarios.obtenerObjetoComentario(
          context, tarea!.iDTarea, comentario.tareaComentario);

      // vmComentarios.comentario = [
      //   comentario = vmComentarios.comentarios[i],
      //   objetos = vmComentarios.objetosComentario

      // ];
    }
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
