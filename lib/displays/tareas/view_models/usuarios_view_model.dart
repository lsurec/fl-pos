// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
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
  List<UsuarioModel> usuarios = [];
  //Almacenar usuarios seleccionados
  final List<UsuarioModel> usuariosSeleccionados = [];

  //Regresar a la pantalla anterior y limpiar
  Future<bool> back(
    BuildContext context,
  ) async {
    final vmTarea = Provider.of<TareasViewModel>(
      context,
      listen: false,
    );

    final vmCrear = Provider.of<CrearTareaViewModel>(
      context,
      listen: false,
    );

    buscar.clear();
    usuarios.clear();
    buscar.clear();

    if (vmTarea.vistaDetalle == 1 || vmTarea.vistaDetalle == 2) {
      print("la lista debe limpiarse ${usuariosSeleccionados.length}");
      vmCrear.invitados.clear();

      return true;
    }

    print("la lista NO debe limpiarse ${usuariosSeleccionados.length}");

    return true;
  }

  //Buscar usuarios
  Future<void> buscarUsuario(
    BuildContext context,
  ) async {
    usuarios.clear(); //limpiar lista de usuarios

    //Si el buscador está vacio, limpiar la lista y moestrar mensaje
    if (buscar.text.isEmpty) {
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
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);
    final vmDetalle = Provider.of<DetalleTareaViewModel>(
      context,
      listen: false,
    );
    final vmDetalleCalendario = Provider.of<DetalleTareaViewModel>(
      context,
      listen: false,
    );

    String token = vmLogin.token;
    String user = vmLogin.user;

    //Instancia de servicio
    final UsuarioService usuarioService = UsuarioService();

    isLoading = true; //Cargar pantalla

    //Consumo de api
    final ApiResModel res = await usuarioService.getUsuario(
      user,
      token,
      buscar.text,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      return;
    }

    //agregar a lista usuarios la respuesta de api.
    usuarios.addAll(res.response);

    if (usuarios.isEmpty) {
      NotificationService.showSnackbar(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.notificacion,
          'sinCoincidencias',
        ),
      );

      buscar.text = '';
    }
    //Marcar a los invitados en la tarea desde detalle tarea
    if (vmCrear.invitados.isNotEmpty) {
      // Recorrer la lista de usuarios y marcar los seleccionados
      for (var usuario in usuarios) {
        for (var invitado in vmCrear.invitados) {
          if (usuario.email == invitado.email ||
              usuario.userName == invitado.userName ||
              usuario.name == invitado.name) {
            usuario.select = true;
          }
        }
      }
    }

    //Marcar a los invitados en la tarea desde detalle tarea calendario
    if (vmDetalleCalendario.invitados.isNotEmpty) {
      // Recorrer la lista de usuarios y marcar los seleccionados
      for (var usuario in usuarios) {
        for (var invitado in vmDetalleCalendario.invitados) {
          if (usuario.email == invitado.eMail ||
              usuario.userName == invitado.userName ||
              usuario.name == invitado.userName) {
            usuario.select = true;
          }
        }
      }
    }

    if (vmDetalle.invitados.length > 1) {
      // Recorrer la lista de usuarios y marcar los seleccionados
      for (var usuario in usuarios) {
        for (var invitado in vmDetalle.invitados) {
          if (usuario.email == invitado.eMail ||
              usuario.userName == invitado.userName ||
              usuario.name == invitado.userName) {
            usuario.select = true;
          }
        }
      }
    }

    isLoading = false; //Detener carga
  }

  // //Marcar o desmarcar check de los usuarios
  // void changeChecked(BuildContext context, bool? value, int index) {
  //   final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);

  //   // Invertir el valor actual
  //   usuarios[index].select = !usuarios[index].select;

  //   if (usuarios.isNotEmpty) {
  //     // Recorrer lista de usuarios que estén seleccionados y agregarlos a la lista de usuarios seleccionados
  //     for (var usuario in usuarios) {
  //       if (usuario.select) {
  //         vmCrear.invitados.add(usuario);
  //       }
  //     }
  //   }
  //   notifyListeners();
  // }

  void changeChecked(BuildContext context, bool? value, int index) {
    final vmCrear = Provider.of<CrearTareaViewModel>(context, listen: false);

    // Invertir el valor actual
    usuarios[index].select = value ?? false;

    final usuarioSeleccionado = usuarios[index];

    if (usuarioSeleccionado.select) {
      // Verificar si el usuario ya está en la lista antes de agregarlo
      if (!vmCrear.invitados.contains(usuarioSeleccionado)) {
        vmCrear.invitados.add(usuarioSeleccionado);
      }
    } else {
      // Si el usuario es deseleccionado, eliminarlo de la lista de invitados
      vmCrear.invitados.removeWhere(
        (u) => u.email == usuarioSeleccionado.email,
      );
    }

    // Notificar cambios a los listeners
    notifyListeners();
  }
}
