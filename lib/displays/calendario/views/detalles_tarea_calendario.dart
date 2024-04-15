import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/calendario/view_models/view_models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DetalleTareaCalendariaView extends StatelessWidget {
  const DetalleTareaCalendariaView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CalendarioViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              'Detalles tarea calendario',
              style: AppTheme.titleStyle,
            ),
          ),
          body: ListView(
            children: const [
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Registros (2)",
                          style: AppTheme.normalBoldStyle,
                        ),
                      ],
                    ),
                    Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
        //importarte para mostrar la pantalla de carga
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
