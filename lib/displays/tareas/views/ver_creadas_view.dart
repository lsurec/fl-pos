import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/card_task_widgets.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:provider/provider.dart';

class VerCreadasView extends StatefulWidget {
  const VerCreadasView({super.key});

  @override
  State<VerCreadasView> createState() => _VerCreadasViewState();
}

class _VerCreadasViewState extends State<VerCreadasView> {
  final ScrollController _scrollController = ScrollController();
  bool cargarCreadas = false;

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
        !cargarCreadas) {
      // Detecta si se está a 100 píxeles del final y si no está cargando
      recargarMasTareas();
    }
  }

  Future<void> recargarMasTareas() async {
    setState(() {
      // Evita cargas múltiples mientras ya está cargando
      cargarCreadas = true;
    });

    await Provider.of<TareasViewModel>(
      context,
      listen: false,
    ).recargarCreadas(context);

    setState(() {
      cargarCreadas = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vmTarea = Provider.of<TareasViewModel>(context);
    List<TareaModel> tareas = vmTarea.tareasCreadas;

    return RefreshIndicator(
      onRefresh: () => vmTarea.obtenerTareasCreadas(context),
      child: ListView(
        controller: _scrollController,
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
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
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
                  if (cargarCreadas)
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
