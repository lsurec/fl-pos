import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/shr_local_config/view_models/view_models.dart';
import 'package:flutter_post_printer_example/models/models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/utilities/utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/texts_widgets.dart';
import 'package:provider/provider.dart';

class ErrorInfoView extends StatelessWidget {
  const ErrorInfoView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ApiResponseModel error =
        ModalRoute.of(context)?.settings.arguments as ApiResponseModel;

    DateTime date = error.timestamp;

    final vm = Provider.of<ErrorInfoViewModel>(context);
    final vmLogin = Provider.of<LoginViewModel>(context);
    final vmLocal = Provider.of<LocalSettingsViewModel>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => vm.shareDoc(error, context),
        child: const Icon(
          Icons.share,
        ),
      ),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.translate(
            BlockTranslate.error,
            "informe",
          ),
          style: StyleApp.title,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mensaje:",
                style: StyleApp.normalBold,
              ), //TODO:Translate
              const SizedBox(height: 2),

              Text(
                error.message,
                style: StyleApp.normal,
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              TextsWidget(
                title: "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.general,
                  "usuario",
                )}: ",
                text: vmLogin.user,
              ),
              const SizedBox(height: 10),
              TextsWidget(
                title: "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.fecha,
                  "fecha",
                )} ",
                text:
                    " ${Utilities.formatearFecha(date)} ${date.hour}:${date.minute}:${date.second}",
              ),
              const SizedBox(height: 10),
              TextsWidget(
                title: "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.localConfig,
                  "empresa",
                )}: ",
                text:
                    "${vmLocal.selectedEmpresa?.empresaNombre} (${vmLocal.selectedEmpresa?.empresa})",
              ),
              const SizedBox(height: 10),
              TextsWidget(
                title: "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.localConfig,
                  "estacion",
                )}: ",
                text:
                    "${vmLocal.selectedEstacion?.descripcion} (${vmLocal.selectedEstacion?.estacionTrabajo})",
              ),
              const SizedBox(height: 10),
              const Divider(),
              ListTile(
                title: Text(
                  "${AppLocalizations.of(context)!.translate(
                    BlockTranslate.error,
                    "servicio",
                  )}:",
                  style: StyleApp.normalBold,
                ),
                subtitle: SelectableText(
                  error.url ??
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.error,
                        "indefinido",
                      ),
                  style: StyleApp.normal.copyWith(
                    color: Colors.blueAccent,
                    decoration: TextDecoration.underline,
                    decorationColor:
                        Colors.blueAccent, // Color del subrayado (opcional)
                  ),
                ),
                contentPadding: EdgeInsets.zero,
                trailing: IconButton(
                  onPressed: error.url != null
                      ? () => Utilities.copyToClipboard(context, error.url!)
                      : null,
                  color: Colors.grey,
                  icon: const Icon(
                    Icons.copy,
                  ),
                ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.error,
                      "origen",
                    ),
                    style: StyleApp.normalBold,
                  ),
                  IconButton(
                    onPressed: error.storeProcedure.isNotEmpty
                        ? () => vm.copyPa(
                              context,
                              error,
                            )
                        : null,
                    icon: const Icon(
                      Icons.copy,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              Text(
                error.storeProcedure.isEmpty
                    ? AppLocalizations.of(context)!.translate(
                        BlockTranslate.error,
                        "noAplica",
                      )
                    : error.storeProcedure,
                style: StyleApp.normal.copyWith(
                  fontFamily: 'monospace',
                ),
              ),
              if (error.parameters != null)
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: error.parameters!.length,
                  itemBuilder: (context, index) {
                    String key = error.parameters!.keys
                        .elementAt(index); // Obtener clave
                    dynamic value = error.parameters![key]; // Obtener valor
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        top: 2,
                        bottom: 2,
                      ),
                      child: Text(
                        "$key = $value",
                        style: StyleApp.normal.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 10),
              const Divider(),
              Text(
                "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.general,
                  "descripcion",
                )}:",
                style: StyleApp.normalBold,
              ),
              Text(
                error.error,
                style: StyleApp.normal,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
