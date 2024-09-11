import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TareasView extends StatefulWidget {
  const TareasView({super.key});

  @override
  State<TareasView> createState() => _TareasViewState();
}

class _TareasViewState extends State<TareasView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) async {
    final vm = Provider.of<TareasViewModel>(context, listen: false);
    vm.loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);
    List<TareaModel> tareas = vm.tareas;

    return RefreshIndicator(
      onRefresh: () => vm.loadData(context),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // _RadioFilter(),
                const _InputSerach(),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'registro',
                      )} (${tareas.length})",
                      style: StyleApp.normalBold,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: tareas.length,
                  itemBuilder: (BuildContext context, int index) {
                    final TareaModel tarea = tareas[index];
                    return _CardTask(tarea: tarea);
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardTask extends StatelessWidget {
  const _CardTask({
    required this.tarea,
  });

  final TareaModel tarea;

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);
    //color de la tarea
    final List<int> colorTarea = Utilities.hexToRgb(tarea.backColor!);
    return GestureDetector(
      onTap: () => vm.detalleTarea(context, tarea),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextsWidget(
                      title: AppLocalizations.of(context)!.translate(
                        BlockTranslate.tareas,
                        'numTarea',
                      ),
                      text: "${tarea.iDTarea}",
                    ),
                    const Spacer(),
                    Text(
                      tarea.tareaEstado ??
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.general,
                            'noDisponible',
                          ),
                      style: StyleApp.normal,
                    ),
                    const SizedBox(width: 20),
                    Icon(
                      Icons.circle,
                      color: Color.fromRGBO(
                        colorTarea[0],
                        colorTarea[1],
                        colorTarea[2],
                        1,
                      ),
                    ),
                  ],
                ),
                TextsWidget(
                  title: AppLocalizations.of(context)!.translate(
                    BlockTranslate.fecha,
                    'fecha',
                  ),
                  text: Utilities.formatearFechaHora(
                    tarea.tareaFechaIni,
                  ),
                ),
                if (tarea.ultimoComentario != null) const SizedBox(height: 10),
                if (tarea.ultimoComentario != null)
                  ExpansionTile(
                    //Traducir
                    title: const Text(
                      'Ver último comentario',
                      style: StyleApp.normal,
                      textAlign: TextAlign.end,
                    ),
                    children: [
                      CardWidget(
                        margin: const EdgeInsets.only(bottom: 10),
                        color: AppTheme.color(
                          context,
                          Styles.secondBackground,
                        ),
                        elevation: 0,
                        borderWidth: 1.5,
                        borderColor: AppTheme.color(
                          context,
                          Styles.border,
                        ),
                        raidus: 15,
                        child: Column(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    tarea.usuarioUltimoComentario!,
                                    style: StyleApp.normalBold,
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
                                          tarea.fechaUltimoComentario!,
                                        ),
                                        style: StyleApp.normal,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  GestureDetector(
                                    onLongPress: () =>
                                        Utilities.copyToClipboard(
                                      context,
                                      tarea.ultimoComentario ?? '',
                                    ),
                                    child: Text(
                                      tarea.ultimoComentario ??
                                          AppLocalizations.of(context)!
                                              .translate(
                                            BlockTranslate.general,
                                            'noDisponible',
                                          ),
                                      style: StyleApp.normal,
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (tarea.ultimoComentario != null) const SizedBox(height: 5),
              ],
            ),
          ),
          CardWidget(
            margin: tarea.ultimoComentario != null
                ? const EdgeInsets.only(
                    top: 0,
                  )
                : const EdgeInsets.only(
                    top: 5,
                  ),
            color: AppTheme.color(
              context,
              Styles.secondBackground,
            ),
            elevation: 0,
            borderWidth: 1.5,
            borderColor: AppTheme.color(
              context,
              Styles.tareaBorder,
            ),
            raidus: 15,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      tarea.descripcion ??
                          AppLocalizations.of(context)!.translate(
                            BlockTranslate.general,
                            'noDisponible',
                          ),
                      style: StyleApp.normalBold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'idRef',
                        )}: ",
                        style: StyleApp.normal,
                      ),
                      Text(
                        '${tarea.iDReferencia}',
                        style: StyleApp.normal,
                      ),
                    ],
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'creador',
                    )} ${tarea.usuarioCreador}",
                    style: StyleApp.normal,
                  ),
                  Text(
                    "${AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'responsable',
                    )} ${tarea.usuarioResponsable ?? AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'noAsignado',
                        )}",
                    style: StyleApp.normal,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${AppLocalizations.of(context)!.translate(
                        BlockTranslate.general,
                        'observacion',
                      )}:",
                      style: StyleApp.normal,
                    ),
                  ),
                  Text(
                    tarea.tareaObservacion1 ??
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'noDisponible',
                        ),
                    style: StyleApp.normal,
                    textAlign: TextAlign.justify,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Divider(),
          const SizedBox(height: 5),
        ],
      ),
    );
  }
}

class _InputSerach extends StatelessWidget {
  const _InputSerach();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TareasViewModel>(context);

    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: vm.formKeySearch,
      child: TextFormField(
        onFieldSubmitted: (value) => vm.searchText(context),
        textInputAction: TextInputAction.search,
        controller: vm.searchController,
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
          hintText: AppLocalizations.of(context)!.translate(
            BlockTranslate.tareas,
            'buscar',
          ),
          labelText: AppLocalizations.of(context)!.translate(
            BlockTranslate.tareas,
            'buscar',
          ),
          suffixIcon: IconButton(
            tooltip: AppLocalizations.of(context)!.translate(
              BlockTranslate.tareas,
              'buscar',
            ),
            icon: Icon(
              Icons.search,
              color: AppTheme.color(
                context,
                Styles.darkPrimary,
              ),
            ),
            onPressed: () => vm.searchText(context),
          ),
        ),
      ),
    );
  }
}
