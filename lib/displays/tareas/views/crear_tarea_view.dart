// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/shared_preferences/preferences.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CrearTareaView extends StatelessWidget {
  const CrearTareaView({super.key});

  // @override
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CrearTareaViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.botones,
                'nueva',
              ),
              style: StyleApp.title,
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
                    onPressed: () => vm.selectFiles(),
                    icon: const Icon(Icons.attach_file_outlined),
                    tooltip: AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'adjuntarArchivos',
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
                              style: StyleApp.normalBold,
                            ),
                            const Text(
                              "*",
                              style: StyleApp.obligatory,
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
                          decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)!.translate(
                              BlockTranslate.tareas,
                              'agregaTitulo',
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppTheme.grey,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.fecha,
                            'fechaHoraInicio',
                          ),
                          style: StyleApp.normalBold,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () => vm.abrirFechaInicial(context),
                              icon: Icon(
                                Icons.calendar_today_outlined,
                                color: AppTheme.hexToColor(
                                  Preferences.valueColor,
                                ),
                              ),
                              label: Text(
                                "${AppLocalizations.of(context)!.translate(
                                  BlockTranslate.fecha,
                                  'fecha',
                                )} ${Utilities.formatearFecha(vm.fechaInicial)}",
                                style: StyleApp.normal.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => vm.abrirHoraInicial(context),
                              icon: Icon(
                                Icons.schedule_outlined,
                                color: AppTheme.hexToColor(
                                  Preferences.valueColor,
                                ),
                              ),
                              label: Text(
                                "${AppLocalizations.of(context)!.translate(
                                  BlockTranslate.fecha,
                                  'hora',
                                )} ${Utilities.formatearHora(vm.fechaInicial)}",
                                style: StyleApp.normal.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
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
                          style: StyleApp.normalBold,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton.icon(
                              onPressed: () => vm.abrirFechaFinal(context),
                              icon: Icon(
                                Icons.calendar_today_outlined,
                                color: AppTheme.hexToColor(
                                  Preferences.valueColor,
                                ),
                              ),
                              label: Text(
                                "${AppLocalizations.of(context)!.translate(
                                  BlockTranslate.fecha,
                                  'fecha',
                                )} ${Utilities.formatearFecha(vm.fechaFinal)}",
                                style: StyleApp.normal.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
                                ),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => vm.abrirHoraFinal(context),
                              icon: Icon(
                                Icons.schedule_outlined,
                                color: AppTheme.hexToColor(
                                  Preferences.valueColor,
                                ),
                              ),
                              label: Text(
                                "${AppLocalizations.of(context)!.translate(
                                  BlockTranslate.fecha,
                                  'hora',
                                )} ${Utilities.formatearHora(vm.fechaFinal)}",
                                style: StyleApp.normal.copyWith(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .color,
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
                          style: StyleApp.normalBold,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppTheme.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                vm.tiempoController.text,
                                textAlign: TextAlign.center,
                                style: StyleApp.normal,
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
                              style: StyleApp.normalBold,
                            ),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            const Text(
                              "*",
                              style: StyleApp.obligatory,
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
                                  style: StyleApp.normalBold,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                ),
                                const Text(
                                  "*",
                                  style: StyleApp.obligatory,
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
                              style: StyleApp.normalBold,
                            ),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            const Text(
                              "*",
                              style: StyleApp.obligatory,
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
                              style: StyleApp.normalBold,
                            ),
                            const Padding(padding: EdgeInsets.only(left: 5)),
                            const Text(
                              "*",
                              style: StyleApp.obligatory,
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
                            style: StyleApp.normalBold,
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
                                    style: StyleApp.normal,
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
                                  style: StyleApp.normal,
                                ),
                                const Text(
                                  " * ",
                                  style: StyleApp.obligatory,
                                ),
                                const SizedBox(width: 30),
                              ],
                            ),
                            leading: const Icon(Icons.search),
                            contentPadding: const EdgeInsets.all(0),
                          ),
                        ),
                        if (vm.idReferencia != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.tareas,
                                  'refSelec',
                                ),
                                style: StyleApp.normal,
                              ),
                              ListTile(
                                contentPadding: const EdgeInsets.all(5),
                                title: Text(
                                  vm.idReferencia!.descripcion.isEmpty
                                      ? "${vm.idReferencia?.referenciaId ?? vm.idReferencia?.referencia}"
                                      : vm.idReferencia?.referenciaId ??
                                          "${vm.idReferencia?.referencia ?? vm.idReferencia}",
                                  style: StyleApp.normalBold,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "${AppLocalizations.of(context)!.translate(
                                        BlockTranslate.tareas,
                                        'idRef',
                                      )}: ",
                                      style: StyleApp.normal,
                                    ),
                                    Text(
                                      vm.idReferencia?.referenciaId ??
                                          vm.idReferencia?.referenciaId ??
                                          "",
                                      style: StyleApp.normalBold,
                                    ),
                                  ],
                                ),
                                trailing: GestureDetector(
                                  child: const Icon(Icons.close),
                                  onTap: () => vm.eliminarRef(),
                                ),
                              ),
                            ],
                          ),
                        const Divider(),
                        TextButton(
                          onPressed: () => vm.irUsuarios(
                            context,
                            1,
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.botones,
                              'agregarResponsable',
                            ),
                          ),
                          child: ListTile(
                            title: Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.translate(
                                    BlockTranslate.tareas,
                                    'agregarResponsable',
                                  ),
                                  style: StyleApp.normal,
                                ),
                                const Text(
                                  " * ",
                                  style: StyleApp.obligatory,
                                ),
                              ],
                            ),
                            leading: const Icon(
                              Icons.person_add_alt_1_outlined,
                            ),
                            contentPadding: const EdgeInsets.all(0),
                          ),
                        ),
                        if (vm.responsable != null)
                          ListTile(
                            title: Text(
                              vm.responsable!.name,
                              style: StyleApp.normalBold,
                            ),
                            subtitle: Text(
                              vm.responsable!.email,
                              style: StyleApp.normal,
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
                              style: StyleApp.normal,
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
                            final UsuarioModel usuario = vm.invitados[index];
                            return Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    usuario.name,
                                    style: StyleApp.normalBold,
                                  ),
                                  subtitle: Text(
                                    usuario.email,
                                    style: StyleApp.normal,
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
            color: AppTheme.isDark()
                ? AppTheme.darkBackroundColor
                : AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

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
          color: AppTheme.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        vm.periodicidad!.descripcion,
        style: StyleApp.normal,
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
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppTheme.grey,
          ),
          borderRadius: BorderRadius.circular(10),
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
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppTheme.grey,
          ),
          borderRadius: BorderRadius.circular(10),
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
          color: AppTheme.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        primerEstado.descripcion,
        style: StyleApp.subTitle,
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
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppTheme.grey,
          ),
          borderRadius: BorderRadius.circular(10),
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
