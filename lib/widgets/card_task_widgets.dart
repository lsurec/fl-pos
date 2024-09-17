import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/widgets/card_widget.dart';
import 'package:flutter_post_printer_example/widgets/texts_widgets.dart';
import 'package:provider/provider.dart';

class CardTask extends StatelessWidget {
  const CardTask({
    super.key,
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
                    EstadoColor(colorTarea: colorTarea),
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
                    title: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.tareas,
                        'ultimoComentario',
                      ),
                      style: StyleApp.normal,
                      textAlign: TextAlign.end,
                    ),
                    children: [
                      CardWidget(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 0,
                        borderWidth: 1.0,
                        borderColor: AppNewTheme.grey,
                        raidus: 15,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                    width: 1,
                                    color: AppNewTheme.grey,
                                  ),
                                  left: BorderSide(
                                    width: 1,
                                    color: AppNewTheme.grey,
                                  ),
                                  right: BorderSide(
                                    width: 1,
                                    color: AppNewTheme.grey,
                                  ),
                                ),
                                borderRadius: BorderRadius.only(
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
                                  width: 1,
                                  color: AppNewTheme.grey,
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
            elevation: 0,
            borderWidth: 1,
            borderColor: AppNewTheme.grey,
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

class EstadoColor extends StatelessWidget {
  const EstadoColor({
    super.key,
    required this.colorTarea,
  });

  final List<int> colorTarea;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24.0,
      height: 24.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color.fromRGBO(
          colorTarea[0],
          colorTarea[1],
          colorTarea[2],
          1,
        ),
        border: Border.all(
          color: AppNewTheme.grey,
          width: 1.0,
        ),
      ),
    );
  }
}
