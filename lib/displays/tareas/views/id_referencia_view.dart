// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/tareas/models/models.dart';
import 'package:flutter_post_printer_example/displays/tareas/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class IdReferenciaView extends StatelessWidget {
  const IdReferenciaView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<IdReferenciaViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.tareas,
                'buscarIdRef',
              ),
              style: AppTheme.style(
                Styles.title,
              ),
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
                      onChanged: (criterio) => vm.buscarRefTemp(context),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'buscar',
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
                          )} (${vm.idReferencias.length})",
                          style: AppTheme.style(
                            Styles.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    _ReferenciasEncontradas()
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
            color: AppTheme.color(
              Styles.loading,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _ReferenciasEncontradas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final vmCrear = Provider.of<CrearTareaViewModel>(context);
    final vm = Provider.of<IdReferenciaViewModel>(context);

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: vm.idReferencias.length,
      itemBuilder: (BuildContext context, int index) {
        final IdReferenciaModel referencia = vm.idReferencias[index];
        return GestureDetector(
          onTap: () => vmCrear.seleccionarIdRef(
            context,
            referencia,
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1.5,
                  color: AppTheme.color(
                    Styles.greyBorder,
                  ),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    referencia.descripcion,
                    style: AppTheme.style(
                      Styles.normal,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${AppLocalizations.of(context)!.translate(
                          BlockTranslate.tareas,
                          'idRef',
                        )}: ",
                        style: AppTheme.style(
                          Styles.normal,
                        ),
                      ),
                      Text(
                        referencia.referenciaId,
                        style: AppTheme.style(
                          Styles.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
