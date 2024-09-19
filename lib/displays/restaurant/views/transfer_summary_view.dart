import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class TransferSummaryView extends StatelessWidget {
  const TransferSummaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Datos simulados para el origen y el destino
    final TransferSummaryViewModel vm =
        Provider.of<TransferSummaryViewModel>(context);

    final OrderViewModel orderVM = Provider.of<OrderViewModel>(context);
    final int tipoAccion = ModalRoute.of(context)!.settings.arguments as int;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text(
              //TODO: translate
              'Resumen de Traslado',
              style: StyleApp.title,
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        //TODO: traducir
                        "Origen",
                        style: StyleApp.title,
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      const SizedBox(height: 5),
                      TextsWidget(
                        title: "Ubicacion: ",
                        text: vm.locationOrigin!.descripcion,
                      ),
                      const SizedBox(height: 5),
                      TextsWidget(
                        title: "Mesa: ",
                        text: vm.tableOrigin!.descripcion,
                      ),
                      const SizedBox(height: 5),
                      if (tipoAccion == 45)
                        TextsWidget(
                          title: "Cuenta: ",
                          text: orderVM.orders[vm.indexOrderOrigin].nombre,
                        ),
                    ],
                  ),
                ),
                Container(
                  color: const Color.fromARGB(255, 227, 226, 226),
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        //TODO: traducir
                        "Destino",
                        style: StyleApp.title,
                      ),
                      const SizedBox(height: 5),
                      const Divider(),
                      const SizedBox(height: 5),
                      TextsWidget(
                        title: "Ubicacion: ",
                        text: vm.locationDest!.descripcion,
                      ),
                      const SizedBox(height: 5),
                      TextsWidget(
                        title: "Mesa: ",
                        text: vm.tableDest!.descripcion,
                      ),
                      const SizedBox(height: 5),
                      if (tipoAccion == 45)
                        TextsWidget(
                          title: "Cuenta: ",
                          text: orderVM.orders[vm.indexOrderDest].nombre,
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: _Options(tipoAccion: tipoAccion),
                )
              ],
            ),
          ),
        ),
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

class _Options extends StatelessWidget {
  final int tipoAccion;

  const _Options({super.key, required this.tipoAccion});

  @override
  Widget build(BuildContext context) {
    final TransferSummaryViewModel vm =
        Provider.of<TransferSummaryViewModel>(context);
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primary),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: tipoAccion == 45
                    ? () => vm.cancelTransfer(context)
                    : () => vm.cancelAccount(context),
                child: Center(
                  child: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.botones,
                        'cancelar',
                      ),
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 17,
                      )),
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                //TODO: cambiar al color de preferencia
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                onTap: tipoAccion == 45
                    ? () => vm.moveTransaction(context)
                    : () => vm.moveTable(context),
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.translate(
                      BlockTranslate.botones,
                      'confirmar',
                    ),
                    style: StyleApp.whiteBold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
