import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
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
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'observacion',
                        ),
                        style: AppTheme.normalBoldStyle,
                      ),
                      Text(
                        vm.tarea!.descripcionTarea,
                        style: AppTheme.normalStyle,
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
                              style: AppTheme.normalBoldStyle,
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
                        style: AppTheme.normalBoldStyle,
                      ),
                      const _ActualizarEstado(),

                      //ACTUALIZAR PRIORIDAD DE LA TAREA
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'prioridadT',
                        ),
                        style: AppTheme.normalBoldStyle,
                      ),
                      const _ActualizarPrioridad(),

                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'feHoInicio',
                        ),
                        style: AppTheme.normalBoldStyle,
                      ),
                      CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: const Color.fromRGBO(0, 0, 0, 0.12),
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
                                style: AppTheme.normalStyle,
                              ),
                              const Spacer(),
                              const Icon(Icons.schedule_outlined),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Text(
                                Utilities.formatearHoraString(
                                  vm.tarea!.fechaIni,
                                ),
                                style: AppTheme.normalStyle,
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
                        style: AppTheme.normalBoldStyle,
                      ),
                      CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: const Color.fromRGBO(0, 0, 0, 0.12),
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
                                style: AppTheme.normalStyle,
                              ),
                              const Spacer(),
                              const Icon(Icons.schedule_outlined),
                              const Padding(padding: EdgeInsets.only(left: 10)),
                              Text(
                                Utilities.formatearHoraString(
                                  vm.tarea!.fechaFin,
                                ),
                                style: AppTheme.normalStyle,
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
                        style: AppTheme.normalBoldStyle,
                      ),
                      CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: const Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            vm.tarea!.desTipoTarea,
                            style: AppTheme.normalStyle,
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
                        style: AppTheme.normalBoldStyle,
                      ),
                      CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: const Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'noDisponible',
                            ),
                            style: AppTheme.normalStyle,
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
                        style: AppTheme.normalBoldStyle,
                      ),
                      CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: const Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            vm.tarea!.usuarioResponsable ??
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.general,
                                  'noAsignado',
                                ),
                            style: AppTheme.normalStyle,
                          ),
                          leading: const Icon(
                            Icons.arrow_circle_right_outlined,
                          ),
                          trailing: IconButton(
                            onPressed: () => vm.verHistorial(),
                            icon: const Icon(Icons.history),
                            tooltip: AppLocalizations.of(context)!.translate(
                              BlockTranslate.tooltip,
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
                              style: AppTheme.normalBoldStyle,
                            ),
                            if (vm.responsablesHistorial.isNotEmpty)
                              Text(
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.tareas,
                                  'historialResp',
                                ),
                                style: AppTheme.normalBoldStyle,
                              ),
                            CardWidget(
                              elevation: 0,
                              borderWidth: 1.5,
                              borderColor: const Color.fromRGBO(0, 0, 0, 0.12),
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
                                      style: AppTheme.inactivoStyle,
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
                          style: AppTheme.normalBoldStyle,
                        ),
                        trailing: IconButton(
                          //tipoBusqueda = 4 para actualizar invitados
                          onPressed: () => vmUsuarios.irUsuarios(
                            context,
                            4,
                          ),
                          icon: const Icon(
                            Icons.person_add_alt_1_outlined,
                          ),
                          tooltip: AppLocalizations.of(context)!.translate(
                            BlockTranslate.tooltip,
                            'agregarInvitado',
                          ),
                        ),
                      ),
                      CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: const Color.fromRGBO(0, 0, 0, 0.12),
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
                                style: AppTheme.normalStyle,
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
                                  BlockTranslate.tooltip,
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
                        style: AppTheme.normalBoldStyle,
                      ),
                      CardWidget(
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: const Color.fromRGBO(0, 0, 0, 0.12),
                        raidus: 10,
                        child: ListTile(
                          title: Text(
                            vm.tarea!.nomUser,
                            style: AppTheme.normalStyle,
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
            color: AppTheme.backroundColor,
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
            style: AppTheme.normalStyle,
          ),
          items: estados
              .map(
                (item) => DropdownMenuItem<EstadoModel>(
                  value: item,
                  child: Text(
                    item.descripcion,
                    style: AppTheme.normalStyle,
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
              color: Colors.black45,
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
            style: AppTheme.normalStyle,
          ),
          items: prioridades
              .map(
                (item) => DropdownMenuItem<PrioridadModel>(
                  value: item,
                  child: Text(
                    item.nombre,
                    style: AppTheme.normalStyle,
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
              color: Colors.black45,
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
