import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:provider/provider.dart';

class FechasView extends StatelessWidget {
  const FechasView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<FechasViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  IconButton(
                    onPressed: () => vm.restaurarFechas(),
                    icon: const Icon(
                      Icons.refresh,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'entrega',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.title,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => vm.abrirFechaEntrega(context),
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
                              )} ${Utilities.formatearFecha(vm.fechaEntrega)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => vm.abrirHoraEntrega(context),
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
                              )} ${Utilities.formatearHora(vm.fechaEntrega)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'recoger',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.title,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            onPressed: () => vm.abrirFechaRecoger(context),
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
                              )} ${Utilities.formatearFecha(vm.fechaRecoger)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () => vm.abrirHoraRecoger(context),
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
                              )} ${Utilities.formatearHora(vm.fechaRecoger)}",
                              style: AppTheme.style(
                                context,
                                Styles.normal,
                              ),
                            ),
                          )
                        ],
                      ),
                      const Divider(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
