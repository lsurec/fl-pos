import 'dart:io';

import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';

import '../view_models/view_models.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrearTareaView extends StatelessWidget {
  const CrearTareaView({super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    final List<UsuarioModel> usuariosEncontrados = vm.invitados;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.botones,
                'nueva',
              ),
              style: AppTheme.style(
                context,
                Styles.title,
              ),
            ),
            actions: <Widget>[
              Row(
                children: [
                  IconButton(
                    onPressed: () => vm.crearTarea(context),
                    icon: const Icon(Icons.save_outlined),
                    tooltip: AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'guardar',
                    ),
                  ),
                  IconButton(
                    onPressed: () => vm.limpiar(),
                    icon: const Icon(Icons.note_add_outlined),
                    tooltip: AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'nuevo',
                    ),
                  ),
                  IconButton(
                    onPressed: () => vm.selectFiles(),
                    icon: const Icon(Icons.attach_file_outlined),
                    tooltip: AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'adjuntarArchivos',
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () => vm.loadData(context),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: vm.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.tareas,
                                'titulo',
                              ),
                              style: AppTheme.style(
                                context,
                                Styles.bold,
                              ),
                            ),
                            Text(
                              "*",
                              style: AppTheme.style(
                                context,
                                Styles.obligatory,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!.translate(
                                BlockTranslate.notificacion,
                                'requerido',
                              );
                            }
                            return null;
                          },
                          controller: vm.tituloController,
                          onChanged: (value) =>
                              vm.tituloController.text = value,
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.translate(
                              BlockTranslate.tareas,
                              'agregaTitulo',
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.fecha,
                            'fechaHoraInicio',
                          ),
                          style: AppTheme.style(
                            context,
                            Styles.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () => vm.abrirFechaInicial(context),
                              icon: Icon(
                                Icons.calendar_today_outlined,
                                color: AppTheme.color(
                                  context,
                                  Styles.darkPrimary,
                                ),
                              ),
                              label: Text(
                                "${AppLocalizations.of(context)!.translate(
                                  BlockTranslate.fecha,
                                  'fecha',
                                )} ${Utilities.formatearFecha(vm.fechaInicial)}",
                                style: AppTheme.style(
                                  context,
                                  Styles.normal,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => vm.abrirHoraInicial(context),
                              icon: Icon(
                                Icons.schedule_outlined,
                                color: AppTheme.color(
                                  context,
                                  Styles.darkPrimary,
                                ),
                              ),
                              label: Text(
                                "${AppLocalizations.of(context)!.translate(
                                  BlockTranslate.fecha,
                                  'hora',
                                )} ${Utilities.formatearHora(vm.fechaInicial)}",
                                style: AppTheme.style(
                                  context,
                                  Styles.normal,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.fecha,
                            'fechaHoraFin',
                          ),
                          style: AppTheme.style(
                            context,
                            Styles.bold,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () => vm.abrirFechaFinal(context),
                              icon: Icon(
                                Icons.calendar_today_outlined,
                                color: AppTheme.color(
                                  context,
                                  Styles.darkPrimary,
                                ),
                              ),
                              label: Text(
                                "${AppLocalizations.of(context)!.translate(
                                  BlockTranslate.fecha,
                                  'fecha',
                                )} ${Utilities.formatearFecha(vm.fechaFinal)}",
                                style: AppTheme.style(
                                  context,
                                  Styles.normal,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => vm.abrirHoraFinal(context),
                              icon: Icon(
                                Icons.schedule_outlined,
                                color: AppTheme.color(
                                  context,
                                  Styles.darkPrimary,
                                ),
                              ),
                              label: Text(
                                "${AppLocalizations.of(context)!.translate(
                                  BlockTranslate.fecha,
                                  'hora',
                                )} ${Utilities.formatearHora(vm.fechaFinal)}",
                                style: AppTheme.style(
                                  context,
                                  Styles.normal,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        const Divider(),
                        const SizedBox(height: 5),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.tareas,
                            'tiempoEstimado',
                          ),
                          style: AppTheme.style(
                            context,
                            Styles.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.color(
                                    context,
                                    Styles.primary,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                vm.tiempoController.text,
                                textAlign: TextAlign.center,
                                style: AppTheme.style(
                                  context,
                                  Styles.normal,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 175,
                              child: _TiempoEstimado(
                                tiempos: vm.periodicidades,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.tareas,
                                'tipoTarea',
                              ),
                              style: AppTheme.style(
                                context,
                                Styles.bold,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            Text(
                              "*",
                              style: AppTheme.style(
                                context,
                                Styles.obligatory,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _TipoTarea(tipos: vm.tiposTarea),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate(
                                    BlockTranslate.tareas,
                                    'estadoTarea',
                                  ),
                                  style: AppTheme.style(
                                    context,
                                    Styles.bold,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                Text(
                                  "*",
                                  style: AppTheme.style(
                                    context,
                                    Styles.obligatory,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _EstadoTarea(
                          estados: vm.estados,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.tareas,
                                'prioridadTarea',
                              ),
                              style: AppTheme.style(
                                context,
                                Styles.bold,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            Text(
                              "*",
                              style: AppTheme.style(
                                context,
                                Styles.obligatory,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _PrioridadTarea(
                          prioridades: vm.prioridades,
                        ),
                        const SizedBox(height: 10),
                        Row(
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
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            Text(
                              "*",
                              style: AppTheme.style(
                                context,
                                Styles.obligatory,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const _ObservacionTarea(),
                        const SizedBox(height: 10),
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
                        // const Divider(),
                        TextButton(
                          onPressed: () => vm.irIdReferencia(context),
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.translate(
                                    BlockTranslate.tareas,
                                    'idRef',
                                  )}: ",
                                  style: AppTheme.style(
                                    context,
                                    Styles.normal,
                                  ),
                                ),
                                Text(
                                  " * ",
                                  style: AppTheme.style(
                                    context,
                                    Styles.obligatory,
                                  ),
                                ),
                                const SizedBox(width: 30),
                                if (vm.idReferencia != null)
                                  Text(
                                    vm.idReferencia!.referenciaId,
                                    style: AppTheme.style(
                                      context,
                                      Styles.bold,
                                    ),
                                  ),
                              ],
                            ),
                            leading: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.all(0),
                          ),
                        ),
                        const Divider(),
                        TextButton(
                          onPressed: () => vm.irUsuarios(
                              context,
                              1,
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.botones,
                                'agregarResponsable',
                              )),
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate(
                                    BlockTranslate.tareas,
                                    'agregarResponsable',
                                  ),
                                  style: AppTheme.style(
                                    context,
                                    Styles.normal,
                                  ),
                                ),
                                Text(
                                  " * ",
                                  style: AppTheme.style(
                                    context,
                                    Styles.obligatory,
                                  ),
                                ),
                              ],
                            ),
                            leading:
                                const Icon(Icons.person_add_alt_1_outlined),
                            contentPadding: const EdgeInsets.all(0),
                          ),
                        ),
                        if (vm.responsable != null)
                          ListTile(
                            title: Text(
                              vm.responsable!.name,
                              style: AppTheme.style(
                                context,
                                Styles.bold,
                              ),
                            ),
                            subtitle: Text(
                              vm.responsable!.email,
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                            leading: const Icon(Icons.person),
                            trailing: GestureDetector(
                              child: const Icon(Icons.close),
                              onTap: () => vm.eliminarResponsable(),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        const Divider(),
                        TextButton(
                          onPressed: () => vm.irUsuarios(
                            context,
                            2,
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.botones,
                              'agregarInvitado',
                            ),
                          ),
                          child: ListTile(
                            title: Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.tareas,
                                'agregarInvitados',
                              ),
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                            leading: const Icon(
                              Icons.person_add_alt_1_outlined,
                            ),
                            contentPadding: const EdgeInsets.all(0),
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: vm.invitados.length,
                          itemBuilder: (BuildContext context, int index) {
                            final UsuarioModel usuario =
                                usuariosEncontrados[index];
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    usuario.name,
                                    style: AppTheme.style(
                                      context,
                                      Styles.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    usuario.email,
                                    style: AppTheme.style(
                                      context,
                                      Styles.normal,
                                    ),
                                  ),
                                  leading: const Icon(Icons.person),
                                  trailing: GestureDetector(
                                    child: const Icon(Icons.close),
                                    onTap: () => vm.eliminarInvitado(index),
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

// class _TiempoEstimado extends StatelessWidget {
//   const _TiempoEstimado({
//     required this.tiempos,
//   });

//   final List<PeriodicidadModel> tiempos;

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<CrearTareaViewModel>(context);

//     return DropdownButtonFormField2<PeriodicidadModel>(
//       value: vm.periodicidad,
//       isExpanded: true,
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.symmetric(vertical: 16),
//         border: UnderlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: const BorderSide(),
//         ),
//       ),
//       items: tiempos
//           .map(
//             (item) => DropdownMenuItem<PeriodicidadModel>(
//               value: item,
//               child: Text(
//                 item.descripcion,
//                 style: const TextStyle(
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//       onChanged: (value) => vm.periodicidad = value!,
//       buttonStyleData: const ButtonStyleData(
//         padding: EdgeInsets.only(right: 8),
//       ),
//       iconStyleData: const IconStyleData(
//         icon: Icon(
//           Icons.arrow_drop_down,
//         ),
//         iconSize: 24,
//       ),
//       dropdownStyleData: DropdownStyleData(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//       menuItemStyleData: const MenuItemStyleData(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//       ),
//     );
//   }
// }

class _TiempoEstimado extends StatelessWidget {
  const _TiempoEstimado({
    required this.tiempos,
  });

  final List<PeriodicidadModel> tiempos;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    // Asegurarse de que la lista no esté vacía
    if (tiempos.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.general,
          'noDisponible',
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.color(
            context,
            Styles.primary,
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        vm.periodicidad!.descripcion,
        style: AppTheme.style(
          context,
          Styles.normal,
        ),
      ),
    );
  }
}

class _ObservacionTarea extends StatelessWidget {
  const _ObservacionTarea();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    return TextFormField(
      controller: vm.observacionController,
      onChanged: (value) => vm.observacionController.text = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.translate(
            BlockTranslate.notificacion,
            'requerido',
          );
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.translate(
          BlockTranslate.tareas,
          'notaObservacion',
        ),
      ),
      maxLines: 5,
      minLines: 2,
    );
  }
}

class _PrioridadTarea extends StatelessWidget {
  const _PrioridadTarea({
    required this.prioridades,
  });

  final List<PrioridadModel> prioridades;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    return DropdownButtonFormField2<PrioridadModel>(
      value: vm.prioridad,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(),
        ),
      ),
      items: prioridades
          .map(
            (item) => DropdownMenuItem<PrioridadModel>(
              value: item,
              child: Text(
                item.nombre,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          )
          .toList(),
      validator: (value) {
        if (value == null) {
          return AppLocalizations.of(context)!.translate(
            BlockTranslate.tareas,
            'seleccionePrioridad',
          );
        }
        return null;
      },
      onChanged: (value) => vm.prioridad = value,
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}

// class _EstadoTarea extends StatelessWidget {
//   const _EstadoTarea({
//     required this.estados,
//   });

//   final List<EstadoModel> estados;

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<CrearTareaViewModel>(context);

//     return DropdownButtonFormField2<EstadoModel>(
//       value: vm.estado,
//       isExpanded: true,
//       decoration: InputDecoration(
//         contentPadding: const EdgeInsets.symmetric(vertical: 16),
//         border: UnderlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//       items: estados
//           .map(
//             (item) => DropdownMenuItem<EstadoModel>(
//               value: item,
//               child: Text(
//                 item.descripcion,
//                 style: const TextStyle(
//                   fontSize: 14,
//                 ),
//               ),
//             ),
//           )
//           .toList(),
//       validator: (value) {
//         if (value == null) {
//           return AppLocalizations.of(context)!.translate(
//             BlockTranslate.tareas,
//             'seleccionaEstado',
//           );
//         }
//         return null;
//       },
//       onChanged: (value) => vm.estado = value,
//       buttonStyleData: const ButtonStyleData(
//         padding: EdgeInsets.only(right: 8),
//       ),
//       iconStyleData: const IconStyleData(
//         icon: Icon(
//           Icons.arrow_drop_down,
//         ),
//         iconSize: 24,
//       ),
//       dropdownStyleData: DropdownStyleData(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(15),
//         ),
//       ),
//       menuItemStyleData: const MenuItemStyleData(
//         padding: EdgeInsets.symmetric(horizontal: 16),
//       ),
//     );
//   }
// }

class _EstadoTarea extends StatelessWidget {
  const _EstadoTarea({
    required this.estados,
  });

  final List<EstadoModel> estados;

  @override
  Widget build(BuildContext context) {
    // Asegurarse de que la lista no esté vacía
    if (estados.isEmpty) {
      return Text(
        AppLocalizations.of(context)!.translate(
          BlockTranslate.general,
          'noDisponible',
        ),
      );
    }

    // Obtener el primer elemento de la lista
    final EstadoModel primerEstado = estados.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppTheme.color(
            context,
            Styles.primary,
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        primerEstado.descripcion,
        style: AppTheme.style(
          context,
          Styles.subTitle,
        ),
      ),
    );
  }
}

class _TipoTarea extends StatelessWidget {
  const _TipoTarea({
    required this.tipos,
  });

  final List<TipoTareaModel> tipos;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    return DropdownButtonFormField2<TipoTareaModel>(
      value: vm.tipoTarea,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide:
              const BorderSide(), // Cambia el color del borde inferior aquí
        ),
        // Add more decoration..
      ),
      items: tipos
          .map(
            (item) => DropdownMenuItem<TipoTareaModel>(
              value: item,
              child: Text(
                item.descripcion,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
          )
          .toList(),
      validator: (value) {
        if (value == null) {
          return AppLocalizations.of(context)!.translate(
            BlockTranslate.tareas,
            'seleccionaTipo',
          );
        }
        return null;
      },
      onChanged: (value) => vm.tipoTarea = value,
      buttonStyleData: const ButtonStyleData(
        padding: EdgeInsets.only(right: 8),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
        ),
        iconSize: 24,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        padding: EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }
}
