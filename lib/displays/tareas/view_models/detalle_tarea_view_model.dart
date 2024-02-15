import 'package:flutter/material.dart';

class DetalleTareaViewModel extends ChangeNotifier {
  List<bool> expanded = [false, false]; //deplegar cambio de estado y prioridad

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
  String observacion =
      "Lorem ipsum dolor sit amet consectetur adipisicing elit. Laborum fugiat ipsum ipsam recusandae velit ut, alias veniam odit! Perferendis esse repellat cum doloribus possimus provident mollitia fugiat sint repudiandae eius.";
  int idTarea = 3010;

  final formEstado = GlobalKey<FormState>();
  final formPrioridad = GlobalKey<FormState>();

  verComentarios(BuildContext context) {
    Navigator.pushNamed(context, "comentarios", arguments: observacion);
  }
}
