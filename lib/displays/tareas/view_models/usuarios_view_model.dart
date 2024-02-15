import 'package:flutter/material.dart';

import '../models/models.dart';

class UsuariosViewModel extends ChangeNotifier {
  final TextEditingController buscarUsuario = TextEditingController();

  List<UsuariosModel> usuarios = [
    UsuariosModel(
      email: "acabrera@demosoftonline.com",
      userName: "acabrera",
      name: "Antony Cabrera (acabrera)",
    ),
    UsuariosModel(
      email: "rlacarreta@gmail.com",
      userName: "LACARRETA01",
      name: "Fredy (LACARRETA01)",
    ),
    UsuariosModel(
      email: "kortega@delacasa.com.gt",
      userName: "DLCASA01",
      name: "Karina Ortega (DLCASA01)",
    ),
    UsuariosModel(
      email: "salvador@delacasa.com.gt",
      userName: "DLCASA03",
      name: "Keren Bonilla (DLCASA03)",
    ),
    UsuariosModel(
      email: "auditoria@delacasa.com.gt",
      userName: "DLCASA07",
      name: "Stuardo (DLCASA07)",
    ),
    UsuariosModel(
      email: "gerenciacomercial@delacasa.com.gt",
      userName: "DLCASA06",
      name: "Usuario1 (DLCASA06)",
    ),
  ];

  List<UsuariosModel> usuariosEncontrados = [];

  buscar(String criterio) {
    usuariosEncontrados.clear(); // Limpiar la lista filtrada actual

    if (criterio.isEmpty) {
      // Si el campo de filtrado está vacío, mostrar la lista original
      usuariosEncontrados = [];
    } else {
      // Filtrar la lista original basada en el texto ingresado
      usuariosEncontrados.addAll(
        usuarios.where((element) =>
            element.name.toLowerCase().contains(criterio.toLowerCase())),
      );
    }

    notifyListeners();
  }
}
