import 'dart:io';

import 'package:flutter_post_printer_example/utilities/utilities.dart';

import '../../../widgets/widgets.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ComentariosView extends StatelessWidget {
  const ComentariosView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ComentariosViewModel>(context);
    final vmTarea = Provider.of<DetalleTareaViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              'Comentarios Tarea: ${vmTarea.tarea!.iDTarea.toString()}',
              style: AppTheme.titleStyle,
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => vm.loadData(context),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Observación",
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        vmTarea.tarea!.tareaObservacion1 ?? "No disponible.",
                        style: AppTheme.normalStyle,
                        textAlign: TextAlign.justify,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Comentarios (${vm.comentarioDetalle.length})",
                            style: AppTheme.normalBoldStyle,
                          ),
                        ],
                      ),
                      const Divider(),
                      const SizedBox(height: 10),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vm.comentarioDetalle.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ComentarioDetalleModel comentario =
                              vm.comentarioDetalle[index];
                          return _Comentario(
                            comentario: comentario,
                            index: index,
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      const _NuevoComentario(),
                      const SizedBox(height: 15),
                      if (vm.files.isNotEmpty)
                        Text(
                          "Archivos seleccionados (${vm.files.length})",
                          style: AppTheme.normalBoldStyle,
                        ),
                      const SizedBox(height: 5),
                      if (vm.files.isNotEmpty)
                      const Divider(),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: vm.files.length,
                        itemBuilder: (BuildContext context, int index) {
                          final File archivo = vm.files[index];
                          return Column(
                            children: [
                              ListTile(
                                title: Text(
                                  vm.obtenerNombreArchivo(archivo),
                                  style: AppTheme.normalStyle,
                                ),
                                leading: const Icon(Icons.attachment),
                                trailing: GestureDetector(
                                  child: const Icon(Icons.close),
                                  onTap: () => vm.eliminarArchivos(index),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              const Divider(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        //importarte para mostrar la pantalla de carga
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _NuevoComentario extends StatelessWidget {
  const _NuevoComentario();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ComentariosViewModel>(context);

    return TextFormField(
      controller: vm.comentarioController,
      onChanged: (value) => vm.comentarioController.text = value,
      decoration: InputDecoration(
        labelText: 'Nuevo comentario',
        suffixIcon: SizedBox(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                tooltip: "Adjuntar Archivos",
                onPressed: () => vm.selectFiles(),
                icon: const Icon(Icons.attach_file_outlined),
              ),
              IconButton(
                tooltip: "Enviar comentario.",
                onPressed: () =>
                    vm.comentar(context, vm.comentarioController.text),
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Comentario extends StatelessWidget {
  const _Comentario({
    required this.comentario,
    required this.index,
  });

  final ComentarioDetalleModel comentario;
  final int index;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ComentariosViewModel>(context);
    List<ObjetoComentarioModel> objetos = vm.comentarioDetalle[index].objetos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 1.5,
                color: Color.fromRGBO(0, 0, 0, 0.12),
              ),
              left:
                  BorderSide(width: 1.5, color: Color.fromRGBO(0, 0, 0, 0.12)),
              right:
                  BorderSide(width: 1.5, color: Color.fromRGBO(0, 0, 0, 0.12)),
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comentario.comentario.nameUser,
                style: AppTheme.normalBoldStyle,
              ),
              Text(
                Utilities.formatearFecha(comentario.comentario.fechaHora),
                style: AppTheme.normalStyle,
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
                width: 1.5, color: const Color.fromRGBO(0, 0, 0, 0.12)),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comentario.comentario.comentario,
                style: AppTheme.normalStyle,
                textAlign: TextAlign.justify,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: objetos.length,
                itemBuilder: (BuildContext context, int index) {
                  final ObjetoComentarioModel objeto = objetos[index];
                  return ListTile(
                    title: Text(
                      objeto.objetoNombre,
                      style: AppTheme.normalStyle,
                    ),
                    leading: const Icon(Icons.insert_photo_outlined),
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ],
          ),
        ),
        if (index != vm.comentarioDetalle.length - 1)
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Container(
              color: const Color.fromRGBO(0, 0, 0, 0.12),
              height: 20,
              width: 3,
            ),
          ),
      ],
    );
  }
}
