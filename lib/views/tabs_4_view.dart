import 'package:flutter_post_printer_example/displays/tareas/view_models/tareas_view_model.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/views/views.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tabs4View extends StatefulWidget {
  const Tabs4View({Key? key}) : super(key: key);

  @override
  State<Tabs4View> createState() => _Tabs4ViewState();
}

class _Tabs4ViewState extends State<Tabs4View>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    final vmTarea = Provider.of<TareasViewModel>(context, listen: false);

    super.initState();
    vmTarea.tabController = TabController(length: 4, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    final vmTarea = Provider.of<TareasViewModel>(context);
    final vmMenu = Provider.of<MenuViewModel>(context);

    return Stack(
      children: [
        DefaultTabController(
          length: 4, // Número de pestañas
          child: Scaffold(
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
                  tooltip: AppLocalizations.of(context)!.translate(
                    BlockTranslate.botones,
                    'nueva',
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.note_add_outlined),
                ),
              ],
              bottom: TabBar(
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
                      'asignadas',
                    ),
                  ),
                  Tab(
                    text: AppLocalizations.of(context)!.translate(
                      BlockTranslate.tareas,
                      'invitaciones',
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: vmTarea.tabController,
              children: const [
                // Contenido de la primera pestaña
                DocumentView(),
                // Contenido de la segunda pestaña
                DetailsView(),
                // Contenido de la tercera pestaña
                PaymentView(),
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
