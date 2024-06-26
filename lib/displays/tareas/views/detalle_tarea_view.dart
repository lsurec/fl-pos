// ignore_for_file: avoid_print

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetalleTareaView extends StatelessWidget {
  const DetalleTareaView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetalleTareaViewModel>(context);
    final vmComentarios = Provider.of<ComentariosViewModel>(context);
    final vmUsuarios = Provider.of<CrearTareaViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              '${AppLocalizations.of(context)!.translate(
                BlockTranslate.tareas,
                'detalleTarea',
              )}: ${vm.tarea!.iDTarea}',
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
                      Text(
                        vm.tarea!.tareaObservacion1 ??
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'noDisponible',
                            ),
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => vm.comentariosTarea(context),
                            child: Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.tareas,
                                'comentarios',
                              )} (${vmComentarios.comentarioDetalle.length})",
                              style: AppTheme.style(
                                context,
                                Styles.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),
                      const SizedBox(height: 10),

                      //ACTUALIZAR ESTADO DE LA TAREA
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'estadoT',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      const _ActualizarEstado(),

                      //ACTUALIZAR PRIORIDAD DE LA TAREA
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'prioridadT',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      const _ActualizarPrioridad(),

                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'feHoInicio',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      CardWidget(
                        color: AppTheme.color(
                          context,
                          Styles.secondBackground,
                        ),
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: AppTheme.color(
                          context,
                          Styles.greyBorder,
                        ),
                        raidus: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range),
                              const Padding(
                                padding: EdgeInsets.only(left: 15),
                              ),
                              Text(
                                Utilities.formatearFecha(
                                  vm.tarea!.tareaFechaIni,
                                ),
                                style: AppTheme.style(
                                  context,
                                  Styles.normal,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.schedule_outlined),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                              Text(
                                Utilities.formatearHora(
                                  vm.tarea!.tareaFechaIni,
                                ),
                                style: AppTheme.style(
                                  context,
                                  Styles.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'feHoFin',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      CardWidget(
                        color: AppTheme.color(
                          context,
                          Styles.secondBackground,
                        ),
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: AppTheme.color(
                          context,
                          Styles.greyBorder,
                        ),
                        raidus: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range),
                              const Padding(
                                padding: EdgeInsets.only(left: 15),
                              ),
                              Text(
                                Utilities.formatearFecha(
                                  vm.tarea!.tareaFechaFin,
                                ),
                                style: AppTheme.style(
                                  context,
                                  Styles.normal,
                                ),
                              ),
                              const Spacer(),
                              const Icon(Icons.schedule_outlined),
                              const Padding(
                                padding: EdgeInsets.only(left: 10),
                              ),
                              Text(
                                Utilities.formatearHora(
                                  vm.tarea!.tareaFechaFin,
                                ),
                                style: AppTheme.style(
                                  context,
                                  Styles.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'tipo',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      CardWidget(
                        color: AppTheme.color(
                          context,
                          Styles.secondBackground,
                        ),
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: AppTheme.color(
                          context,
                          Styles.greyBorder,
                        ),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            vm.tarea!.descripcionTipoTarea ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.general,
                                  'noDisponible',
                                ),
                            style: AppTheme.style(
                              context,
                              Styles.normal,
                            ),
                          ),
                          leading: const Icon(
                            Icons.arrow_circle_right_outlined,
                          ),
                        ),
                      ),

                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'idRefT',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      CardWidget(
                        color: AppTheme.color(
                          context,
                          Styles.secondBackground,
                        ),
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: AppTheme.color(
                          context,
                          Styles.greyBorder,
                        ),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            vm.tarea!.iDReferencia ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.general,
                                  'noDisponible',
                                ),
                            style: AppTheme.style(
                              context,
                              Styles.normal,
                            ),
                          ),
                          leading: const Icon(
                            Icons.arrow_circle_right_outlined,
                          ),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'responsableT',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      CardWidget(
                        color: AppTheme.color(
                          context,
                          Styles.secondBackground,
                        ),
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: AppTheme.color(
                          context,
                          Styles.greyBorder,
                        ),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            vm.tarea!.usuarioResponsable ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.general,
                                  'noAsignado',
                                ),
                            style: AppTheme.style(
                              context,
                              Styles.normal,
                            ),
                          ),
                          leading: const Icon(
                            Icons.arrow_circle_right_outlined,
                          ),
                          trailing: IconButton(
                            onPressed: () => vm.verHistorial(),
                            icon: const Icon(Icons.history),
                            tooltip: AppLocalizations.of(context)!.translate(
                              BlockTranslate.botones,
                              'historial',
                            ),
                          ),
                        ),
                      ),
                      //Listado de responsables anteriores
                      if (vm.historialResposables == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (vm.responsablesHistorial.isEmpty)
                              Text(
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.tareas,
                                  'sinHistorialResp',
                                ),
                                style: AppTheme.style(
                                  context,
                                  Styles.bold,
                                ),
                              ),
                            if (vm.responsablesHistorial.isNotEmpty)
                              Text(
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.tareas,
                                  'historialResp',
                                ),
                                style: AppTheme.style(
                                  context,
                                  Styles.bold,
                                ),
                              ),
                            CardWidget(
                              color: AppTheme.color(
                                context,
                                Styles.secondBackground,
                              ),
                              elevation: 0,
                              borderWidth: 1.5,
                              borderColor: AppTheme.color(
                                context,
                                Styles.greyBorder,
                              ),
                              raidus: 10,
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: vm.responsablesHistorial.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final ResponsableModel responsable =
                                      vm.responsablesHistorial[index];
                                  return ListTile(
                                    title: Text(
                                      responsable.tUserName,
                                      style: AppTheme.style(
                                        context,
                                        Styles.inactive,
                                      ),
                                    ),
                                    leading: const Icon(Icons.person_4),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.tareas,
                            'invitados',
                          ),
                          style: AppTheme.style(
                            context,
                            Styles.bold,
                          ),
                        ),
                        trailing: IconButton(
                          //tipoBusqueda = 4 para actualizar invitados
                          onPressed: () => vmUsuarios.irUsuarios(context, 4),
                          icon: const Icon(
                            Icons.person_add_alt_1_outlined,
                          ),
                          tooltip: AppLocalizations.of(context)!.translate(
                            BlockTranslate.botones,
                            'agregarInvitado',
                          ),
                        ),
                      ),
                      CardWidget(
                        color: AppTheme.color(
                          context,
                          Styles.secondBackground,
                        ),
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: AppTheme.color(
                          context,
                          Styles.greyBorder,
                        ),
                        raidus: 10,
                        child: ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: vm.invitados.length,
                          itemBuilder: (BuildContext context, int index) {
                            final InvitadoModel invitado = vm.invitados[index];
                            return ListTile(
                              title: Text(
                                invitado.userName,
                                style: AppTheme.style(
                                  context,
                                  Styles.normal,
                                ),
                              ),
                              leading: const Icon(Icons.person_4),
                              trailing: IconButton(
                                onPressed: () => vm.eliminarInvitado(
                                  context,
                                  invitado,
                                  index,
                                ),
                                icon: const Icon(Icons.close),
                                tooltip:
                                    AppLocalizations.of(context)!.translate(
                                  BlockTranslate.botones,
                                  'eliminarInvitado',
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'creadorT',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      CardWidget(
                        color: AppTheme.color(
                          context,
                          Styles.secondBackground,
                        ),
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: AppTheme.color(
                          context,
                          Styles.greyBorder,
                        ),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            vm.tarea!.usuarioCreador ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.general,
                                  'noDisponible',
                                ),
                            style: AppTheme.style(
                              context,
                              Styles.normal,
                            ),
                          ),
                          leading: const Icon(
                            Icons.arrow_circle_right_outlined,
                          ),
                        ),
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

class _ActualizarEstado extends StatelessWidget {
  const _ActualizarEstado();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetalleTareaViewModel>(context);

    final vmCrear = Provider.of<CrearTareaViewModel>(context);

    final List<EstadoModel> estados = vmCrear.estados;

    return CardWidget(
      color: AppTheme.color(
        context,
        Styles.secondBackground,
      ),
      elevation: 0,
      borderWidth: 0,
      raidus: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField2<EstadoModel>(
          value: vm.estadoAtual,
          isExpanded: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
          hint: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.tareas,
              'nuevoEstado',
            ),
            style: AppTheme.style(
              context,
              Styles.normal,
            ),
          ),
          items: estados
              .map(
                (item) => DropdownMenuItem<EstadoModel>(
                  value: item,
                  child: Text(
                    item.descripcion,
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => vm.actualizarEstado(
            context,
            value!,
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 15),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.edit,
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
        ),
      ),
    );
  }
}

class _ActualizarPrioridad extends StatelessWidget {
  const _ActualizarPrioridad();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetalleTareaViewModel>(context);

    final vmCrear = Provider.of<CrearTareaViewModel>(context);

    final List<PrioridadModel> prioridades = vmCrear.prioridades;

    return CardWidget(
      color: AppTheme.color(
        context,
        Styles.secondBackground,
      ),
      elevation: 0,
      borderWidth: 0,
      raidus: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField2<PrioridadModel>(
          value: vm.prioridadActual,
          isExpanded: true,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
          hint: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.tareas,
              'nuevaPrioridad',
            ),
            style: AppTheme.style(
              context,
              Styles.normal,
            ),
          ),
          items: prioridades
              .map(
                (item) => DropdownMenuItem<PrioridadModel>(
                  value: item,
                  child: Text(
                    item.nombre,
                    style: AppTheme.style(
                      context,
                      Styles.normal,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) => vm.actualizarPrioridad(
            context,
            value!,
          ),
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.only(right: 15),
          ),
          iconStyleData: const IconStyleData(
            icon: Icon(
              Icons.edit,
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
        ),
      ),
    );
  }
}
