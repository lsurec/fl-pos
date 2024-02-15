import 'package:flutter/material.dart';

import '../models/models.dart';

class IdReferenciaViewModel extends ChangeNotifier {
  //variable de busqueda
  final TextEditingController buscarIdReferencia = TextEditingController();

  List<IdReferenciaModel> idReferencias = [
    IdReferenciaModel(
      referencia: 20,
      descripcion: "SALUD PARA TODOS, S.A.",
      referenciaId: "P20",
    ),
    IdReferenciaModel(
      referencia: 26,
      descripcion: "TORNILLOS & FIJACIONES, S.A.",
      referenciaId: "P26",
    ),
    IdReferenciaModel(
      referencia: 27,
      descripcion: "CORPORACION PETAPA, S.A.",
      referenciaId: "P27",
    ),
    IdReferenciaModel(
      referencia: 28,
      descripcion: "SISTEMAS Y CONTROLES DE DISTRIBUCIÓN, S.A.",
      referenciaId: "P28",
    ),
    IdReferenciaModel(
      referencia: 642,
      descripcion: "",
      referenciaId: "0123",
    ),
  ];

  List<IdReferenciaModel> listaFiltrada = [];

  filtrarLista(String criterio) {
    listaFiltrada.clear(); // Limpiar la lista filtrada actual

    if (criterio.isEmpty) {
      // Si el campo de filtrado está vacío, mostrar la lista original
      listaFiltrada = [];
    } else {
      // Filtrar la lista original basada en el texto ingresado
      listaFiltrada.addAll(
        idReferencias.where((element) =>
            element.descripcion.toLowerCase().contains(criterio.toLowerCase())),
      );
    }

    notifyListeners();
  }
}
