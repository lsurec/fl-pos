import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/card_task_widgets.dart';
import 'package:flutter_post_printer_example/widgets/search_task_widget.dart';
import 'package:provider/provider.dart';

class VerTodasView extends StatelessWidget {
  const VerTodasView({super.key});

  @override
  Widget build(BuildContext context) {
    final vmTarea = Provider.of<TareasViewModel>(context);
    List<TareaModel> tareas = vmTarea.tareas;

    return RefreshIndicator(
      onRefresh: () => vmTarea.loadData(context),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SearchTask(
                    keyType: vmTarea.todas,
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
