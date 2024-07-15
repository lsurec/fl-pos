import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
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
        child: Icon(
          Icons.share,
          color:  AppTheme.color(context, Styles.white,),
        ),
      ),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.error,
            "informe",
          ),
          style: AppTheme.style(
            context,
            Styles.title,
            
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("${AppLocalizations.of(context)!.translate(
                BlockTranslate.general,
                "usuario",
              )}: ${vmLogin.user}"),
              const SizedBox(height: 10),
              Text(
                "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.fecha,
                  "fecha",
                )}: ${Utilities.formatearFecha(date)} ${date.hour}:${date.minute}:${date.second}",
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
                "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.localConfig,
                  "empresa",
                )}: ${vmLocal.selectedEmpresa?.empresaNombre} (${vmLocal.selectedEmpresa?.empresa})",
              ),
              const SizedBox(height: 10),
              Text("${AppLocalizations.of(context)!.translate(
                BlockTranslate.localConfig,
                "estacion",
              )}: ${vmLocal.selectedEstacion?.descripcion} (${vmLocal.selectedEstacion?.estacionTrabajo})"),

              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.error,
                  "servicio",
                ),
              ),
              Text(
                error.url ??
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.error,
                      "indefinido",
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                AppLocalizations.of(context)!.translate(
                  BlockTranslate.error,
                  "origen",
                ),
              ),
              Text(
                error.storeProcedure ??
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.error,
                      "noAplica",
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.general,
                  "descripcion",
                )}:",
              ),
              Text(error.description),
            ],
          ),
        ),
      ),
    );
  }
}
