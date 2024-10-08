import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DetalleTareaCalendariaView extends StatelessWidget {
  const DetalleTareaCalendariaView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<DetalleTareaCalendarioViewModel>(context);
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
              )}: ${vm.tarea!.tarea}',
              style: StyleApp.title,
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
                        style: StyleApp.normalBold,
                      ),
                      GestureDetector(
                        onLongPress: () => Utilities.copyToClipboard(
                          context,
                          vm.tarea!.observacion1,
                        ),
                        child: Text(
                          vm.tarea!.observacion1,
                          style: StyleApp.normal,
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => vm.comentariosTarea(context),
                            child: Row(
                              children: [
                                const Icon(Icons.add_comment_outlined),
                                const Padding(
                                  padding: EdgeInsets.only(
                                    right: 5,
                                  ),
                                ),
                                Text(
                                  "${AppLocalizations.of(context)!.translate(
                                    BlockTranslate.tareas,
                                    'comentarios',
                                  )} (${vmComentarios.comentarioDetalle.length})",
                                  style: StyleApp.title,
                                ),
                              ],
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
                        style: StyleApp.normalBold,
                      ),
                      const _ActualizarEstado(),

                      //ACTUALIZAR PRIORIDAD DE LA TAREA
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'prioridadT',
                        ),
                        style: StyleApp.normalBold,
                      ),
                      const _ActualizarPrioridad(),

                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'feHoInicio',
                        ),
                        style: StyleApp.normalBold,
                      ),
                      CardWidget(
                        elevation: 0,
                        borderWidth: 1,
                        borderColor: AppTheme.border,
                        raidus: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range),
                              const Padding(padding: EdgeInsets.only(left: 15)),
                              Text(
                                Utilities.formatearFechaString(
                                  vm.tarea!.fechaIni,
                                ),
                                style: StyleApp.normal,
                              ),
                              const Spacer(),
                              const Icon(Icons.schedule_outlined),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Text(
                                Utilities.formatearHoraString(
                                  vm.tarea!.fechaIni,
                                ),
                                style: StyleApp.normal,
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
                        style: StyleApp.normalBold,
                      ),
                      CardWidget(
                        elevation: 0,
                         borderWidth: 1,
                        borderColor: AppTheme.border,
                        raidus: 10,
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range),
                              const Padding(padding: EdgeInsets.only(left: 15)),
                              Text(
                                Utilities.formatearFechaString(
                                  vm.tarea!.fechaFin,
                                ),
                                style: StyleApp.normal,
                              ),
                              const Spacer(),
                              const Icon(Icons.schedule_outlined),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Text(
                                Utilities.formatearHoraString(
                                  vm.tarea!.fechaFin,
                                ),
                                style: StyleApp.normal,
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
                        style: StyleApp.normalBold,
                      ),
                      CardWidget(
                        elevation: 0,
                         borderWidth: 1,
                        borderColor: AppTheme.border,
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            vm.tarea!.desTipoTarea,
                            style: StyleApp.normal,
                          ),
                          leading:
                              const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      ),

                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'idRefT',
                        ),
                        style: StyleApp.normalBold,
                      ),
                      CardWidget(
                        elevation: 0,
                         borderWidth: 1,
                        borderColor: AppTheme.border,
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'noDisponible',
                            ),
                            style: StyleApp.normal,
                          ),
                          leading: const Icon(
                            Icons.arrow_circle_right_outlined,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.tareas,
                            'responsableT',
                          ),
                          style: StyleApp.normalBold,
                        ),
                        trailing: IconButton(
                          //tipoBusqueda = 3 para actualizar responsable
                          onPressed: () => vmUsuarios.irUsuarios(
                            context,
                            5,
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.botones,
                              'cambiarResponsable',
                            ),
                          ),
                          icon: const Icon(
                            Icons.person_add_alt_1_outlined,
                          ),
                          tooltip: AppLocalizations.of(context)!.translate(
                            BlockTranslate.botones,
                            'cambiarResponsable',
                          ),
                        ),
                      ),
                      CardWidget(
                        elevation: 0,
                         borderWidth: 1,
                        borderColor: AppTheme.border,
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            vm.tarea!.usuarioResponsable ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.tareas,
                                  'noAsignado',
                                ),
                            style: StyleApp.normal,
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
                            Text(
                              AppLocalizations.of(context)!.translate(
                                BlockTranslate.tareas,
                                'sinHistorialResp',
                              ),
                              style: StyleApp.normalBold,
                            ),
                            if (vm.responsablesHistorial.isNotEmpty)
                              Text(
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.tareas,
                                  'historialResp',
                                ),
                                style: StyleApp.normalBold,
                              ),
                            CardWidget(
                              elevation: 0,
                               borderWidth: 1,
                              borderColor: AppTheme.border,
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
                                      style: StyleApp.greyText,
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
                          style: StyleApp.normalBold,
                        ),
                        trailing: IconButton(
                          //tipoBusqueda = 4 para actualizar invitados
                          onPressed: () => vmUsuarios.irUsuarios(
                            context,
                            4,
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.botones,
                              'agregarInvitado',
                            ),
                          ),
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
                        elevation: 0,
                         borderWidth: 1,
                        borderColor: AppTheme.border,
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
                                style: StyleApp.normal,
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
                        style: StyleApp.normalBold,
                      ),
                      CardWidget(
                        elevation: 0,
                         borderWidth: 1,
                        borderColor: AppTheme.border,
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            vm.tarea!.nomUser,
                            style: StyleApp.normal,
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
            color: AppTheme.isDark()
                ? AppTheme.darkBackroundColor
                : AppTheme.backroundColor,
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
    final vm = Provider.of<DetalleTareaCalendarioViewModel>(context);

    final vmCrear = Provider.of<CrearTareaViewModel>(context);

    final List<EstadoModel> estados = vmCrear.estados;

    return CardWidget(
      elevation: 0,
      borderColor: AppTheme.border,
      borderWidth: 1,
      raidus: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField2<EstadoModel>(
          value: vm.estadoAtual,
          isExpanded: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          hint: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.tareas,
              'nuevoEstado',
            ),
            style: StyleApp.normal,
          ),
          items: estados
              .map(
                (item) => DropdownMenuItem<EstadoModel>(
                  value: item,
                  child: Text(
                    item.descripcion,
                    style: StyleApp.normal,
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
    final vm = Provider.of<DetalleTareaCalendarioViewModel>(context);

    final vmCrear = Provider.of<CrearTareaViewModel>(context);

    final List<PrioridadModel> prioridades = vmCrear.prioridades;

    return CardWidget(
      elevation: 0,
      borderWidth: 1,
      borderColor: AppTheme.border,
      raidus: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DropdownButtonFormField2<PrioridadModel>(
          value: vm.prioridadActual,
          isExpanded: true,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
          hint: Text(
            AppLocalizations.of(context)!.translate(
              BlockTranslate.tareas,
              'nuevaPrioridad',
            ),
            style: StyleApp.normal,
          ),
          items: prioridades
              .map(
                (item) => DropdownMenuItem<PrioridadModel>(
                  value: item,
                  child: Text(
                    item.nombre,
                    style: StyleApp.normal,
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
