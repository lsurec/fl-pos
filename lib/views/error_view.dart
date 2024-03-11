import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:provider/provider.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ErrorModel error =
        ModalRoute.of(context)?.settings.arguments as ErrorModel;

    DateTime date = error.date;

    final vm = Provider.of<ErrorViewModel>(context);
    final vmLogin = Provider.of<LoginViewModel>(context);
    final vmLocal = Provider.of<LocalSettingsViewModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => vm.shareDoc(error, context),
        child: const Icon(Icons.share),
      ),
      appBar: AppBar(
        title: const Text(
          "Informe de error",
          style: AppTheme.titleStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Usuario: ${vmLogin.user}"),
              const SizedBox(height: 10),
              Text(
                "Fecha: ${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}:${date.second}",
              ),

              const SizedBox(height: 10),
              // const Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text("Documento:"),
              //         Text("185185"),
              //       ],
              //     ),
              //     Column(
              //       crossAxisAlignment: CrossAxisAlignment.end,
              //       children: [
              //         const Text("Serie:"),
              //         Text("FEL10"),
              //       ],
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 20),
              Text(
                "Empresa: ${vmLocal.selectedEmpresa?.empresaNombre} (${vmLocal.selectedEmpresa?.empresa})",
              ),
              const SizedBox(height: 10),
              Text(
                  "Estacion de trabajo: ${vmLocal.selectedEstacion?.descripcion} (${vmLocal.selectedEstacion?.estacionTrabajo})"),

              const SizedBox(height: 10),
              const Text("Servicio origen:"),
              Text(error.url ?? "No definido"),
              const SizedBox(height: 10),
              const Text("DB Origen:"),
              Text(error.storeProcedure ?? "No Aplica."),
              const SizedBox(height: 10),
              const Text("Descripcion:"),
              Text(error.description),
            ],
          ),
        ),
      ),
    );
  }
}
