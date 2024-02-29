import 'package:flutter/material.dart';

import '../models/models.dart';

class UsuariosViewModel extends ChangeNotifier {
  final TextEditingController buscarUsuario = TextEditingController();

  List<UsuarioModel> usuarios = [
    UsuarioModel(
      email: "acabrera@demosoftonline.com",
      userName: "acabrera",
      name: "Antony Cabrera (acabrera)",
    ),
    UsuarioModel(
      email: "rlacarreta@gmail.com",
      userName: "LACARRETA01",
      name: "Fredy (LACARRETA01)",
    ),
    UsuarioModel(
      email: "kortega@delacasa.com.gt",
      userName: "DLCASA01",
      name: "Karina Ortega (DLCASA01)",
    ),
    UsuarioModel(
      email: "salvador@delacasa.com.gt",
      userName: "DLCASA03",
      name: "Keren Bonilla (DLCASA03)",
    ),
    UsuarioModel(
      email: "auditoria@delacasa.com.gt",
      userName: "DLCASA07",
      name: "Stuardo (DLCASA07)",
    ),
    UsuarioModel(
      email: "gerenciacomercial@delacasa.com.gt",
      userName: "DLCASA06",
      name: "Usuario1 (DLCASA06)",
    ),
  ];

  List<UsuarioModel> usuariosEncontrados = [];

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
