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
                ListView.builder(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: _CardDoc(),
                    );
                  },
                ),
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
                  onPressed: () => vm.navigateLoc(context),
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

class _CardDoc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.home,
                  'idDoc',
                )} 45",
                style: AppTheme.style(
                  context,
                  Styles.bold,
                ),
              ),
              Text(
                "${AppLocalizations.of(context)!.translate(
                  BlockTranslate.general,
                  'usuario',
                )}: sa",
                style: AppTheme.style(
                  context,
                  Styles.bold,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => {},
          child: CardWidget(
            color: AppTheme.color(
              context,
              Styles.secondBackground,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextsWidget(
                    title: AppLocalizations.of(context)!.translate(
                      BlockTranslate.cotizacion,
                      'idRef',
                    ),
                    text: '5451515',
                  ),
                  const SizedBox(height: 5),
                  TextsWidget(
                    title: AppLocalizations.of(context)!.translate(
                      BlockTranslate.cotizacion,
                      'cuenta',
                    ),
                    text: 'Juan Hernandez',
                  ),
                  const SizedBox(height: 5),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'fechaHora',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      Text(
                        '12/12/2012 12:12:12',
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.translate(
                          BlockTranslate.fecha,
                          'fechaDoc',
                        ),
                        style: AppTheme.style(
                          context,
                          Styles.bold,
                        ),
                      ),
                      Text(
                        '12/12/2012 12:12:12',
                        style: AppTheme.style(
                          context,
                          Styles.normal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  TextsWidget(
                      title: "${AppLocalizations.of(context)!.translate(
                        BlockTranslate.factura,
                        'serieDoc',
                      )}: ",
                      text: "COT (1)"),
                  const SizedBox(height: 5),

                  // if (document.observacion1 != null ||
                  //     document.observacion1 != "")
                  //   TextsWidget(
                  //     title: "${AppLocalizations.of(context)!.translate(
                  //       BlockTranslate.general,
                  //       'observacion',
                  //     )}: ",
                  //     text: document.observacion1 ?? "",
                  //   ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}
