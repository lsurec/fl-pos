import 'package:flutter/material.dart';

import '../models/models.dart';

class IdReferenciaViewModel extends ChangeNotifier {
  //variable de busqueda
  final TextEditingController buscarIdReferencia = TextEditingController();

  List<IdReferenciaModel> idReferencias = [];

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
