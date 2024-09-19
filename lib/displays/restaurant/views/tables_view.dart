import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/widgets/widgets.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class TablesView extends StatefulWidget {
  const TablesView({Key? key}) : super(key: key);

  @override
  State<TablesView> createState() => _TablesViewState();
}

class _TablesViewState extends State<TablesView> {
  @override
  void initState() {
    super.initState();
    // Conexión al WebSocket cuando se entra a la pantalla
    final TablesViewModel tablesVM = Provider.of<TablesViewModel>(
      context,
      listen: false,
    );
    tablesVM.connectWebSocket(context);
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Text(
                                AppLocalizations.of(context)!.translate(
                                  BlockTranslate.restaurante,
                                  'ubicaciones',
                                ),
                                style: StyleApp.normal,
                              ),
                            ),
                            Text(
                              vmLoc.location!.descripcion,
                              style: StyleApp.normalBold,
                            ),
                          ],
                        ),
                      ),
                      RegisterCountWidget(count: vm.tables.length),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => vm.loadData(context),
                    child: ListView.builder(
                      itemCount: vm.tables.length,
                      itemBuilder: (BuildContext context, int index) {
                        TableModel table = vm.tables[index];
                        return CardTableWidget(
                          mesa: table,
                          onTap: () => vm.navigateClassifications(
                            context,
                            table,
                            index,
                          ),
                        );
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
