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

    final bool succesComentarios = await vmComentarios.armarComentario(context);

    if (!succesComentarios) return;

    // vmComentarios.armarComentario(context);

    Navigator.pushNamed(context, AppRoutes.viewComments);
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
