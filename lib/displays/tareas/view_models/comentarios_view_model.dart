import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';

DateTime fecha = DateTime.now();

class ComentariosViewModel extends ChangeNotifier {
  String comentText = ""; //comenrario nuevo

  final TextEditingController comentarioController = TextEditingController();

  List<ComentarioNuevoModel> comentarios = [
    ComentarioNuevoModel(
      comentario: "Comentario no.1",
      tareaComentario: 4061,
      tarea: 4000,
      nameUser: "Maria Ejemplo (DESA01)",
      userName: 'DESA01',
      fechaHora: "fecha",
    ),
    ComentarioNuevoModel(
      comentario: "Comentario no.2",
      tareaComentario: 4062,
      tarea: 4000,
      nameUser: "Maria Ejemplo (DESA01)",
      userName: 'DESA01',
      fechaHora: "fecha",
    ),
    ComentarioNuevoModel(
      comentario: "Comentario no.3",
      tareaComentario: 4063,
      tarea: 4000,
      nameUser: "Maria Ejemplo (DESA01)",
      userName: 'DESA01',
      fechaHora: "fecha",
    ),
  ];

  comentar(BuildContext context) {
    if (comentarioController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingrese un comentario.',
          ),
        ),
      );
      return;
    }
    final ComentarioNuevoModel comentario = ComentarioNuevoModel(
      comentario: comentarioController.text,
      fechaHora: "fecha",
      nameUser: "DESA02",
      tarea: 4000,
      tareaComentario: 4600,
      userName: "Mario ejemplo (Desa02)",
    );

    comentarios.add(comentario); //agregar comentario a la lista

    comentarioController.text = ''; //limpiar textformfield

    notifyListeners();
  }

  String observacion = "1235435";
}
