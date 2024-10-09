// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/models/models.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:url_launcher/url_launcher.dart';

class ComentariosViewModel extends ChangeNotifier {
  //Almacenar comentarios de la tarea
  final List<ComentarioDetalleModel> comentarioDetalle = [];
  //almacenar archivos seleccionados
  List<File> files = [];
  int vistaTarea = 1;

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //formulario para escribir comentariosS
  GlobalKey<FormState> formKeyComment = GlobalKey<FormState>();

  //comentario
  final TextEditingController comentarioController = TextEditingController();

  //ID TAREA PARA COMENTAR
  int? idTarea;

  //Validar formulario barra busqueda
  bool isValidFormComment() {
    return formKeyComment.currentState?.validate() ?? false;
  }

  //Nuevo comentario
  Future<void> comentar(
    BuildContext context,
  ) async {
    //validar formulario
    if (!isValidFormComment()) return;

    //ocultar teclado
    FocusScope.of(context).unfocus();

    //View model para obtener usuario y token
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    String user = loginVM.user;
    String token = loginVM.token;

    //View model para obtenerla empresa
    final vmLocal = Provider.of<LocalSettingsViewModel>(context, listen: false);
    EmpresaModel empresa = vmLocal.selectedEmpresa!;

    //View model de detalla de tarea tareas
    final vmTarea = Provider.of<DetalleTareaViewModel>(context, listen: false);
    final vmTareaCalendario =
        Provider.of<DetalleTareaCalendarioViewModel>(context, listen: false);

    //View model de comentarios
    final vmDetalleTarea = Provider.of<TareasViewModel>(context, listen: false);
    final vmDetalleTareaCalendario =
        Provider.of<CalendarioViewModel>(context, listen: false);

    if (vistaTarea == 1) {
      //Id de la tarea
      idTarea = vmTarea.tarea!.iDTarea;
    } else {
      //Id de la tarea desde calendario
      idTarea = vmTareaCalendario.tarea!.tarea;
    }

    //Instancia del servicio
    ComentarService comentarService = ComentarService();

    //Crear modelo de nuevo comentario
    ComentarModel comentario = ComentarModel(
      comentario: comentarioController.text,
      tarea: idTarea!,
      userName: user,
    );

    isLoading = true; //cargar pantalla

    //consumo de api
    ApiResModel res = await comentarService.postComentar(
      token,
      comentario,
    );

    //si el consumo salió mal
    if (!res.succes) {
      isLoading = false;

      NotificationService.showErrorView(context, res);

      //Respuesta incorrecta
      return;
    }

    //lista de archivos
    final List<ObjetoComentarioModel> archivos = [];
    int idComentario = res.response.res;

    if (files.isNotEmpty) {
      for (var i = 0; i < files.length; i++) {
        File file = files[i];
        ObjetoComentarioModel archivo = ObjetoComentarioModel(
          observacion1: Utilities.nombreArchivo(file),
          tareaComentarioObjeto: 1,
          objetoNombre: Utilities.nombreArchivo(file),
          objetoSize: "",
          objetoUrl: "",
        );

        archivos.add(archivo);
      }

      FilesService filesService = FilesService();

      bool resFiles = await filesService.posFilesComent(
        token,
        user,
        files,
        idTarea!,
        idComentario,
        empresa.absolutePathPicture,
      );

      //si el consumo salió mal
      if (!resFiles) {
        isLoading = false;

        ApiResModel error = ApiResModel(
          succes: false,
          response:
              "No se pudieron subir los archivos. Verifique que la ruta de guardado esté disponible.",
          url: "",
          storeProcedure: null,
        );

        NotificationService.showErrorView(context, error);

        //Respuesta incorrecta
        return;
      }
    }

    //Crear modelo de comentario
    ComentarioModel comentarioCreado = ComentarioModel(
      comentario: comentarioController.text,
      fechaHora: DateTime.now(),
      nameUser: user,
      userName: user,
      tarea: idTarea!,
      tareaComentario: idComentario,
    );

    //Crear modelo de comentario detalle, (comentario y objetos)
    comentarioDetalle.add(
      ComentarioDetalleModel(
        comentario: comentarioCreado,
        objetos: archivos,
      ),
    );

    //validar resppuesta de los comentarios
    final bool succesComentarios;
    if (vistaTarea == 1) {
      succesComentarios = await vmDetalleTarea.armarComentario(
        context,
      );
    } else {
      succesComentarios = await vmDetalleTareaCalendario.armarComentario(
        context,
      );
    }

    //sino se realizo el consumo correctamente retornar
    if (!succesComentarios) {
      isLoading = false;
      return;
    }

    notifyListeners();
    comentarioController.text = ""; //limpiar input
    files.clear(); //limpiar lista de archivos

    isLoading = false; //detener carga
  }

  loadData(BuildContext context) async {
    isLoading = true; //cargar pantalla
    //View model de comentarios
    final vmTarea = Provider.of<TareasViewModel>(context, listen: false);
    final vmTareaCalendario =
        Provider.of<CalendarioViewModel>(context, listen: false);

    //validar resppuesta de los comentarios
    final bool succesComentarios;
    if (vistaTarea == 1) {
      succesComentarios = await vmTarea.armarComentario(context);
    } else {
      succesComentarios = await vmTareaCalendario.armarComentario(context);
    }

    //sino se realizo el consumo correctamente retornar
    if (!succesComentarios) {
      isLoading = false;
      return;
    }

    isLoading = false; //detener carga
  }

  //seleccionar archivos para adjuntarlos al comentario
  Future<void> selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    }
    notifyListeners();
  }

  //Eliminar archivos de la lista de inivtados
  void eliminarArchivos(int index) {
    files.removeAt(index);
    notifyListeners();
  }

  // Future<void> abrirUrl(String url) async {
  //   if (url.isEmpty) {
  //     print("url no valida");
  //     return;
  //   }

  //   print(url);

  //   Uri urlParse = Uri.parse(url);

  //   if (!await launchUrl(urlParse, mode: LaunchMode.externalApplication
  //   )) {
  //     throw Exception('Could not launch $urlParse');
  //   }
  // }
}
