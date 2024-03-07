// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import '../models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class UsuariosViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  int tipoBusqueda = 1;

  final TextEditingController buscar = TextEditingController();

  final List<UsuarioModel> usuarios = [];
  final List<UsuarioModel> usuariosSeleccionados = [];

  Future<bool> back() async {
    buscar.clear();
    usuarios.clear();
    usuariosSeleccionados.clear();
    return true;
  }

  Future<void> buscarUsuario(
    BuildContext context,
    String search,
  ) async {
    usuarios.clear();

    if (search.isEmpty) {
      usuarios.clear();
      notifyListeners();
      print("Ingrese un caracter para realizar una busqueda");
      return;
    }

    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.nameUser;

    final UsuarioService usuarioService = UsuarioService();

    isLoading = true;
    final ApiResModel res =
        await usuarioService.getUsuario(user, token, search);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      ErrorModel error = ErrorModel(
        date: DateTime.now(),
        description: res.message,
        storeProcedure: res.storeProcedure,
      );

      NotificationService.showErrorView(
        context,
        error,
      );

      return;
    }
    usuarios.addAll(res.message);
    isLoading = false;
  }

  void changeChecked(
    bool? value,
    int index,
  ) {
    usuarios[index].select = value!;
    notifyListeners();
  }
}
