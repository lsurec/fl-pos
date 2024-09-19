import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/restaurant/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/widgets/widgets.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/themes.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class LocationsView extends StatelessWidget {
  const LocationsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<LocationsViewModel>(context);

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)!.translate(
                BlockTranslate.restaurante,
                'ubicaciones',
              ),
              style: StyleApp.title,
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                RegisterCountWidget(count: vm.locations.length),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => vm.loadData(context),
                    child: ListView.builder(
                      itemCount: vm.locations.length,
                      itemBuilder: (BuildContext context, int index) {
                        LocationModel ubicacion = vm.locations[index];
                        return CardLocationsWidget(
                          ubicacion: ubicacion,
                          onTap: () => vm.navigateTables(
                            context,
                            ubicacion,
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
