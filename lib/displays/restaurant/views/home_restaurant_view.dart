import 'package:flutter/material.dart';
import 'package:flutter_post_printer_example/displays/prc_documento_3/models/models.dart';
import 'package:flutter_post_printer_example/displays/restaurant/view_models/view_models.dart';
import 'package:flutter_post_printer_example/services/services.dart';
import 'package:flutter_post_printer_example/themes/app_theme.dart';
import 'package:flutter_post_printer_example/utilities/styles_utilities.dart';
import 'package:flutter_post_printer_example/utilities/translate_block_utilities.dart';
import 'package:flutter_post_printer_example/view_models/view_models.dart';
import 'package:flutter_post_printer_example/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeRestaurantView extends StatelessWidget {
  const HomeRestaurantView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeRestaurantViewModel>(context);
    final vmMenu = Provider.of<MenuViewModel>(context);

    return Stack(
      children: [
        DefaultTabController(
          length: 2, // Número de pestañas
          child: Scaffold(
            appBar: AppBar(
              title: Text(
                vmMenu.name,
                style: AppTheme.style(
                  context,
                  Styles.title,
                ),
              ),
              bottom: TabBar(
                labelColor: AppTheme.color(
                  context,
                  Styles.normal,
                ),
                indicatorColor: AppTheme.color(
                  context,
                  Styles.darkPrimary,
                ),
                //TODO:Translate
                tabs: const [
                  Tab(text: "Accesos"),
                  Tab(text: "Mesas abiertas"),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // Contenido de la primera pestaña
                const _AccesTab(),
                Container(),
                // Contenido de la segunda pestaña
              ],
            ),
          ),
        ),
        if (vm.isLoading)
          ModalBarrier(
            dismissible: false,
            // color: Colors.black.withOpacity(0.3),
            color: AppTheme.color(
              context,
              Styles.loading,
            ),
          ),
        if (vm.isLoading) const LoadWidget(),
      ],
    );
  }
}

class _AccesTab extends StatelessWidget {
  const _AccesTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<HomeRestaurantViewModel>(context);

    return RefreshIndicator(
      onRefresh: () => vm.loadData(context),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.translate(
                    BlockTranslate.general,
                    'serie',
                  ),
                  style: AppTheme.style(
                    context,
                    Styles.title,
                  ),
                ),
                if (vm.series.isEmpty)
                  NotFoundWidget(
                    text: AppLocalizations.of(context)!.translate(
                      BlockTranslate.notificacion,
                      'sinElementos',
                    ),
                    icon: const Icon(
                      Icons.browser_not_supported_outlined,
                      size: 50,
                    ),
                  ),
                if (vm.series.isNotEmpty)
                  DropdownButton<SerieModel>(
                    isExpanded: true,
                    dropdownColor: AppTheme.color(
                      context,
                      Styles.background,
                    ),
                    hint: Text(
                      AppLocalizations.of(context)!.translate(
                        BlockTranslate.factura,
                        'opcion',
                      ),
                    ),
                    value: vm.serieSelect,
                    onChanged: (value) => vm.changeSerie(value, context),
                    items: vm.series.map(
                      (serie) {
                        return DropdownMenuItem<SerieModel>(
                          value: serie,
                          child: Text(serie.descripcion!),
                        );
                      },
                    ).toList(),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => {},
                  style: AppTheme.button(
                    context,
                    Styles.buttonStyle,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(
                      child: Text(
                        "Empezar",
                        style: AppTheme.style(
                          context,
                          Styles.whiteBoldStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
