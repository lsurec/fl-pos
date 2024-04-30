// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/models/calendario_tarea_model.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:provider/provider.dart';

class Calendario2View extends StatefulWidget {
  const Calendario2View({super.key});

  @override
  State<Calendario2View> createState() => _Calendario2ViewState();
}

class _Calendario2ViewState extends State<Calendario2View> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadData(context));
  }

  loadData(BuildContext context) async {
    final vm = Provider.of<Calendario2ViewModel>(context, listen: false);
    vm.loadData(context);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<Calendario2ViewModel>(context, listen: false);

    return Stack(children: [
      Scaffold(
        appBar: AppBar(
          title: const Text(
            'Calendario nuevoooo',
            style: AppTheme.titleStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: vm.tareasHoraActual.length,
                    itemBuilder: (BuildContext context, int index) {
                      // Obtener la lista de tareas para la hora específica
                      List<TareaCalendarioModel> tareasHora = vm.tareasHoraActual;

                      // Si hay tareas para esta hora
                      if (tareasHora.isNotEmpty) {
                        print(" tareas ${tareasHora.length}");
                        // Retornar un ListTile para cada tarea
                        return ListTile(
                          title: Text("${tareasHora[index].tarea}"),
                          // Puedes agregar más información de la tarea aquí
                        );
                      } else {
                        print(" tareas ${tareasHora.length}");

                        // Si no hay tareas para esta hora, puedes retornar un widget vacío o null
                        return const SizedBox.shrink();
                      }
                    },
                  ),
              TextButton(
                onPressed: () => vm.mesSiguiente(),
                child: const Text(
                  "siquiente",
                  style: AppTheme.normalBoldStyle,
                ),
              ),
              const Text("holo", style: AppTheme.normalBoldStyle),
            ],
          ),
        ),
      )
    ]);
  }
}
