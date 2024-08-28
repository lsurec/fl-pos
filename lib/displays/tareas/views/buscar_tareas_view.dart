import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class BuscarTareasView extends StatelessWidget {
  const BuscarTareasView({super.key});

  @override
  Widget build(BuildContext context) {
    final vmTarea = Provider.of<TareasViewModel>(context);
    // List<TareaModel> tareas = vmTarea.tareas;

    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(70.0),
            child: AppBar(
              // backgroundColor: Colors.blue,
              title: const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: BuscarTarea(),
              ),
              // Añade un borde en la parte inferior del AppBar
              bottom: PreferredSize(
                // Altura del borde
                preferredSize: const Size.fromHeight(2),
                child: Container(
                  color: AppTheme.color(
                    context,
                    Styles.greyBorder,
                  ), // Color del borde
                  height: 2, // Grosor del borde
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.general,
                          'registro',
                        )} (${vmTarea.tareas.length})",
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: RefreshIndicator(
            onRefresh: () => vmTarea.loadData(context),
            child: ListView(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.translate(
                              BlockTranslate.general,
                              'registro',
                            )} (${vmTarea.tareas.length})",
                            style: AppTheme.style(
                              context,
                              Styles.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (vmTarea.tareas.isNotEmpty) const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: vmTarea.tareas.length,
                              itemBuilder: (BuildContext context, int index) {
                                final TareaModel tarea = vmTarea.tareas[index];
                                return CardTask(tarea: tarea);
                              },
                            ),
                            if (vmTarea.tareas.isNotEmpty)
                              TextButton(
                                onPressed: () => vmTarea.buscarRangoTareas(
                                  context,
                                  vmTarea.searchController.text,
                                  1,
                                ),
                                child: Text(
                                  "Ver mas",
                                  style: AppTheme.style(
                                    context,
                                    Styles.normal,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (vmTarea.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.color(
              context,
              Styles.loading,
            ),
          ),
        if (vmTarea.isLoading) const LoadWidget(),
      ],
    );
  }
}
