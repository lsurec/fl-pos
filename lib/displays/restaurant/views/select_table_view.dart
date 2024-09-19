import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/widgets/widgets.dart';
import 'package:flutter_post_printer_example/routes/app_routes.dart';
import 'package:flutter_post_printer_example/services/notification_service.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class SelectTableView extends StatelessWidget {
  const SelectTableView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final int tipoAccion = ModalRoute.of(context)!.settings.arguments as int;

    final vm = Provider.of<TablesViewModel>(context);
    final vmLoc = Provider.of<LocationsViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              vmLoc.location!.descripcion,
              style: StyleApp.title,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  //TODO: traslate
                  "Nueva Mesa",
                  style: StyleApp.title,
                ),
                RegisterCountWidget(count: vm.tables.length),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => vm.loadData(context),
                    child: ListView.builder(
                      itemCount: vm.tables.length,
                      itemBuilder: (BuildContext context, int index) {
                        TableModel table = vm.tables[index];
                        return CardTableWidget(
                            mesa: table,
                            onTap: () {
                              //Al terminar restaurar mesa

                              final TablesViewModel tableVM =
                                  Provider.of<TablesViewModel>(
                                context,
                                listen: false,
                              );

                              final TransferSummaryViewModel transferVM =
                                  Provider.of<TransferSummaryViewModel>(
                                context,
                                listen: false,
                              );

                              tableVM.selectNewtable(table);

                              transferVM.setTableDest(table);

                              if (tipoAccion == 45) {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.selectAccount,
                                  arguments: {
                                    "screen": 3,
                                    "action": tipoAccion,
                                  },
                                );
                                return;
                              }

                              if (transferVM.locationDest!.elementoAsignado ==
                                      transferVM
                                          .locationOrigin!.elementoAsignado &&
                                  transferVM.tableDest!.elementoAsignado ==
                                      transferVM
                                          .tableOrigin!.elementoAsignado) {
                                NotificationService.showSnackbar(
                                    "La cuenta ya existe en esta mesa");
                                return;
                              }

                              if (tipoAccion == 32) {
                                Navigator.pushNamed(
                                    context, AppRoutes.transferSummary,
                                    arguments: tipoAccion);
                              }
                            });
                      },
                    ),
                  ),
                ),
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
