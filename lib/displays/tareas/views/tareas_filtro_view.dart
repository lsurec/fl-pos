import 'package:flutter_post_printer_example/displays/tareas/view_models/tareas_view_model.dart';
import 'package:flutter_post_printer_example/displays/tareas/views/views.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TareasFiltroView extends StatefulWidget {
  const TareasFiltroView({Key? key}) : super(key: key);

  @override
  State<TareasFiltroView> createState() => _TareasFiltroViewState();
}

class _TareasFiltroViewState extends State<TareasFiltroView>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    final vmTarea = Provider.of<TareasViewModel>(context, listen: false);

    super.initState();
    vmTarea.tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) async {
    final vm = Provider.of<TareasViewModel>(context, listen: false);
    vm.loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final vmTarea = Provider.of<TareasViewModel>(context);
    final vmMenu = Provider.of<MenuViewModel>(context);

    return Stack(
      children: [
        DefaultTabController(
          length: 4, // Número de pestañas
          child: Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () => vmTarea.crearTarea(context),
              tooltip: AppLocalizations.of(context)!.translate(
                BlockTranslate.botones,
                'nueva',
              ),
              child: Icon(
                Icons.add,
                color: AppTheme.color(
                  context,
                  Styles.white,
                ),
                size: 30,
              ),
            ),
            appBar: AppBar(
              title: Text(
                vmMenu.name,
                style: AppTheme.style(
                  context,
                  Styles.title,
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.search,
                  ),
                  tooltip: AppLocalizations.of(context)!.translate(
                    BlockTranslate.botones,
                    'buscar',
                  ),
                ),
              ],
              bottom: TabBar(
                onTap: (index) => vmTarea.limpiarLista(context),
                controller: vmTarea.tabController,
                labelColor: AppTheme.color(
                  context,
                  Styles.normal,
                ),
                indicatorColor: AppTheme.color(
                  context,
                  Styles.darkPrimary,
                ),
                tabs: [
                  Tab(
                    text: AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'todas',
                    ),
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'creadas',
                    ),
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'invitaciones',
                    ),
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'asignadas',
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: vmTarea.tabController,
              children: const [
                // Contenido de la primera pestaña
                VerTodasView(),
                // Contenido de la segunda pestaña
                VerCreadasView(),
                // Contenido de la tercera pestaña
                VerInvitacionesView(),
                // Contenido de la cuarta pestaña
                VerAsignadasView(),
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
