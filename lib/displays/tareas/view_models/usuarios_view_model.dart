// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';

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
    buscar.clear();
    return true;
  }

  Future<void> buscarUsuarioService(
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
    String user = vmLogin.user;

    final UsuarioService usuarioService = UsuarioService();

    isLoading = true;
    final ApiResModel res =
        await usuarioService.getUsuario(user, token, search);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      return;
    }
    usuarios.addAll(res.message);
    isLoading = false;
  }

  void changeChecked(bool? value, int index) {
    // Invertir el valor actual
    usuarios[index].select = !usuarios[index].select;
    notifyListeners();
  }

  Timer? timer; // Temporizador

  void buscarUsuarioTemp(BuildContext context, String search) {
    timer?.cancel(); // Cancelar el temporizador existente si existe
    timer = Timer(const Duration(milliseconds: 1000), () {
      // Función de filtrado que consume el servicio
      buscarUsuarioService(context, search);
    }); // Establecer el período de retardo en milisegundos (en este caso, 1000 ms o 1 segundo)
  }
}
