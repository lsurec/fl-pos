import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/language_service.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/card_task_widgets.dart';
import 'package:provider/provider.dart';

class CargarTareasView extends StatefulWidget {
  const CargarTareasView({super.key});

  @override
  State<CargarTareasView> createState() => _CargarTareasViewState();
}

class _CargarTareasViewState extends State<CargarTareasView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;

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
        !_isLoading) {
      print("xd");
      // Detecta si se está a 100 píxeles del final y si no está cargando
      _loadMoreTasks();
    }
  }

  Future<void> _loadMoreTasks() async {
    setState(() {
      _isLoading = true; // Evita cargas múltiples mientras ya está cargando
    });

    await Provider.of<TareasViewModel>(context, listen: false)
        .recargarTodas(context);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final vmTarea = Provider.of<TareasViewModel>(context);
    List<TareaModel> tareas = vmTarea.tareasGenerales;

    return RefreshIndicator(
      onRefresh: () => vmTarea.obtenerTareasTodas(context),
      child: ListView(
        controller: _scrollController, // Asigna el ScrollController
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
                  if (_isLoading) // Indicador de carga al final de la lista
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

// class CargarTareasView extends StatelessWidget {
//   const CargarTareasView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final vmTarea = Provider.of<TareasViewModel>(context);
//     List<TareaModel> tareas = vmTarea.tareasGenerales;

//     return RefreshIndicator(
//       onRefresh: () => vmTarea.obtenerTareasTodas(context),
//       child: ListView(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(20),
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         "${AppLocalizations.of(context)!.translate(
//                           BlockTranslate.general,
//                           'registro',
//                         )} (${tareas.length})",
//                         style: AppTheme.style(
//                           context,
//                           Styles.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 10),
//                   const Divider(),
//                   const SizedBox(height: 10),
//                   ListView.builder(
//                     physics: const NeverScrollableScrollPhysics(),
//                     scrollDirection: Axis.vertical,
//                     shrinkWrap: true,
//                     itemCount: tareas.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       final TareaModel tarea = tareas[index];
//                       return CardTask(tarea: tarea);
//                     },
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
