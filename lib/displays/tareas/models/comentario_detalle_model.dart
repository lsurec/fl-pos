import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';

class ComentarioDetalleModel {
  ComentarioModel comentario;
  List<ObjetoComentarioModel> objetos;

  ComentarioDetalleModel({
    required this.comentario,
    required this.objetos,
  });
}
