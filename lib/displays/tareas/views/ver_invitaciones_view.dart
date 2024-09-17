import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/widgets/card_task_widgets.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:provider/provider.dart';

class VerInvitacionesView extends StatefulWidget {
  const VerInvitacionesView({super.key});

  @override
  State<VerInvitacionesView> createState() => _VerInvitacionesViewState();
}

class _VerInvitacionesViewState extends State<VerInvitacionesView> {
  final ScrollController _scrollController = ScrollController();
  bool cargarInvitaciones = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 800 &&
        !cargarInvitaciones) {
      // Detecta si se está a 100 píxeles del final y si no está cargando
      recargarMasTareas();
    }
  }

  Future<void> recargarMasTareas() async {
    setState(() {
      // Evita cargas múltiples mientras ya está cargando
      cargarInvitaciones = true;
    });

    await Provider.of<TareasViewModel>(
      context,
      listen: false,
    ).recargarInvitaciones(context);

    setState(() {
      cargarInvitaciones = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vmTarea = Provider.of<TareasViewModel>(context);
    List<TareaModel> tareas = vmTarea.tareasInvitaciones;

    return RefreshIndicator(
      onRefresh: () => vmTarea.obtenerTareasInvitaciones(context),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                  const SizedBox(height: 10),
                  const Divider(),
                  const SizedBox(height: 10),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: tareas.length,
                    itemBuilder: (BuildContext context, int index) {
                      final TareaModel tarea = tareas[index];
                      return CardTask(tarea: tarea);
                    },
                  ),
                  // Indicador de carga al final de la lista
                  if (cargarInvitaciones)
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: CircularProgressIndicator(),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
