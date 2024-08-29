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

    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(
              100,
            ),
            child: AppBar(
              title: const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: BuscarTarea(),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(2),
                child: Column(
                  children: [
                    Container(
                      color: AppTheme.color(
                        context,
                        Styles.greyBorder,
                      ),
                      height: 2,
                    ),
                    PreferredSize(
                      preferredSize: const Size.fromHeight(2),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 10,
                          left: 0,
                          right: 20,
                          top: 5,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "${AppLocalizations.of(context)!.translate(
                                BlockTranslate.general,
                                'registro',
                              )} (${vmTarea.tareas.length})",
                              style: AppTheme.style(context, Styles.bold),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
              left: 20,
              right: 20,
              top: 5,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => vmTarea.loadData(context),
                    child: ListView.builder(
                      itemCount: vmTarea.tareas.length + 1,
                      itemBuilder: (BuildContext context, int index) {
                        if (index < vmTarea.tareas.length) {
                          final TareaModel tarea = vmTarea.tareas[index];
                          return CardTask(tarea: tarea);
                        } else if (vmTarea.tareas.length > 1) {
                          // Botón "Ver más" al final de la lista
                          return TextButton(
                            onPressed: () => vmTarea.buscarRangoTareas(
                              context,
                              vmTarea.searchController.text,
                              1,
                            ),
                            child: Text(
                              "Ver más",
                              style: AppTheme.style(context, Styles.normal),
                            ),
                          );
                        }
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (vmTarea.isLoading)
          ModalBarrier(
            dismissible: false,
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
