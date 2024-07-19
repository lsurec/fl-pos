import 'dart:io';

import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
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
    final vmTareaCalendario =
        Provider.of<DetalleTareaCalendarioViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              vm.vistaTarea == 1
                  ? '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'comentariosTarea',
                    )}: ${vmTarea.tarea!.iDTarea}'
                  : '${AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'comentariosTarea',
                    )}: ${vmTareaCalendario.tarea!.tarea}',
              style: AppTheme.style(
                context,
                Styles.title,
              ),
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
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'observacion',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      GestureDetector(
                        onLongPress: () => Utilities.copyToClipboard(
                          context,
                          vm.vistaTarea == 1
                              ? vmTarea.tarea!.tareaObservacion1 ?? ''
                              : vmTareaCalendario.tarea!.texto,
                        ),
                        child: Text(
                          vm.vistaTarea == 1
                              ? vmTarea.tarea!.tareaObservacion1 ??
                                  AppLocalizations.of(context)!.translate(
                                    BlockTranslate.general,
                                    'noDisponible',
                                  )
                              : vmTareaCalendario.tarea!.observacion1,
                          style: AppTheme.style(
                            context,
                            Styles.normal,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate(
                              BlockTranslate.tareas,
                              'comentarios',
                            )} (${vm.comentarioDetalle.length})",
                            style: AppTheme.style(
                              context,
                              Styles.bold,
                            ),
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
                          "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.tareas,
                            'archivosSelec',
                          )} (${vm.files.length})",
                          style: AppTheme.style(
                            context,
                            Styles.bold,
                          ),
                        ),
                      const SizedBox(height: 5),
                      if (vm.files.isNotEmpty) const Divider(),
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
                                  Utilities.nombreArchivo(archivo),
                                  style: AppTheme.style(
                                    context,
                                    Styles.normal,
                                  ),
                                ),
                                leading: const Icon(Icons.attachment),
                                trailing: GestureDetector(
                                  child: const Icon(Icons.close),
                                  onTap: () => vm.eliminarArchivos(index),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
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
            color: AppTheme.color(
              context,
              Styles.loading,
            ),
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

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: vm.formKeyComment,
      child: TextFormField(
        controller: vm.comentarioController,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return AppLocalizations.of(context)!.translate(
              BlockTranslate.notificacion,
              'requerido',
            );
          }
          return null;
        },
        maxLines: 3,
        textInputAction: TextInputAction.send,
        onFieldSubmitted: (value) => vm.comentar(context),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
            ),
          ),
          labelText: AppLocalizations.of(context)!.translate(
            BlockTranslate.tareas,
            'nuevoComentario',
          ),
          suffixIcon: SizedBox(
            width: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  tooltip: AppLocalizations.of(context)!.translate(
                    BlockTranslate.botones,
                    'adjuntarArchivos',
                  ),
                  onPressed: () => vm.selectFiles(),
                  icon: const Icon(Icons.attach_file_outlined),
                ),
                IconButton(
                  tooltip: AppLocalizations.of(context)!.translate(
                    BlockTranslate.botones,
                    'enviarComentario',
                  ),
                  onPressed: () => vm.comentar(
                    context,
                  ),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
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
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                width: 1.5,
                color: AppTheme.color(
                  context,
                  Styles.greyBorder,
                ),
              ),
              left: BorderSide(
                width: 1.5,
                color: AppTheme.color(
                  context,
                  Styles.greyBorder,
                ),
              ),
              right: BorderSide(
                width: 1.5,
                color: AppTheme.color(
                  context,
                  Styles.greyBorder,
                ),
              ),
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                comentario.comentario.nameUser,
                style: AppTheme.style(
                  context,
                  Styles.bold,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border.all(
              width: 1.5,
              color: AppTheme.color(
                context,
                Styles.greyBorder,
              ),
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    Utilities.formatearFechaHora(
                      comentario.comentario.fechaHora,
                    ),
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onLongPress: () => Utilities.copyToClipboard(
                  context,
                  comentario.comentario.comentario,
                ),
                child: Text(
                  comentario.comentario.comentario,
                  style: AppTheme.style(
                    context,
                    Styles.normal,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: objetos.length,
                itemBuilder: (BuildContext context, int index) {
                  final ObjetoComentarioModel objeto = objetos[index];
                  return ListTile(
                    title: GestureDetector(
                      onLongPress: () => Utilities.copyToClipboard(
                        context,
                        objeto.objetoUrl,
                      ),
                      child: Text(
                        objeto.objetoNombre,
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                        ),
                      ),
                    ),
                    leading: const Icon(Icons.insert_photo_outlined),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 5,
                    ),
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
              color: AppTheme.color(
                context,
                Styles.greyBorder,
              ),
              height: 20,
              width: 3,
            ),
          ),
      ],
    );
  }
}
