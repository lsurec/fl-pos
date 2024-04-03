// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/services/services.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComentariosViewModel extends ChangeNotifier {
  //Almacenar comentarios de la tarea
  final List<ComentarioDetalleModel> comentarioDetalle = [];
  //almacenar archivos seleccionados
  List<File> files = [];

  //manejar flujo del procesp
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //comentario
  final TextEditingController comentarioController = TextEditingController();

  //Nuevo comentario
  Future<void> comentar(
    BuildContext context,
    String comentario,
  ) async {
    //ocultar teclado
    FocusScope.of(context).unfocus();

    //View model para obtener usuario y token
    final loginVM = Provider.of<LoginViewModel>(context, listen: false);
    String user = loginVM.user;
    String token = loginVM.token;

    //View model de detalla de tarea
    final vmTarea = Provider.of<DetalleTareaViewModel>(context, listen: false);
    int idTarea = vmTarea.tarea!.iDTarea; //Id de la tarea

    //Instancia del servicio
    ComentarService comentarService = ComentarService();

    //Crear modelo de nuevo comentario
    ComentarModel comentario = ComentarModel(
      comentario: comentarioController.text,
      tarea: idTarea,
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

    //Crear modelo de comentario
    ComentarioModel comentarioCreado = ComentarioModel(
      comentario: comentarioController.text,
      fechaHora: DateTime.now(),
      nameUser: user,
      userName: user,
      tarea: idTarea,
      tareaComentario: res.message.res,
    );

    final List<ObjetoComentarioModel> archivos = [];

    for (var i = 0; i < files.length; i++) {
      File file = files[i];
      ObjetoComentarioModel archivo = ObjetoComentarioModel(
        tareaComentarioObjeto: 1,
        objetoNombre: obtenerNombreArchivo(file),
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
      comentarioCreado.tarea,
      comentarioCreado.tareaComentario,
    );

    //si el consumo salió mal
    if (!resFiles) {
      isLoading = false;

      ApiResModel error = ApiResModel(
        succes: false,
        message:
            "No se pudieron subir los archivos. Verifique que la ruta de guardado esté disponible.",
        url: "",
        storeProcedure: null,
      );

      NotificationService.showErrorView(context, error);

      //Respuesta incorrecta
      return;
    }

    isLoading = false;

    //Crear modelo de comentario detalle, (comentario y objetos)
    comentarioDetalle.add(
      ComentarioDetalleModel(
        comentario: comentarioCreado,
        objetos: archivos,
      ),
    );

    notifyListeners();
    comentarioController.text = ""; //limpiar input
    files.clear(); //limpiar lista de archivos

    isLoading = false; //detener carga

    //Retornar respuesta correcta
    return;
  }

  loadData(BuildContext context) async {
    isLoading = true; //cargar pantalla
    //View model de comentarios
    final vmTarea = Provider.of<TareasViewModel>(context, listen: false);

    //validar resppuesta de los comentarios
    final bool succesComentarios = await vmTarea.armarComentario(context);

    //sino se realizo el consumo correctamente retornar
    if (!succesComentarios) {
      isLoading = false;
      return;
    }

    isLoading = false; //detener carga
  }

  Future<void> selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
    }
    notifyListeners();
  }

  String obtenerNombreArchivo(File archivo) {
    // Obtener el path del archivo
    String path = archivo.path;

    // Utilizar la función basename para obtener solo el nombre del archivo
    String nombreArchivo = File(path).path.split('/').last;

    return nombreArchivo;
  }

  //Eliminar archivos de la lista de inivtados
  void eliminarArchivos(int index) {
    files.removeAt(index);
    notifyListeners();
  }

  // //para abrir archivos, recibe el archivo completo y envia la url del archivo
  // verArchivos(ObjetoComentarioModel archivo) async {
  //   await OpenFile.open(archivo.objetoUrl);
  //   notifyListeners();
  //   print(archivo.objetoUrl);

  // }

  // //Recibe la url del archivo
  // void openFile(String filePath) async {
  //   // Abre el archivo con la aplicación predeterminada asociada a su extensión.
  //   await OpenFile.open(filePath);
  //   print(filePath);
  //   notifyListeners();
    
  // }
}
