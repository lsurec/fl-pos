import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/themes/styles.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/referencia_view_model.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ReferenciaView extends StatelessWidget {
  const ReferenciaView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ReferenciaViewModel vm = Provider.of<ReferenciaViewModel>(context);
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.tareas,
                'buscarIdRef',
              ),
              style: StyleApp.title,
            ),
          ),
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: vm.buscarIdReferencia,
                      onFieldSubmitted: (criterio) => vm.buscarIdRefencia(
                        context,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppTheme.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'buscar',
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: AppTheme.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.search,
                            color: AppTheme.grey,
                          ),
                          onPressed: () => vm.buscarIdRefencia(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.translate(
                            BlockTranslate.general,
                            'registro',
                          )} (${vm.referencias.length})",
                          style: StyleApp.normalBold,
                        ),
                      ],
                    ),
                    const Divider(),
                    // _ReferenciasEncontradas()
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
            color: AppTheme.isDark()
                ? AppTheme.darkBackroundColor
                : AppTheme.backroundColor,
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}
