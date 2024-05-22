// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';

import '../models/models.dart';
import 'dart:async';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UsuariosViewModel extends ChangeNotifier {
  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //tipo de busqueda
  int tipoBusqueda = 1;

  //uscar usuario
  final TextEditingController buscar = TextEditingController();

  //Almacenar usuarios
  final List<UsuarioModel> usuarios = [];
  //Almacenar usuarios seleccionados
  final List<UsuarioModel> usuariosSeleccionados = [];

  //Regresar a la pantalla anterior y limpiar
  Future<bool> back() async {
    buscar.clear();
    usuarios.clear();
    usuariosSeleccionados.clear();
    buscar.clear();
    return true;
  }

  //Buscar usuarios
  Future<void> buscarUsuarioService(
    BuildContext context,
    String search,
  ) async {
    usuarios.clear(); //limpiar lista de usuarios

    //Si el buscador está vacio, limpiar la lista y moestrar mensaje
    if (search.isEmpty) {
      usuarios.clear();
      notifyListeners();
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'ingreseCaracter',
        ),
      );
      return;
    }

    //View model de Login para obtener usuario y token
    final vmLogin = Provider.of<LoginViewModel>(context, listen: false);
    String token = vmLogin.token;
    String user = vmLogin.user;

    //Instancia de servicio
    final UsuarioService usuarioService = UsuarioService();

    isLoading = true; //Cargar pantalla

    //Consumo de api
    final ApiResModel res =
        await usuarioService.getUsuario(user, token, search);

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      return;
    }

    //agregar a lista usuarios la respuesta de api.
    usuarios.addAll(res.message);

    isLoading = false; //Detener carga
  }

  //Marcar o desmarcar check de los usuarios
  void changeChecked(bool? value, int index) {
    // Invertir el valor actual
    usuarios[index].select = !usuarios[index].select;
    notifyListeners();
  }

  Timer? timer; // Temporizador

  void buscarUsuarioTemp(BuildContext context) {
    timer?.cancel(); // Cancelar el temporizador existente si existe
    timer = Timer(const Duration(milliseconds: 1000), () {
      FocusScope.of(context).unfocus(); //ocultar teclado
      // Función de filtrado que consume el servicio
      buscarUsuarioService(context, buscar.text);
    }); // Establecer el período de retardo en milisegundos (en este caso, 1000 ms o 1 segundo)
  }
}
